#!/usr/bin/env python3
import json
import os
import subprocess
import urllib.parse
import urllib.request
from typing import Any
from urllib.parse import urlencode

# These are hardcoded because
# 1) We are using abook for address book and
# 2) Microsoft contacts are not supported
ABOOK_FILE: str = os.path.expanduser("~/.abook/addressbook")
CLIENTIDPATH: str = "gmailcom/clientid"
CLIENTSECRETPATH: str = "gmailcom/clientsecret"
REFRESHTOKENPATH: str = "gmailcom/refreshtoken"
TOKENPATH: str = "gmailcom/tokenendpoint"
PEOPLEAPIURL: str = r"https://people.googleapis.com/v1/people/me/connections"


def get_secret(path: str) -> str:
    return subprocess.check_output(["pass", path]).decode("utf-8").strip()


def get_access_token() -> str:
    url: str = get_secret(TOKENPATH)
    params: dict[str, str] = {
        "client_id": get_secret(CLIENTIDPATH),
        "client_secret": get_secret(CLIENTSECRETPATH),
        "refresh_token": get_secret(REFRESHTOKENPATH),
        "grant_type": "refresh_token",
    }
    data: bytes = urllib.parse.urlencode(params).encode("utf-8")
    req: urllib.request.Request = urllib.request.Request(url, data=data)
    with urllib.request.urlopen(req) as r:
        return json.loads(r.read())["access_token"]


def pull_contacts(token: str) -> list[dict]:
    all_connections: list[Any] = []
    next_page_token: str | None = None

    # We loop until Google stops giving us a nextPageToken
    while True:
        params: dict[str, str] = {
            "personFields": "names,emailAddresses,addresses,phoneNumbers,urls,biographies",
            "pageSize": "1000",
        }

        # If we have a token from the previous loop, append it to the URL
        if next_page_token:
            params["pageToken"] = next_page_token

        parameters: str = urlencode(params)
        url: str = f"{PEOPLEAPIURL}?{parameters}"

        req = urllib.request.Request(url, headers={"Authorization": f"Bearer {token}"})

        with urllib.request.urlopen(req) as r:
            data: dict = json.loads(r.read())

            # Add this page's contacts to our master list
            connections = data.get("connections", [])
            all_connections.extend(connections)

            # Check if there is another page
            next_page_token = data.get("nextPageToken")

            # If no more pages, break the loop
            if not next_page_token:
                break

    return all_connections


def write_to_abook(connections: list[dict]) -> None:
    if not connections:
        print("No contacts found. Aborting.")
        return

    with open(ABOOK_FILE, "w") as f:
        count: int = 0
        for person in connections:
            # Name
            names: list[dict] = person.get("names", [])
            display_name: str = names[0].get("displayName", "") if names else ""

            # Emails
            emails: list[dict] = [
                e.get("value") for e in person.get("emailAddresses", [])
            ]

            # Skip contacts without emails for NeoMutt efficiency
            if not emails:
                continue

            # Phone (Abook usually takes one main work/home/mobile string)
            phones: list[dict] = [
                p.get("value") for p in person.get("phoneNumbers", [])
            ]
            phone_str: dict | str = phones[0] if phones else ""

            # Address (Formatted string)
            addrs: list[str] = person.get("addresses", [])
            addr_str: str = (
                addrs[0].get("formattedValue", "").replace("\n", ", ") if addrs else ""
            )

            # URL/Website
            urls: list[str] = [u.get("value") for u in person.get("urls", [])]
            url_str: str = urls[0] if urls else ""

            # Notes (Google uses 'biographies' for the main notes field)
            bios: list[str] = person.get("biographies", [])
            note_str: str = bios[0].get("value", "").replace("\n", " ") if bios else ""
            resource_id: str = person.get("resourceName", "")

            # Write to Abook Format
            f.write(f"[{count}]\n")
            f.write(f"name={display_name}\n")
            f.write(f"email={','.join(emails)}\n")
            if phone_str:
                f.write(f"phone={phone_str}\n")
            if addr_str:
                f.write(f"address={addr_str}\n")
            if url_str:
                f.write(f"url={url_str}\n")
            f.write(f"notes=ID: {resource_id} | {note_str}\n")
            f.write("\n")

            count += 1


if __name__ == "__main__":
    print("****************************************")
    print("OAUTH2 GMAIL CONTACTS DOWNLOAD TOOL")
    print("****************************************")
    print(r"https://github.com/StrayFeral/dewlinux")
    print("")

    try:
        print("Authenticating with Google...")
        token: str = get_access_token()

        print("Pulling all contact details...")
        contacts: list[Any] = pull_contacts(token)

        # print(f"Writing {len(contacts)} contacts to {ABOOK_FILE}...")
        print(f"Writing {len(contacts)} contacts to abook address book...")
        write_to_abook(contacts)
        
        print("")
        print("All contacts downloaded.")

    except Exception as e:
        print(f"Error: {e}")

import subprocess
import sys
from typing import Dict

import requests
from requests.models import Response


def get_pass_secret(path: str) -> str:
    try:
        # Using full path /usr/bin/pass is safer for AppArmor/Cron/msmtp
        result: subprocess.CompletedProcess = subprocess.run(
            ["/usr/bin/pass", path], capture_output=True, text=True, check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        # Sending error to stderr so it doesn't pollute the password output
        sys.stderr.write(f"Pass failed for {path}: {e.stderr}\n")
        sys.exit(1)


def store_pass_secret(path: str, value: str) -> None:
    # We use 'pass insert -m' to allow multi-line/piped input
    # The -f flag forces an overwrite if the secret already exists
    result: subprocess.CompletedProcess = subprocess.run(
        ["/usr/bin/pass", "insert", "--multiline", "-f", path],
        input=value,  # This pipes the secret into the command
        text=True,
        capture_output=True,
        check=True,
    )


def get_temporary_access_token(email_provider: str) -> str:
    try:
        api_url: str = get_pass_secret(f"{email_provider}/tokenendpoint")
        client_id: str = get_pass_secret(f"{email_provider}/clientid")
        client_secret: str = get_pass_secret(f"{email_provider}/clientsecret")
        refresh_token: str = get_pass_secret(f"{email_provider}/refreshtoken")

        post_data: Dict[str, str] = {
            "client_id": client_id,
            "client_secret": client_secret,
            "refresh_token": refresh_token,
            "grant_type": "refresh_token",
        }

        # Microsoft requires a scope
        if email_provider != "gmailcom":
            post_data["scope"] = (
                "offline_access https://outlook.office.com/IMAP.AccessAsUser.All"
            )

        response: Response = requests.post(api_url, data=post_data, timeout=5)
        response.raise_for_status()

        # We should always check
        new_refresh_token = response.json().get("refresh_token", "")
        if new_refresh_token:
            store_pass_secret(f"{email_provider}/refreshtoken", new_refresh_token)

        # Print ONLY the access_token for msmtp to read
        return response.json()["access_token"]

    except Exception as e:
        sys.stderr.write(f"OAuth2 Exchange Failed: {str(e)}\n")
        sys.exit(1)


if __name__ == "__main__":
    # Check if a path was provided as an argument
    if len(sys.argv) < 2:
        sys.stderr.write(
            "Usage: python3 get_mail_secret.py <pass_path|EMAILPROVIDERHERE/temporary_access_token>\n"
        )
        sys.stderr.write("Example: python3 get_mail_secret.py gmailcom/refreshtoken\n")
        sys.stderr.write(
            "         python3 get_mail_secret.py outlookcom/temporary_access_token\n"
        )
        sys.exit(1)

    path: str = sys.argv[1]

    if "/" not in path:
        raise Exception("Invalid pass path! Correct format: 'something/somethingelse'")

    email_provider: str = path.split("/")[0]
    keyname: str = path.split("/")[1]

    if keyname == "temporary_access_token":
        token: str = get_temporary_access_token(email_provider)
        if not token:
            raise Exception("Cannot get the temporary access token!")

        print(token)

    else:
        secret: str | None = get_pass_secret(path)

        if not secret:
            raise Exception("Cannot get the secret from 'pass' store!")

        print(secret)

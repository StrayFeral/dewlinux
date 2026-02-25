#!/usr/bin/env python3

import base64
import getpass
import json
import secrets
import subprocess
import sys
from typing import Dict, List
from urllib.parse import ParseResult, parse_qs, urlencode, urlparse

import requests
from requests.models import Response

usage_str: str = (
    "USAGE: oauth2_config.py <EMAILPROVIDER>\nEXAMPLE: oauth2_config.py outlook.com"
)


class OAuth2Authorizer:
    """Class for doing OAUTH2 email setup for GMail and Outlook/Hotmail.

    NOTE: TESTED ONLY WITH GMAIL!
    """

    __providers_url: Dict[str, str] = {
        "gmailcom": "https://accounts.google.com",
        "outlookcom": "https://login.microsoftonline.com/common/v2.0",
        "hotmailcom": "https://login.microsoftonline.com/common/v2.0",
        "livecom": "https://login.microsoftonline.com/common/v2.0",
    }

    __scopes: Dict[str, List[str]] = {
        "gmailcom": [
            # Scopes both for gmail and the contacts
            r"https://mail.google.com/",
            r"https://www.googleapis.com/auth/contacts",
            r"https://www.googleapis.com/auth/contacts.other.readonly",
        ],
        "outlookcom": [
            r"offline_access",
            r"https://outlook.office.com/IMAP.AccessAsUser.All",
        ],
        "hotmailcom": [
            r"offline_access",
            r"https://outlook.office.com/IMAP.AccessAsUser.All",
        ],
        "livecom": [
            r"offline_access",
            r"https://outlook.office.com/IMAP.AccessAsUser.All",
        ],
    }

    __discovery_endpoint: str = r"/.well-known/openid-configuration"
    __redirect_url: str = r"http://localhost"

    def __init__(self, email_provider: str, client_id: str, client_secret: str) -> None:
        self.client_id: str = client_id
        self.client_secret: str = client_secret
        self.authorization_code: str = ""
        self.email_provider: str = email_provider

        self.token_endpoint_url: str = ""
        self.auth_endpoint_url: str = ""

        # Security feature
        self.csrf_token: str = ""

    def __generate_state(self, context_data: Dict[str, str]) -> str:
        """Creates a URL-safe, Base64-encoded state string containing
        a random CSRF token and custom app context.
        """

        # 1. Create a cryptographically strong random token
        csrf_token: str = secrets.token_urlsafe(32)

        # 2. Store this token in your session/database here!
        self.csrf_token = csrf_token

        # 3. Combine with your app context (like where to redirect the user)
        # Unlike "redirect_uri" in the final request which serves
        # the authorization_code being returned to our app,
        # the return_to serves if we want the user to return to a
        # specific state in our own app. However since this is an
        # installer, it does not care what the value of this is
        state_param: Dict[str, str] = {
            "csrf": csrf_token,
            "return_to": context_data.get("return_to", "/dashboard"),
        }

        # 4. Serialize to JSON and encode to Base64 (URL-safe)
        json_state = json.dumps(state_param).encode("utf-8")

        return base64.urlsafe_b64encode(json_state).decode("utf-8").rstrip("=")

    def __verify_state(self, received_state: str | None) -> dict:
        """Decodes the state and verifies the CSRF token matches."""

        if not received_state:
            raise Exception("No state received. Potential CSRF sttack?")

        # Add padding back if it was stripped
        padded_state = received_state + "=" * (4 - len(received_state) % 4)

        # Decode
        decoded_bytes = base64.urlsafe_b64decode(padded_state)
        state_data = json.loads(decoded_bytes)

        # 5. The Critical Security Check
        if not secrets.compare_digest(state_data.get("csrf", ""), self.csrf_token):
            raise ValueError("State mismatch! Potential CSRF attack.")

        return state_data

    def __get_discovery_url_by_email(self) -> str:
        """Adds more execution time, but also more abstraction.
        And since this time will be lost only during the setup phase,
        I really do not care.
        """

        issuer_url: str | None = self.__providers_url.get(self.email_provider)

        if not issuer_url:
            raise ValueError(f"Domain '{self.email_provider}' is not supported yet.")

        discovery_url: str = issuer_url.rstrip("/") + self.__discovery_endpoint
        return discovery_url

    def discover(self) -> None:
        discovery_url: str = self.__get_discovery_url_by_email()

        response: Response = requests.get(discovery_url, timeout=5)
        response.raise_for_status()  # Check for errors
        config_data = response.json()

        self.auth_endpoint_url = config_data.get("authorization_endpoint")
        self.token_endpoint_url = config_data.get("token_endpoint")

    def get_authorization_url(self) -> str:
        """Returns the authorization URL which the user must manually
        paste into the browser, in order to get the response URL with
        the authorization code.
        """

        # Common URL parameters for all email providers
        params: Dict[str, str] = {
            "client_id": self.client_id,
            "redirect_uri": self.__redirect_url,
            "response_type": "code",
            "scope": " ".join(self.__scopes[self.email_provider]),
            "access_type": "offline",
            "prompt": "consent",
            "state": self.__generate_state({"return_to": "nowhere"}),
        }

        # Specific email provider parameter differences
        if self.email_provider == "gmailcom":
            params["access_type"] = "offline"
        else:
            params["response_mode"] = "query"

        parameters: str = urlencode(params)

        # User needs to manually paste this, so they manually click "Allow"
        auth_url: str = f"{self.auth_endpoint_url}?{parameters}"
        return auth_url

    def get_authorization_code(self, authorization_response_url: str) -> str:
        """Filters the authorization code out of the
        authorization response url."""
        # After "Allow", browser will unsuccessfully redirect
        # The user needs to paste the full redirect URL in this

        parsed_url: ParseResult = urlparse(authorization_response_url)

        # We need to get the AuthorizationCode out of this URL
        params: Dict[str, List[str]] = parse_qs(parsed_url.query)

        # Note: parse_qs returns lists for values (because keys can appear multiple times)
        authorization_code: str | None = (
            params.get("code")[0] if params.get("code") else None
        )
        received_state: str | None = (
            params.get("state")[0] if params.get("state") else None
        )

        if not authorization_code:
            raise Exception(
                f"Cannot get the authorization code out of the response url({authorization_response_url})"
            )

        # Since this is an installer application we really do not care
        # of the actual state data, but just in case we verify the
        # CSRF token
        verified_state_data: Dict[str, str] = self.__verify_state(received_state)

        return authorization_code

    def get_refresh_token(self, authorization_code: str) -> str:
        """After the response URL was returned, it contains the
        authorization code, which comes as an argument to this method.
        """

        # Data to be sent
        # We will get a JSON object in return
        post_data: Dict[str, str] = {
            "code": authorization_code,  # AuthorizationCode
            "client_id": self.client_id,  # ClientID
            "client_secret": self.client_secret,  # ClientSecret
            "redirect_uri": self.__redirect_url,
            "grant_type": "authorization_code",
        }

        # A POST request to the API
        # We are looking for a refresh token here
        response: Response = requests.post(
            self.token_endpoint_url, data=post_data, timeout=10
        )

        # Check for HTTP errors (400, 500, etc.)
        response.raise_for_status()

        tokens = response.json()
        refresh_token = tokens.get("refresh_token")

        if not refresh_token:
            raise Exception(
                "Warning: No refresh_token returned. Did you use 'prompt=consent' in the auth URL?"
            )

        return refresh_token


def store_pass_secret(path: str, value: str) -> None:
    # We use 'pass insert -m' to allow multi-line/piped input
    # The -f flag forces an overwrite if the secret already exists
    result: subprocess.CompletedProcess = subprocess.run(
        ["pass", "insert", "--multiline", "-f", path],
        input=value,  # This pipes the secret into the command
        text=True,
        capture_output=True,
        check=True,
    )


def get_email_provider(s: str) -> str:
    s = s.split("@")[-1].lower()
    s = s.replace(".", "")  # "gmailcom"

    if not s:
        raise Exception(usage_str)

    return s


if __name__ == "__main__":
    if len(sys.argv) < 1:
        raise Exception(usage_str)

    email_provider: str = get_email_provider(sys.argv[1])

    print("")
    print("****************************************")
    print("OAUTH2 EMAIL/CONTACTS CONFIGURATION TOOL")
    print("****************************************")
    print(r"https://github.com/StrayFeral/dewlinux")
    print("")
    print("FIRST BE SURE YOU DID THE **CLOUD** (GCP/AZURE) APP SETUP!")
    print("")
    print("If you still haven't, just go and do it now,")
    print("no need to interrupt this script.")
    print("")
    print("If you do not know how to do it, just follow the")
    print("instructions from this youtube video:")
    print("")
    print(
        r"FIXME: https://www.youtube.com/watch?v=bJ9jYlJb7Mc"
    )  # TODO: FIX MEEEEEEEEEEE
    print("")
    print("NOTE: When typing the answers to the folowing questions,")
    print("      the characters for your CLIENT SECRET will be hidden.")
    print("")

    client_id: str = input("Enter your CLIENT ID     : ")
    client_secret: str = getpass.getpass("Enter your CLIENT SECRET : ")

    authorizer: OAuth2Authorizer = OAuth2Authorizer(
        email_provider, client_id, client_secret
    )
    authorizer.discover()
    authorization_url: str = authorizer.get_authorization_url()

    print("")
    print("============================== PASTE THIS URL IN YOUR BROWSER")
    print(authorization_url)
    print("=============================================================")
    print("And follow the on-screen instructions, click 'Allow' to authorize")
    print("this app.")
    print("")
    print("Your browser will try to follow a redirect and will fail which is")
    print("what we expect. When this happens, copy the URL from the adress bar")
    print("on the line below and press ENTER...")
    print("")

    failed_redirect_url: str = input("Enter the failed redirect URL  : ")
    authorization_code: str = authorizer.get_authorization_code(failed_redirect_url)

    print("")
    print("Sending request to the cloud API to get the refresh token...")
    refresh_token: str = authorizer.get_refresh_token(authorization_code)

    # Storing everything in "pass"
    store_pass_secret(
        f"{authorizer.email_provider}/tokenendpoint", authorizer.token_endpoint_url
    )
    store_pass_secret(f"{authorizer.email_provider}/clientid", client_id)
    store_pass_secret(f"{authorizer.email_provider}/clientsecret", client_secret)
    store_pass_secret(f"{authorizer.email_provider}/refreshtoken", refresh_token)
    print("Secrets stored.")

    print("")
    print("OAUTH2 AUTHORIZATION AND CONFIGURATION COMPLETED.")

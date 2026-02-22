# /usr/bin/env puthon3

import getpass
import re
import subprocess
import sys
from typing import Dict
from urllib.parse import urlencode

import requests
from requests.models import Response


class MailAuthorizer:
    """Class for doing OAUTH2 email setup for GMail and Outlook/Hotmail.

    NOTE: TESTED ONLY WITH GMAIL!
    """

    __providers_url: Dict[str, str] = {
        "gmail.com": "https://accounts.google.com",
        "outlook.com": "https://login.microsoftonline.com/common/v2.0",
        "hotmail.com": "https://login.microsoftonline.com/common/v2.0",
        "live.com": "https://login.microsoftonline.com/common/v2.0",
    }

    __scopes: Dict[str, str] = {
        "gmail.com": r"https://mail.google.com/",
        "outlook.com": "ssssssssss",  # FIXME:
        "hotmail.com": "sssssss",  # FIXME:
        "live.com": "sssss",  # FIXME:
    }

    __discovery_endpoint: str = r"/.well-known/openid-configuration"
    __redirect_url: str = r"http://localhost"

    def __init__(self, email: str, client_id: str, client_secret: str) -> None:
        self.client_id: str = client_id
        self.client_secret: str = client_secret
        self.authorization_code: str = ""
        self.email_provider: str = email.split("@")[-1].lower()

        self.token_endpoint_url: str = ""
        self.auth_endpoint_url: str = ""

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

        params: Dict[str, str] = {
            "client_id": self.client_id,
            "redirect_uri": self.__redirect_url,
            "response_type": "code",
            "scope": self.__scopes[self.email_provider],
            "access_type": "offline",
            "prompt": "consent",
        }

        parameters: str = urlencode(params)

        # User needs to manually paste this, so they manually click "Allow"
        auth_url: str = f"{self.auth_endpoint_url}?{parameters}"
        return auth_url

    def get_authorization_code(self, authorization_response_url: str) -> str:
        """Filters the authorization code out of the
        authorization response url."""
        # After "Allow", browser will unsuccessfully redirect
        # The user needs to paste the full redirect URL in this

        # We need to get the AuthorizationCode out of this URL
        pattern: str = r"code=([^&]+)"
        authorization_code: str = ""
        match: re.Match[str] | None = re.search(pattern, authorization_response_url)
        if match:
            authorization_code = match.group(1)
        else:
            raise Exception(
                f"Cannot get the authorization code out of the response url({authorization_response_url})"
            )

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


def store_secret(secret_name: str, secret_value: str):
    # We use 'pass insert -m' to allow multi-line/piped input
    # The -f flag forces an overwrite if the secret already exists
    result: subprocess.CompletedProcess = subprocess.run(
        ["pass", "insert", "--multiline", "-f", secret_name],
        input=secret_value,  # This pipes the secret into the command
        text=True,
        capture_output=True,
        check=True,
    )


if __name__ == "__main__":
    if len(sys.argv) < 1:
        raise Exception(
            "USAGE: python3 oauth2_mail_config.py 'YOUREMAILADDRESSHERE@blah.com'"
        )

    email: str = sys.argv[1]

    print("")
    print("****************************************")
    print("OAUTH2 EMAIL NEOMUTT CONFIGURATION")
    print("****************************************")
    print("")
    print("FIRST BE SURE YOU DID THE **CLOUD** (GCP/AZURE) APP SETUP!")
    print("")
    print("INSTRUCTIONS:")
    print("")
    print("If you still haven't, just go and do it now,")
    print("no need to interrupt this script.")
    print("To do the GCP APP setup, go to this URL:")
    print("")
    print(r"https://console.cloud.google.com/")
    print("")
    print("If you do not know what to do there, just follow the")
    print("instructions from this youtube video:")
    print("")
    print(
        r"FIXME: https://www.youtube.com/watch?v=bJ9jYlJb7Mc"
    )  # TODO: FIX MEEEEEEEEEEE
    print("")
    print("NOTE: When typing the answers to the folowing questions,")
    print("      the characters for your CLIENT SECRET will be hidden.")
    print("")

    print(f"Your email               : {email}")
    client_id: str = input("Enter your CLIENT ID     : ")
    client_secret: str = getpass.getpass("Enter your CLIENT SECRET : ")

    authorizer: MailAuthorizer = MailAuthorizer(email, client_id, client_secret)
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
    print("Sending request to the cloud API to get the refresh token...")
    refresh_token: str = authorizer.get_refresh_token(authorization_code)

    # Storing everything in "pass"
    store_secret("gmail/tokenendpoint", authorizer.token_endpoint_url)
    store_secret("gmail/clientid", client_id)
    store_secret("gmail/clientsecret", client_secret)
    store_secret("gmail/refreshtoken", refresh_token)
    print("Secrets stored.")

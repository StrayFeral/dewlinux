# /usr/bin/env puthon3

import re
import json
import getpass
import requests
import subprocess
from typing import Pattern, Match, Dict
from requests.models import Response


class GMailAuthorizer:
    def __init__(self, client_id: str, client_secret: str) -> None:
        self.client_id: str = client_id
        self.client_secret: str = client_secret
        self.authorization_code: str = ""
        self.api_url: str = r"https://oauth2.googleapis.com/token"

    def get_authorization_url(self) -> str:
        """Returns the authorization URL which the user must manually
        paste into the browser, in order to get the response URL with
        the authorization code.
        """

        url: str = (
            r"https://accounts.google.com/o/oauth2/v2/auth?client_id=YOUR_CLIENT_ID&redirect_uri=http://localhost&response_type=code&scope=https://mail.google.com/&access_type=offline&prompt=consent"
        )

        # User needs to manually paste this, so they manually click "Allow"
        auth_url: str = url.replace(r"YOUR_CLIENT_ID", self.client_id)
        return auth_url

    def get_authorization_code(self, authorization_response_url: str) -> str:
        """Filters the authorization code out of the
        authorization response url."""
        # After "Allow", browser will unsuccessfully redirect
        # The user needs to paste the full redirect URL in this

        # We need to get the AuthorizationCode out of this URL
        pattern: str = r'code=([^&]+)'
        authorization_code: str = ""
        match: Match[str] = re.search(pattern, authorization_response)
        if match:
            authorization_code = match.group(1)
        else:
            raise Exception(
                f"Cannot get the authorization code out of the response url({self.auth_response})"
            )
        
        return authorization_code
    
    
    def get_refresh_token(self, authorization_code: str) -> str:
        """After the response URL was returned, it contains the
        authorization code, which comes as an argument to this method.
        """

        # Data to be sent
        # We will get a JSON object in return
        post_data: Dict[str:str] = {
            "code": authorization_code,  # AuthorizationCode
            "client_id": self.client_id,  # ClientID
            "client_secret": self.client_secret,  # ClientSecret
            "redirect_uri": r"http://localhost",
            "grant_type": "authorization_code",
        }

        # A POST request to the API
        # We are looking for a refresh token here
        response: Response = requests.post(self.api_url, data=post_data, timeout=10)
        
        # Check for HTTP errors (400, 500, etc.)
        response.raise_for_status()
        
        tokens = response.json()
        refresh_token = tokens.get("refresh_token")
        
        if not refresh_token:
            raise Exception("Warning: No refresh_token returned. Did you use 'prompt=consent' in the auth URL?")
        
        return refresh_token

def store_secret(secret_name: str, secret_value: str):
    # We use 'pass insert -m' to allow multi-line/piped input
    # The -f flag forces an overwrite if the secret already exists
    result: str = subprocess.run(
        ["pass", "insert", "--multiline", "-f", secret_name],
        input=secret_value,  # This pipes the secret into the command
        text=True,
        capture_output=True,
        check=True,
    )


if __name__ == "__main__":
    print("")
    print("****************************************")
    print("GMAIL NEOMUTT CONFIGURATION")
    print("****************************************")
    print("")
    print("FIRST BE SURE YOU DID THE GCP APP SETUP!")
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
    print("      the characters for your GMAIL PASSWORD and the")
    print("      CLIENT SECRET will be hidden.")
    print("")

    # account_password: str = getpass.getpass("Enter your GMAIL password      : ")
    client_id: str = input("Enter your GMAIL CLIENT ID     : ")
    client_secret: str = getpass.getpass("Enter your GMAIL CLIENT SECRET : ")

    authorizer: GMailAuthorizer = GMailAuthorizer(client_id, client_secret)
    authorization_url: str = authorizer.get_authorization_url()
    
    print("")
    print("NOTE: If you want Google to issue another refresh token, just")
    print(r"append '&prompt=consent' to the end of the next URL.")
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
    print("Sending request to Google API to get the refresh token...")
    refresh_token: str = authorizer.get_refresh_token(authorization_code)

    # Storing everything in "pass"
    # store_secret("gmail/accpass", account_password)
    store_secret("gmail/clientid", client_id)
    store_secret("gmail/clientsecret", client_secret)
    store_secret("gmail/refreshtoken", refresh_token)
    print("Secrets stored.")


import sys
import requests
import subprocess
from requests.models import Response
from typing import Dict


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


def get_temporary_access_token() -> str:
    try:
        api_url: str = get_pass_secret("gmail/tokenendpoint")
        client_id: str = get_pass_secret("gmail/clientid")
        client_secret: str = get_pass_secret("gmail/clientsecret")
        refresh_token: str = get_pass_secret("gmail/refreshtoken")

        post_data: Dict[str, str] = {
            "client_id": client_id,
            "client_secret": client_secret,
            "refresh_token": refresh_token,
            "grant_type": "refresh_token",
        }

        response: Response = requests.post(api_url, data=post_data, timeout=5)
        response.raise_for_status()

        # Print ONLY the access_token for msmtp to read
        return response.json()["access_token"]

    except Exception as e:
        sys.stderr.write(f"OAuth2 Exchange Failed: {str(e)}\n")
        sys.exit(1)


if __name__ == "__main__":
    # Check if a path was provided as an argument
    if len(sys.argv) < 1:
        sys.stderr.write(
            "Usage: python3 get_mail_secret.py <pass_path|temporary_access_token>\n"
        )
        sys.exit(1)

    keyname: str = sys.argv[1]

    if keyname == "temporary_access_token":
        token: str = get_temporary_access_token()
        if not token:
            raise Exception("Cannot get the temporary access token!")

        print(token)

    else:
        secret: str | None = get_pass_secret(keyname)

        if not secret:
            raise Exception("Cannot get the secret from 'pass' store!")

        print(secret)

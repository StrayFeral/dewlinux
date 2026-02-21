#!/bin/env python3
import requests, sys, subprocess
from typing import Dict
from requests import Response


def get_secret(secret_name: str) -> str:
    result: str = subprocess.run(["pass", secret_name], capture_output=True, text=True)
    return result.stdout.strip()


def get_token(cid: str, csecret: str, rtoken: str) -> str:
    #url: str = r"https://oauth2.googleapis.com/token"
    url: str = get_secret("gmail/tokenendpoint")
    post_data: Dict[str:str] = {
        "client_id": get_secret("gmail/clientid"),
        "client_secret": get_secret("gmail/clientsecret"),
        "refresh_token": get_secret("gmail/refreshtoken"),
        "grant_type": "refresh_token",
    }
    response: Response = requests.post(url, data=post_data)
    return response.json()["access_token"]


if __name__ == "__main__":
    print(get_token())

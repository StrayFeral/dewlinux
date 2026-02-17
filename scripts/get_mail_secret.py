import os
import sys
import requests
import subprocess

def get_pass_secret(path):
    try:
        # Using full path /usr/bin/pass is safer for AppArmor/Cron/msmtp
        result = subprocess.run(["/usr/bin/pass", path], 
                                capture_output=True, 
                                text=True, 
                                check=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        # Sending error to stderr so it doesn't pollute the password output
        sys.stderr.write(f"Pass failed for {path}: {e.stderr}\n")
        sys.exit(1)

# Get the temporary access token
def get_temporary_access_token():
    try:
        api_url = "https://oauth2.googleapis.com/token"
        # 1. Pull the 3 required secrets from your 'pass' store
        client_id = get_pass_secret("gmail/clientid")
        client_secret = get_pass_secret("gmail/clientsecret")
        refresh_token = get_pass_secret("gmail/refreshtoken")

        # 2. Perform the exchange with Google
        post_data = {
            'client_id': client_id,
            'client_secret': client_secret,
            'refresh_token': refresh_token,
            'grant_type': 'refresh_token',
        }
        
        response = requests.post(api_url, data=post_data)
        response.raise_for_status()
        
        # 3. Print ONLY the access_token for msmtp to read
        return response.json()['access_token']

    except Exception as e:
        sys.stderr.write(f"OAuth2 Exchange Failed: {str(e)}\n")
        sys.exit(1)


if __name__ == "__main__":
    # Check if a path was provided as an argument
    if len(sys.argv) > 1:
        keyname = sys.argv[1]
        
        if keyname == "temporary_access_token":
            token = get_temporary_access_token()
            if token:
                print(token)
            else:
                raise Exception("Cannot get the temporary access token!")
        else:
            secret = get_pass_secret(keyname)
            if secret:
                print(secret)
            else:
                raise Exception("Cannot get the secret from 'pass' store!")
    else:
        sys.stderr.write("Usage: python3 get_pass_secret.py <pass_path|temporary_access_token>\n")
        sys.exit(1)

import subprocess
import os

def get_pass(path):
    try:
        # We use 'run' and explicitly check for errors
        # Use full path to pass if 'which pass' gives you something like /usr/bin/pass
        result = subprocess.run(["pass", path], 
                                capture_output=True, 
                                text=True, 
                                check=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        # This will show up in your offlineimap logs
        raise Exception(f"Pass failed for {path}: {e.stderr}")

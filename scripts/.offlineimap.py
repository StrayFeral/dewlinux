import subprocess

def get_pass(path):
    # This must return a plain string with no extra whitespace
    return subprocess.check_output(["pass", path], text=True).strip()

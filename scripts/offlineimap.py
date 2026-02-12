#!/bin/env python3
import subprocess


def get_token() -> str:
    return (
        subprocess.check_output(["python3", "~/bin/get_temp_acc_token.py"])
        .decode("utf-8")
        .strip()
    )

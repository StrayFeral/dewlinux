#!/bin/bash
ip addr show | grep -oE '192\.168\.[0-9]+\.[0-9]+/[0-9]+' 


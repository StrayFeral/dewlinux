#!/bin/bash

if [ ! -f "LostPig.z8" ]; then
    echo "Error: Game file not found. Did you ran 'make games'? Exiting now."
    exit 1
fi

frotz LostPig.z8


#!/bin/bash

set -e

for script in $(ls | grep -E "[0-9]{2}-\w*\.sh" | sort); do
    bash $script
done

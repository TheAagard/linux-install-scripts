#!/bin/bash

set -e

for script in $(ls *0-*.sh | sort); do
    bash $script
done

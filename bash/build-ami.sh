#!/bin/bash

wget https://raw.githubusercontent.com/tobbie/automation-scripts/main/docker/install_docker.py
chmod a+x install_docker.py
./install_docker.py
rm install_docker.py
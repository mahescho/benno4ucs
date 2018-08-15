#!/bin/bash

echo "deb https://www.benno-mailarchiv.de/download/debian /" > /etc/apt/sources.list.d/benno.list
wget -O - https://www.benno-mailarchiv.de/download/debian/benno.asc | apt-key add -
apt update
apt install benno-kopano-webapp-plugin

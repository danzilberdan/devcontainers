#!/bin/sh

# Add Infisical repository
curl -1sLf 'https://artifacts-cli.infisical.com/setup.deb.sh' | bash

# Install CLI
apt-get update && apt-get install -y infisical
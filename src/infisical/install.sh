#!/bin/sh

# Add Infisical repository
curl -1sLf 'https://artifacts-cli.infisical.com/setup.deb.sh' | bash

# Install CLI
apt-get update && apt-get install -y infisical

# Inject bash function into bashrc and zshrc if dotenvFile is provided
if [ -n "$DOTENVFILE" ]; then
    INFISICAL_ENV_FUNCTION="
infisical_env() {
    if [ -f \"$DOTENVFILE\" ]; then
        bash -c \"
            source \\\"$DOTENVFILE\\\"
            if [ -n \\\"\\\$INFISICAL_PROJECT_ID\\\" ] && [ -n \\\"\\\$INFISICAL_ENV\\\" ]; then
                infisical run --projectId \\\"\\\$INFISICAL_PROJECT_ID\\\" --env \\\"\\\$INFISICAL_ENV\\\" -- env
            else
                echo 'INFISICAL_PROJECT_ID and INFISICAL_ENV must be set in $DOTENVFILE' >&2
                exit 1
            fi
        \" > /tmp/.env
        if [ \$? -eq 0 ]; then
            set +x
            source /tmp/.env
            set -x
        fi
    else
        echo \"Dotenv file $DOTENVFILE not found\"
    fi
}
"
    echo "$INFISICAL_ENV_FUNCTION" >> /etc/bash.bashrc
    echo "$INFISICAL_ENV_FUNCTION" >> /etc/zsh/zshrc
fi
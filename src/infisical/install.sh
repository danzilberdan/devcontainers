#!/bin/sh

# Add Infisical repository
curl -1sLf 'https://artifacts-cli.infisical.com/setup.deb.sh' | bash

# Install CLI
apt-get update && apt-get install -y infisical

# Function to load infisical env - will be injected into shell rc files
if [ -n "$DOTENVFILE" ]; then
    INNER_SCRIPT=$(cat <<EOF
source "$DOTENVFILE"
if [ -n "\$INFISICAL_PROJECT_ID" ] && [ -n "\$INFISICAL_ENV" ]; then
    infisical run --projectId "\$INFISICAL_PROJECT_ID" --env "\$INFISICAL_ENV" -- env
else
    echo "INFISICAL_PROJECT_ID and INFISICAL_ENV must be set in $DOTENVFILE" >&2
    exit 1
fi
EOF
)
    echo "$INNER_SCRIPT" > /tmp/inner_script.sh

    INFISICAL_ENV_FUNCTION=$(cat <<EOF
infisical_env() {
    if [ -f "$DOTENVFILE" ]; then
        cat /tmp/inner_script.sh | bash > /tmp/.env
        if [ \$? -eq 0 ]; then
            set +x
            source /tmp/.env
            set -x
        fi
    else
        echo "Dotenv file $DOTENVFILE not found"
    fi
}
infisical_env
EOF
)

    BASHRC_PATH="/home/${_REMOTE_USER}/.bashrc"
    echo "$INFISICAL_ENV_FUNCTION" >> "$BASHRC_PATH"

    ZSHRC_PATH="/home/${_REMOTE_USER}/.zshrc"
    echo "$INFISICAL_ENV_FUNCTION" >> "$ZSHRC_PATH"
fi
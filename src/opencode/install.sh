#!/bin/sh

# Function to mount auth file - will be injected into shell rc files
OPENCODE_AUTH_FUNCTION='
_opencode_mount_auth() {
    local MOUNTED_FILE="/mnt/opencode-auth.json"
    local TARGET_DIR="${HOME}/.local/share/opencode"
    local TARGET_FILE="${TARGET_DIR}/auth.json"

    # Check if the mounted file exists and target file is missing or older
    if [ -f "$MOUNTED_FILE" ] && ([ ! -f "$TARGET_FILE" ] || [ "$MOUNTED_FILE" -nt "$TARGET_FILE" ]); then
        mkdir -p "$TARGET_DIR" 2>/dev/null
        cp "$MOUNTED_FILE" "$TARGET_FILE" 2>/dev/null
        chmod 600 "$TARGET_FILE" 2>/dev/null
    fi
}
_opencode_mount_auth
'

BASHRC_PATH="/home/${_REMOTE_USER}/.bashrc"
echo "$OPENCODE_AUTH_FUNCTION" >> "$BASHRC_PATH"

ZSHRC_PATH="/home/${_REMOTE_USER}/.zshrc"
echo "$OPENCODE_AUTH_FUNCTION" >> "$ZSHRC_PATH"

# Install opencode
su - "$_REMOTE_USER" -c "curl -fsSL https://opencode.ai/install | bash"
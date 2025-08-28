#!/bin/sh

LOG_FILE="/tmp/opencode-install.log"
exec > "$LOG_FILE" 2>&1

MOUNTED_FILE="/mnt/opencode-auth.json"
TARGET_DIR="/home/${_REMOTE_USER}/.local/share/opencode"
TARGET_FILE="${TARGET_DIR}/auth.json"

# Check if the mounted file exists
if [ -f "$MOUNTED_FILE" ]; then
    echo "API keys file found at $MOUNTED_FILE"

    # Create the target directory structure as root
    mkdir -p "$TARGET_DIR"

    # Copy the mounted file to the final location as root
    cp "$MOUNTED_FILE" "$TARGET_FILE"

    # Change ownership to the remote user
    chown "${_REMOTE_USER}:${_REMOTE_USER}" "$TARGET_FILE"

    # Verify the copy was successful
    if [ -f "$TARGET_FILE" ]; then
        echo "API keys configured successfully at $TARGET_FILE"
    else
        echo "Error: Failed to copy API keys to $TARGET_FILE"
    fi
else
    echo "Warning: API keys file not found at $MOUNTED_FILE"
fi

# Install opencode
su - "$_REMOTE_USER" -c "curl -fsSL https://opencode.ai/install | bash"
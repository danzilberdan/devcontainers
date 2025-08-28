
# opencode (opencode)

Installs opencode by SST with API keys configuration

## Example Usage

```json
"features": {
    "ghcr.io/danzilberdan/devcontainers/opencode:0": {}
}
```



# API Keys Configuration

This feature supports automatic configuration of API keys for opencode from a JSON file on your host machine.

## Setup

**Most users will already have an `auth.json` file** from their existing opencode installation on the host. Simply reference that file:

```json
{
    "features": {
        "ghcr.io/danzilberdan/devcontainers/opencode:0": {
            "authFile": "~/.local/share/opencode/auth.json"
        }
    }
}
```

If you don't have an existing `auth.json` file or want to use a different location:

1. Create a JSON file with your API keys on your host machine (e.g., `~/.opencode/auth.json` or `${localWorkspaceFolder}/.opencode/auth.json`)

2. Configure the feature in your `devcontainer.json`:

```json
{
    "features": {
        "ghcr.io/danzilberdan/devcontainers/opencode:0": {
            "authFile": "${localWorkspaceFolder}/.opencode/auth.json"
        }
    }
}
```

## API Keys JSON Format

Your `auth.json` file should follow the standard opencode format with provider-specific configurations:

```json
{
    "anthropic": {
        "type": "api",
        "key": "your-anthropic-api-key"
    },
    "openai": {
        "type": "api",
        "key": "your-openai-api-key"
    },
    "openrouter": {
        "type": "api",
        "key": "your-openrouter-api-key"
    }
}
```

During installation, this file will be copied to: `~/.local/share/opencode/auth.json`

## How it Works

- The specified auth.json file from the host (typically from an existing opencode installation) is mounted to `/tmp/opencode-auth.json` in the container
- During installation, the file is copied to `/home/${remoteUser}/.local/share/opencode/auth.json`
- The target directory is created if it doesn't exist
- If no `authFile` is specified, API keys configuration is skipped

## Security Note

Ensure your `auth.json` file is not committed to version control. If you're referencing an existing file from your host opencode installation, make sure it contains the API keys you want to use in the dev container. Consider adding it to your `.gitignore` file if it's in your workspace.

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/danzilberdan/devcontainers/blob/main/src/opencode/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._

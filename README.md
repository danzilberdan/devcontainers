# DevContainers Features

A collection of Dev Container features to enhance your development environment.

## Features

### OpenCode

[OpenCode](https://opencode.ai) is an AI-powered coding assistant that helps you write, debug, and understand code more efficiently.

This feature installs OpenCode by SST directly into your Dev Container, giving you access to advanced code intelligence tools right in your development environment.

<details>
<summary>Installation & Configuration</summary>

#### Installation

Add the OpenCode feature to your `devcontainer.json`:

```json
{
    "features": {
        "ghcr.io/danzilberdan/devcontainers/opencode:0": {}
    }
}
```

#### API Keys Configuration

This feature supports automatic configuration of API keys for OpenCode from a JSON file on your host machine.

##### Setup

**Most users will already have an `auth.json` file** from their existing OpenCode installation on the host. Mount that file to the container:

```json
{
    "features": {
        "ghcr.io/danzilberdan/devcontainers/opencode:0": {}
    },
    "mounts": [
        "source=${localEnv:HOME}/.local/share/opencode/auth.json,target=/tmp/opencode-auth.json,type=bind,consistency=cached"
    ]
}
```

If you don't have an existing `auth.json` file or want to use a different location:

1. Create a JSON file with your API keys on your host machine (e.g., `~/.opencode/auth.json` or `${localWorkspaceFolder}/.opencode/auth.json`)

2. Configure the mount in your `devcontainer.json`:

```json
{
    "features": {
        "ghcr.io/danzilberdan/devcontainers/opencode:0": {}
    },
    "mounts": [
        "source=${localWorkspaceFolder}/.opencode/auth.json,target=/tmp/opencode-auth.json,type=bind,consistency=cached"
    ]
}
```

##### API Keys JSON Format

Your `auth.json` file should follow the standard OpenCode format with provider-specific configurations:

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

##### How it Works

- The specified auth.json file from the host (typically from an existing OpenCode installation) is mounted to `/tmp/opencode-auth.json` in the container
- During installation, the file is copied to `/home/${remoteUser}/.local/share/opencode/auth.json`
- The target directory is created if it doesn't exist
- If no auth file is mounted, API keys configuration is skipped

##### Security Note

Ensure your `auth.json` file is not committed to version control. If you're referencing an existing file from your host OpenCode installation, make sure it contains the API keys you want to use in the dev container. Consider adding it to your `.gitignore` file if it's in your workspace.

</details>

### Infisical

[Infisical](https://infisical.com) is a secret management platform that helps you manage and access secrets securely.

This feature installs the Infisical CLI directly into your Dev Container, allowing you to interact with Infisical secrets from within your development environment.

<details>
<summary>Installation & Configuration</summary>

#### Installation

Add the Infisical feature to your `devcontainer.json`:

```json
{
    "features": {
        "ghcr.io/danzilberdan/devcontainers/infisical:0": {}
    }
}
```

#### Configuration

To automatically load Infisical secrets into your shell environment, configure a dotenv file with your project ID and environment.

##### Setup

1. Create a dotenv file (e.g., `.infisical.env`) in your workspace with the following variables:

```bash
INFISICAL_PROJECT_ID=your-project-id
INFISICAL_ENV=dev
```

2. Configure the feature in your `devcontainer.json` to point to this file:

```json
{
    "features": {
        "ghcr.io/danzilberdan/devcontainers/infisical:0": {
            "dotenvFile": "/workspaces/project/.infisical.env"
        }
    }
}
```

##### How it Works

- Upon container startup, an `infisical_env` function is added to your shell and runs automatically
- The function reads your configured dotenv file and fetches the corresponding secrets into your environment

##### Security Note

Ensure your dotenv file containing sensitive project IDs is not committed to version control. Consider adding it to your `.gitignore` file.

</details>

<!-- Future features can be added here as additional ### sections -->
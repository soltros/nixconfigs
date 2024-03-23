
# Nixos Configuration Backup Tool

This Go program automatically scans the `/etc/nixos/` directory for `.nix` files, copies them into a timestamped folder within a specified Git repository, generates a markdown description of the contents of each `.nix` file, and pushes the changes to the repository.

## Prerequisites

Before you use this tool, you'll need to have the following installed:
- Go (1.15 or later recommended)
- Git
- Access to a Git repository (GitHub, GitLab, Bitbucket, etc.)

## Setting Up Git

### Generating an SSH Key (if needed)

If you haven't already, generate an SSH key pair for authentication:

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

Follow the prompts, and remember to add your SSH key to your ssh-agent and to your Git server account.

### Using a Personal Access Token

Alternatively, you can use a personal access token (PAT) for HTTPS operations:

1. **Generate a PAT** from your Git hosting service (GitHub, GitLab, etc.).
2. You'll use this token in place of your password when prompted by Git or in your configuration file for this tool.

## Configuration

Create a `config.json` file in the root directory of this program with the following structure:

```json
{
    "gitRepoPath": "/path/to/your/repo",
    "gitUsername": "yourGitUsername",
    "gitToken": "yourPersonalAccessToken"
}
```

- `gitRepoPath`: Path to your local Git repository.
- `gitUsername`: Your Git username.
- `gitToken`: Your Git personal access token or password.

**Important**: Ensure `config.json` is secure and not accessible by unauthorized users.

## Installation

To compile and install the tool, run:

```bash
go build -o nixos-backup
```

This will create an executable named `nixos-backup` in your current directory.

## Usage

Run the program by executing:

```bash
./nixos-backup
```

The tool will scan `/etc/nixos/` for `.nix` files, copy them to your Git repository in a new timestamped directory, generate a markdown file describing their contents, and push these changes to the remote repository configured in your `config.json`.

## Security

- Do not commit `config.json` to any public repositories.
- Ensure proper permissions are set for `config.json` to prevent unauthorized access.

## Contributions

Contributions are welcome! Please open an issue or pull request if you have suggestions or contributions to make this tool better.

## License

[MIT License](LICENSE) (or choose a license that suits your project)

# Zed IDE Config Manager

A robust script to help manage Zed IDE configuration files with safety features and modification time checking.

## Features

- ✅ **Safe operations**: Checks file modification times before overwriting
- ⚠️ **User confirmation**: Asks before overwriting newer files
- 📁 **Auto-directory creation**: Creates missing directories as needed
- 🔍 **Cross-platform**: Works on macOS and Linux
- 📊 **Progress tracking**: Shows operation results and file counts

## Usage

### Basic Commands

```bash
# Show help (default behavior)
./run.sh

# Backup Zed config files to repo
./run.sh --backup

# Load Zed config files from repo
./run.sh --load

# Show help
./run.sh --help
```

### Direct Script Access

You can also run the underlying script directly for more detailed help:

```bash
# Detailed help and features
./getZedFiles.sh --help

# Direct backup operation
./getZedFiles.sh

# Direct load operation
./getZedFiles.sh --load
```

## What it manages

The script handles these Zed IDE configuration files:
- `settings.json` - IDE settings and preferences
- `keymap.json` - Custom keyboard shortcuts

Files are backed up to the `./zed/` directory in your dotfiles repo.

## Safety Features

When loading configs, the script will:
1. Check if your local Zed files are newer than the backup
2. Show modification timestamps for comparison
3. Ask for confirmation before overwriting newer files
4. Allow you to skip individual files or proceed anyway

Example safety prompt:
```
⚠️  WARNING: Destination file is newer than source!
   Source: ./zed/settings.json (2025-06-09 15:15:28)
   Dest:   ~/.config/Zed/settings.json (2025-06-09 15:18:09)

The destination file is newer. Overwrite anyway? (y/N):
```

## Requirements

- Zed IDE installed and configured
- Bash shell
- macOS or Linux operating system

That's it! A simple but robust way to keep your Zed IDE settings backed up and synchronized.
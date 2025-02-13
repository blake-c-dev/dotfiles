#!/bin/bash

show_help() {
		echo "getZedConfig.sh - Sync Zed IDE configuration files"
		echo ""
		echo "Usage:"
		echo "  ./getZedConfig.sh          # Save Zed config files to repo"
		echo "  ./getZedConfig.sh --load   # Load Zed config files from repo"
		echo ""
}

if [ -z "$1" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
		show_help
		exit 0
fi

if [ "$1" = "--load" ]; then
		echo "Loading Zed config files..."
		# Copy local Zed files to IDE config
		cp ./zed/settings.json ~/.config/Zed/
		cp ./zed/keymap.json ~/.config/Zed/
		echo "✓ Loaded Zed config files from repo"
else
		echo "Saving Zed config files..."
		# Create zed directory if it doesn't exist
		mkdir -p zed

		# Copy Zed IDE settings and keymap files to zed directory
		cp ~/.config/Zed/settings.json ./zed/
		cp ~/.config/Zed/keymap.json ./zed/
		echo "✓ Saved Zed config files to repo"
fi

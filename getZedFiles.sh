#!/bin/bash

show_help() {
    echo "getZedFiles.sh - Sync Zed IDE configuration files"
    echo ""
    echo "Usage:"
    echo "  ./getZedFiles.sh          # Save Zed config files to repo (default)"
    echo "  ./getZedFiles.sh --load   # Load Zed config files from repo"
    echo "  ./getZedFiles.sh --help   # Show this help message"
    echo ""
    echo "Note: Use ./run.sh for the preferred entry point:"
    echo "  ./run.sh --backup        # Save Zed config files to repo"
    echo "  ./run.sh --load          # Load Zed config files from repo"
    echo ""
    echo "Features:"
    echo "  - Checks file modification times before overwriting"
    echo "  - Asks for confirmation when local files are newer"
    echo "  - Handles missing files gracefully"
    echo ""
}

# Function to get file modification time (cross-platform)
get_mod_time() {
    local file="$1"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        stat -f "%m" "$file" 2>/dev/null || echo "0"
    else
        # Linux
        stat -c "%Y" "$file" 2>/dev/null || echo "0"
    fi
}

# Function to format modification time for display
format_mod_time() {
    local file="$1"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$file" 2>/dev/null || echo "unknown"
    else
        # Linux
        stat -c "%y" "$file" 2>/dev/null | cut -d'.' -f1 || echo "unknown"
    fi
}

# Function to ask user for confirmation
ask_confirmation() {
    local message="$1"
    echo "$message"
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# Function to compare and copy file with confirmation
safe_copy() {
    local src="$1"
    local dest="$2"
    local direction="$3"  # "save" or "load"
    
    # Check if source file exists
    if [[ ! -f "$src" ]]; then
        echo "⚠️  Source file not found: $src"
        return 1
    fi
    
    # If destination doesn't exist, copy without asking
    if [[ ! -f "$dest" ]]; then
        echo "📄 Copying $src → $dest (destination doesn't exist)"
        cp "$src" "$dest"
        return $?
    fi
    
    # Get modification times
    local src_time=$(get_mod_time "$src")
    local dest_time=$(get_mod_time "$dest")
    
    # Compare modification times
    if [[ $dest_time -gt $src_time ]]; then
        echo ""
        echo "⚠️  WARNING: Destination file is newer than source!"
        echo "   Source: $src ($(format_mod_time "$src"))"
        echo "   Dest:   $dest ($(format_mod_time "$dest"))"
        echo ""
        
        if ask_confirmation "The destination file is newer. Overwrite anyway?"; then
            echo "📄 Copying $src → $dest (user confirmed)"
            cp "$src" "$dest"
            return $?
        else
            echo "⏭️  Skipped: $src"
            return 0
        fi
    else
        echo "📄 Copying $src → $dest"
        cp "$src" "$dest"
        return $?
    fi
}

# Main script logic
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

# Zed config files to sync
CONFIG_FILES=("settings.json" "keymap.json")
ZED_CONFIG_DIR="$HOME/.config/Zed"
BACKUP_DIR="./zed"

if [ "$1" = "--load" ]; then
    echo "🔄 Loading Zed config files from backup..."
    echo ""
    
    # Check if backup directory exists
    if [[ ! -d "$BACKUP_DIR" ]]; then
        echo "❌ Error: Backup directory '$BACKUP_DIR' not found!"
        echo "   Run the script without --load first to create backups."
        exit 1
    fi
    
    # Check if Zed config directory exists
    if [[ ! -d "$ZED_CONFIG_DIR" ]]; then
        echo "📁 Creating Zed config directory: $ZED_CONFIG_DIR"
        mkdir -p "$ZED_CONFIG_DIR"
    fi
    
    success_count=0
    total_count=0
    
    for file in "${CONFIG_FILES[@]}"; do
        total_count=$((total_count + 1))
        src="$BACKUP_DIR/$file"
        dest="$ZED_CONFIG_DIR/$file"
        
        if safe_copy "$src" "$dest" "load"; then
            success_count=$((success_count + 1))
        fi
    done
    
    echo ""
    echo "✅ Load complete: $success_count/$total_count files processed"
    
else
    echo "💾 Saving Zed config files to backup..."
    echo ""
    
    # Check if Zed config directory exists
    if [[ ! -d "$ZED_CONFIG_DIR" ]]; then
        echo "❌ Error: Zed config directory not found: $ZED_CONFIG_DIR"
        echo "   Make sure Zed IDE is installed and has been run at least once."
        exit 1
    fi
    
    # Create backup directory if it doesn't exist
    if [[ ! -d "$BACKUP_DIR" ]]; then
        echo "📁 Creating backup directory: $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
    fi
    
    success_count=0
    total_count=0
    
    for file in "${CONFIG_FILES[@]}"; do
        total_count=$((total_count + 1))
        src="$ZED_CONFIG_DIR/$file"
        dest="$BACKUP_DIR/$file"
        
        if safe_copy "$src" "$dest" "save"; then
            success_count=$((success_count + 1))
        fi
    done
    
    echo ""
    echo "✅ Save complete: $success_count/$total_count files processed"
fi

exit 0
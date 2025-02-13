#!/bin/bash

showHelp() {
  echo "Usage: $0 [--load|--copy]"
  echo
  echo "Options:"
  echo "--load    Load .zshrc from backup to home directory"
  echo "--copy    Copy .zshrc from home directory to backup"
  exit 1
}

ZSHRC_BACKUP="./zshrc"

if [ "$#" -ne 1 ]; then
  showHelp
fi

while [ "$1" != "" ]; do
  case $1 in
    --load )    cp "$ZSHRC_BACKUP/.zshrc" "$HOME/.zshrc"
                echo ".zshrc loaded to home directory"
                exit
                ;;
    --copy )    mkdir -p "$ZSHRC_BACKUP"
                cp "$HOME/.zshrc" "$ZSHRC_BACKUP/"
                echo ".zshrc copied to backup"
                exit
                ;;
    * )         showHelp
  esac
  shift
done
show_help() {
  echo "Usage: $0 [--load|--copy]"
  echo "  --load  Load files from backup location"
  echo "  --copy  Copy files to backup location (default)"
  echo "  --help  Show this help message"
}

if [ $# -eq 0 ]
then
  show_help
  exit 0
elif [ "$1" == "--help" ] || [ "$1" == "-h" ]
then
  show_help
  exit 0
elif [ "$1" == "--load" ]
then
  chmod +x ./GetZedFiles.sh
  ./GetZedFiles.sh --load
else
  chmod +x ./GetZedFiles.sh
  ./GetZedFiles.sh --copy
fi
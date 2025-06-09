show_help() {
  echo "Usage: $0 [--load|--backup]"
  echo "  --load    Load files from backup location"
  echo "  --backup  Copy files to backup location"
  echo "  --help    Show this help message"
}

if [ $# -eq 0 ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]
then
  show_help
  exit 0
elif [ "$1" == "--load" ]
then
  chmod +x ./getZedFiles.sh
  ./getZedFiles.sh --load
elif [ "$1" == "--backup" ]
then
  chmod +x ./getZedFiles.sh
  ./getZedFiles.sh
else
  echo "Error: Unknown option '$1'"
  show_help
  exit 1
fi
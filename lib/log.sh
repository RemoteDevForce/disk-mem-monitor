# https://dev.to/ifenna__/adding-colors-to-bash-scripts-48g4
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

LOG_FILE="notifications.log"

success() {
  echo -e "${GREEN}$1${ENDCOLOR}"
}

error() {
  echo -e "${RED}$1${ENDCOLOR}"
}

warn() {
  echo -e "${YELLOW}$1${ENDCOLOR}"
}

log() {
  TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
  printf "[%s] $1\n" "$TIMESTAMP">>"$LOG_FILE"
}

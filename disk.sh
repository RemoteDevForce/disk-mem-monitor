#!/bin/bash

# https://www.baeldung.com/linux/source-include-files#setting-a-correct-path
source "$(dirname "$0")"/lib/log.sh
source "$(dirname "$0")"/lib/env.sh
source "$(dirname "$0")"/lib/notification.sh

VERBOSE=
GLOBAL=
NOTIFY=

# https://sookocheff.com/post/bash/parsing-bash-script-arguments-with-shopts/
while getopts ":hgvn" opt; do
  case ${opt} in
  h)
    echo "Disk script options:"
    echo "  -h   Display help"
    echo "  -g   Output global disk usage"
    echo "  -n   Notify admin via slack and email"
    echo "  -v   Output verbose volume usage (expects volume name parameter)"
    exit 0
    ;;
  g) GLOBAL=1 ;;
  n) NOTIFY=1 ;;
  v) VERBOSE=1 ;;
  \?)
    error "Invalid Option: -$OPTARG" 1>&2
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

DIR="$1"
shift # Remove option from the argument list

# https://www.howtogeek.com/409611/how-to-view-free-disk-space-and-disk-usage-from-the-linux-terminal/
if [[ -n "$GLOBAL" ]]; then
  if [[ -n "$DIR" ]]; then
    warn "Global output, volume ignored."
  fi

  df -h --output=target,source,fstype,size,used,avail,pcent
  exit 0
fi

if [[ -z "$DIR" ]]; then
  error "Missing directory parameter." 1>&2
  exit 1
fi

if [[ -n "$VERBOSE" ]]; then
  df -h --output=target,source,fstype,size,used,avail,pcent "$DIR"
  exit 0
fi

USAGE=$(df -h --output=pcent,target | grep -E "${DIR}$" | cut -d "%" -f 1 | xargs echo -n)

if [[ -n "$NOTIFY" ]]; then
  if [[ "$USAGE" -gt "$STORAGE_PCNT_THRESHOLD" ]]; then
    SLACK_RESULT=$(slack "<@$SLACK_RECIPIENT_ID> <!here>: Disk space \`$DIR\` at $USAGE%!")
    log "Disk space slack notification sent $SLACK_RESULT"

    BODY=$(<"$(dirname "$0")"/tmpl/dsk.txt)
    BODY="${BODY/:STORAGE_NAME:/${DIR}}"
    BODY="${BODY/:USAGE:/${USAGE}}"
    EMAIL_RESULT=$(email "$BODY" "Storage alert (${USAGE}%)")

    log "Disk space alert email sent $EMAIL_RESULT"
  fi

  exit 0
fi

echo -e "$USAGE"

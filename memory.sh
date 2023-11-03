#!/bin/bash

# https://www.baeldung.com/linux/source-include-files#setting-a-correct-path
source "$(dirname "$0")"/lib/log.sh
source "$(dirname "$0")"/lib/env.sh
source "$(dirname "$0")"/lib/notification.sh

VERBOSE=
NOTIFY=

while getopts ":hvn" opt; do
  case ${opt} in
  h)
    echo "Memory script options:"
    echo "  -h   Display help"
    echo "  -n   Notify admin via slack and email"
    echo "  -v   Output verbose volume usage"
    exit 0
    ;;
  n) NOTIFY=1 ;;
  v) VERBOSE=1 ;;
  \?)
    error "Invalid Option: -$OPTARG" 1>&2
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

# https://kloudvm.com/linux/bash-script-monitor-cpu-memory-disk-usage-on-linux/
if [[ -n "$VERBOSE" ]]; then
  free -h --total
  exit 0
fi

FREE_MEMORY=$(free -m | awk 'NR==2{printf "%d", $4}')

if [[ -n "$NOTIFY" ]]; then
  if [[ "$FREE_MEMORY" -lt "$MEM_MB_THRESHOLD" ]]; then
    SLACK_RESULT=$(slack "<@$SLACK_RECIPIENT_ID> <!here>: Low free memory, only ${FREE_MEMORY}MB available!")
    log "Memory usage slack notification sent: $SLACK_RESULT"

    BODY=$(<"$(dirname "$0")"/tmpl/mem.txt)
    BODY="${BODY/:FREE_MEMORY:/${FREE_MEMORY}}"
    EMAIL_RESULT=$(email "$BODY" "Memory alert (${FREE_MEMORY}MB)")

    log "Memory usage alert email sent: $EMAIL_RESULT"
  fi

  exit 0
fi

echo -e "$FREE_MEMORY"

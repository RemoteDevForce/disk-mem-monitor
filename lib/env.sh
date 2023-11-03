getenv() {
  VAL=$(grep "$1" <"$(dirname "$0")"/.scriptsrc | cut -d "=" -f 2)

  if [ -z "$VAL" ] && [ -n "$2" ]; then
    VAL="$2"
  fi

  echo "$VAL"
}

export STORAGE_PCNT_THRESHOLD=$(getenv 'STORAGE_PCNT_THRESHOLD' 75)
export MEM_MB_THRESHOLD=$(getenv 'MEM_MB_THRESHOLD' 128)

export EMAIL_RECIPIENT=$(getenv 'EMAIL_RECIPIENT')
export SLACK_TOKEN=$(getenv 'SLACK_TOKEN')
export SLACK_RECIPIENT_ID=$(getenv 'SLACK_RECIPIENT_ID')
export MAILGUN_API_KEY=$(getenv 'MAILGUN_API_KEY')
export MAILGUN_DOMAIN_NAME=$(getenv 'MAILGUN_DOMAIN_NAME')

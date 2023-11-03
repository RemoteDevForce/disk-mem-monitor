slack() {
  # https://api.slack.com/messaging/webhooks
  MESSAGE="{\"text\":\"$1\",\"type\":\"mrkdwn\"}"
  curl --silent -H 'Content-type: application/json' \
    --data "$MESSAGE" \
    -X POST "https://hooks.slack.com/services/$SLACK_TOKEN"
}

email() {
  BODY="$1"
  SUBJECT="$2"
  SENDER="no-reply@onboard.clerkbase.com"

  # https://documentation.mailgun.com/en/latest/quickstart-sending.html
  curl --silent --user "api:$MAILGUN_API_KEY" \
    https://api.mailgun.net/v3/"$MAILGUN_DOMAIN_NAME"/messages \
    -F from="Server monitor <$SENDER>" \
    -F to="$EMAIL_RECIPIENT" \
    -F subject="$SUBJECT" \
    -F text="$BODY"
}

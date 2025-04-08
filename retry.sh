#!/bin/bash

APP_NAME=$1
MAX_RETRIES=5
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
  echo "Attempting to redeploy $APP_NAME (Attempt $((RETRY_COUNT + 1)))"
  argocd app sync $APP_NAME

  STATUS=$(argocd app get $APP_NAME -o json | jq -r '.status.health.status')
  if [ "$STATUS" == "Healthy" ]; then
    echo "$APP_NAME is now Healthy."
    exit 0
  fi

  RETRY_COUNT=$((RETRY_COUNT + 1))
  sleep 10
done

echo "$APP_NAME failed to reach Healthy state after $MAX_RETRIES attempts. Pausing application."
argocd app pause $APP_NAME

# Send notification to Slack
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"Application '"$APP_NAME"' is in degraded state after 5 retries."}' \
  https://hooks.slack.com/services/your/slack/webhook/url
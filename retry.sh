#!/bin/bash

APP_NAME=$1
MAX_RETRIES=5
RETRY_COUNT=0

# Obtener la URL del webhook desde el Secret
SLACK_WEBHOOK_URL=$(kubectl get secret slack-webhook-secret -n argocd -o jsonpath='{.data.slack-webhook-url}' | base64 --decode)

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

# Enviar notificación a Slack
MESSAGE="Application $APP_NAME is in degraded state after $MAX_RETRIES retries."
curl -X POST -H 'Content-type: application/json' \
  --data "{\"text\":\"$MESSAGE\"}" \
  $SLACK_WEBHOOK_URL
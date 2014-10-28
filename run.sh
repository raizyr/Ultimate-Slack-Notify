#!/bin/bash

SLACK_TOKEN=$WERCKER_ULTIMATE_SLACK_NOTIFY_TOKEN
SLACK_SUBDOMAIN=$WERCKER_ULTIMATE_SLACK_NOTIFY_SUBDOMAIN
SLACK_CHANNEL=$WERCKER_ULTIMATE_SLACK_NOTIFY_CHANNEL
SLACK_USERNAME=$WERCKER_ULTIMATE_SLACK_NOTIFY_USERNAME
SLACK_ICON_URL=$WERCKER_ULTIMATE_SLACK_NOTIFY_ICON_URL
SLACK_ICON_EMOJI=$WERCKER_ULTIMATE_SLACK_NOTIFY_EMOJI
SLACK_NOTIFY_ON=$WERCKER_ULTIMATE_SLACK_NOTIFY_ON

if [ ! -n "$SLACK_TOKEN" ]; then
  fail 'Please specify token property'
fi

if [ ! -n "$SLACK_SUBDOMAIN" ]; then
  fail 'Please specify subdomain property'
fi

if [[ $SLACK_CHANNEL == \#* ]]; then
  SLACK_CHANNEL=${SLACK_CHANNEL:1}
fi

if [ -n "$SLACK_ICON_EMOJI" ]; then
  SLACK_AVATAR="\"icon_emoji\":\"$SLACK_ICON_EMOJI\","
fi

if [ -n "$SLACK_ICON_URL" ]; then
  SLACK_AVATAR="\"icon_url\":\"$SLACK_ICON_URL\","
fi

if [ ! -n "$DEPLOY" ]; then
  WERCKER_STEP="Build #<$WERCKER_BUILD_URL|${WERCKER_BUILD_ID:0:5}>"
else
  WERCKER_STEP="Deploy #<$WERCKER_DEPLOY_URL|${WERCKER_DEPLOY_ID:0:5}>"
fi

if [ "$WERCKER_RESULT" = "passed" ]; then
  SLACK_COLOR="good"
else
  SLACK_COLOR="danger"
fi

if [[ $WERCKER_GIT_DOMAIN == bitbucket* ]]; then GIT_TREE="commits"; else GIT_TREE="commit"; fi

GIT_COMMIT_URL="<https://$WERCKER_GIT_DOMAIN/$WERCKER_GIT_OWNER/$WERCKER_GIT_REPOSITORY/$GIT_TREE/$WERCKER_GIT_COMMIT|${WERCKER_GIT_COMMIT:0:7}>"
GIT_PROJECT="$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME@$WERCKER_GIT_BRANCH"

if [ ! -n "$DEPLOY" ]; then
  SLACK_MESSAGE="$WERCKER_STEP ($GIT_COMMIT_URL) of $GIT_PROJECT by $WERCKER_STARTED_BY $WERCKER_RESULT."
else
  SLACK_MESSAGE="$WERCKER_STEP ($GIT_COMMIT_URL) of $GIT_PROJECT to $WERCKER_DEPLOYTARGET_NAME by $WERCKER_STARTED_BY $WERCKER_RESULT."
fi

SLACK_JSON="payload={ \
  \"channel\": \"#$SLACK_CHANNEL\", \
  \"username\": \"$SLACK_USERNAME\", \
  $SLACK_AVATAR
  \"attachments\":[{ \
    \"fallback\":\"$SLACK_MESSAGE\", \
    \"color\":\"$SLACK_COLOR\", \
    \"fields\":[{ \
      \"value\":\"$SLACK_MESSAGE\", \
      \"short\":false \
    }] \
  }] \
}"

SLACK_REQUEST_URL="https://$SLACK_SUBDOMAIN.slack.com/services/hooks/incoming-webhook?token=$SLACK_TOKEN"

if [ "$SLACK_NOTIFY_ON" = "failed" ]; then
  if [ "$WERCKER_RESULT" = "passed" ]; then
    echo "Skipping.."
    return 0
  fi
fi

RESPONSE=`curl -X POST --data-urlencode "$SLACK_JSON" "$SLACK_REQUEST_URL" -w " %{http_code}" -s`

if [ `echo $RESPONSE | awk '{ print $NF }'` != "200" ]; then
  fail "$RESPONSE"
fi
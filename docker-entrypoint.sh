#!/bin/bash

WEBHOOK_URL="<http://webhook.url>"
GCP_BUCKET="<gs://webhook-bucket>"
AUTH_TOKEN_PATH="${GCP_BUCKET}/<auth_token_string.txt>"

getToken() {
    gsutil cat ${AUTH_TOKEN_PATH}
}

postToWebhook() {
    access_token="$1"
    input_json="$2"

    # --silent - don't show download progress
    # --write-out - Print HTTP status code
    # --output - sending HTML output to '/dev/null'
    # --show-error - Show error if failure

    curl --header "Content-Type: application/json" \
        --header "Authorization: Bearer ${access_token}" \
        --silent --show-error \
        --write-out "%{http_code}" --output /dev/null \
        --request POST --data @${input_json} \
        ${WEBHOOK_URL}
}

echo "Acquiring token from $GCP_BUCKET"
access_token=$(getToken)
status=$?
if [ $status -ne 0 ]; then
    echo "Command failed to get authentication token!" 1>&2
    exit 1
fi
echo "Successfully acquired token"

echo "Preparing to call NeMO webhook"
input_json="$1"
http_code=$(postToWebhook $access_token $input_json)
status=$?

if [ $status -ne 0 ]; then
    echo "Command failed to POST to webhook! Respose code $http_code" 1>&2
    exit 1
fi
echo "Call to NeMO webhook yielded HTTP code $http_code"
exit 0
#!/bin/bash

RUNNERS_FILE="runners.txt"
DONTDELETE_FILE="dontdelete.txt"

if [ ! -f "$RUNNERS_FILE" ]; then
  touch "$RUNNERS_FILE"
fi

if [ ! -f "$DONTDELETE_FILE" ]; then
  touch "$DONTDELETE_FILE"
fi

while IFS=';' read -r RUNNER_URL RUNNER_TOKEN RUNNER_NAME RUNNER_GROUP; do
  if grep -q "$RUNNER_TOKEN" "$DONTDELETE_FILE"; then
    echo "Token $RUNNER_TOKEN already registered, skipping..."
    continue
  fi

  ./config.sh --unattended --url "${RUNNER_URL}" --token "${RUNNER_TOKEN}" --name "${RUNNER_NAME}" --runnergroup "${RUNNER_GROUP}"
  echo "$RUNNER_TOKEN" >> "$DONTDELETE_FILE"
done < "$RUNNERS_FILE"

./run.sh
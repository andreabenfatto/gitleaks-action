#!/bin/bash

INPUT_CONFIG_PATH="$1"
CONFIG=""

# check if a custom config have been provided
if [ -f "$GITHUB_WORKSPACE/$INPUT_CONFIG_PATH" ]; then
  CONFIG=" --config-path=$GITHUB_WORKSPACE/$INPUT_CONFIG_PATH"
fi

echo running gitleaks "$(gitleaks --version) with the following command👇"

echo gitleaks --path=$GITHUB_WORKSPACE --verbose --report=gitleaks-output.json --redact $CONFIG
CAPTURE_OUTPUT=$(gitleaks --path=$GITHUB_WORKSPACE --verbose --report=gitleaks-output.json --redact $CONFIG)

if [ $? -eq 1 ]
then
  GITLEAKS_RESULT=$(echo -e "\e[31m🛑 STOP! Gitleaks encountered leaks")
  echo "$GITLEAKS_RESULT"
  echo "::set-output name=exitcode::$GITLEAKS_RESULT"
  echo "----------------------------------"
  echo "$CAPTURE_OUTPUT"
  echo "::set-output name=result::$CAPTURE_OUTPUT"
  echo "----------------------------------"
  exit 1
else
  GITLEAKS_RESULT=$(echo -e "\e[32m✅ SUCCESS! Your code is good to go!")
  echo "$GITLEAKS_RESULT"
  echo "::set-output name=exitcode::$GITLEAKS_RESULT"
  echo "------------------------------------"
fi

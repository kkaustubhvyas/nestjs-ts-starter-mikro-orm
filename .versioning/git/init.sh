#!/usr/bin/env bash

# configure git to use email of commit-owner
git config --global pull.ff only
git config --global user.email "$CI_BOT_EMAIL"
git config --global user.name "$CI_BOT_USERNAME"

ORIGIN="$CI_SERVER_PROTOCOL://$CI_BOT_USERNAME:$CI_BOT_ACCESS_TOKEN@$CI_SERVER_HOST/$CI_PROJECT_PATH"
echo "setting origin remote to '$ORIGIN'"

# first cleanup any existing named remotes called 'origin' before re-setting the url
git remote rm origin
git remote add origin $ORIGIN
git fetch --tags

# have the gitlab runner checkout be linked to the branch we are building
git checkout -B "$CI_COMMIT_REF_NAME"

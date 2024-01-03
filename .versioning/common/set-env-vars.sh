#!/usr/bin/env bash

TIMESTAMP=$(date +%s)

# deployment environments
DEVELOPMENT="dev"
QA="qa"
STAGE="nonprod"
PROD="prod"
TEST="test"

# deployment branches
DEVELOPMENT_BRANCH="development"
QA_BRANCH="qa"
STAGE_BRANCH="stage"
PROD_BRANCH="release"

VERSION=$(cat package.json |
  grep version |
  head -1 |
  awk -F: '{ print $2 }' |
  sed 's/[",]//g' | xargs)
echo "Version: $VERSION"

echo "Branch Name: $CI_COMMIT_REF_NAME"

APP_ENV=$TEST

case $CI_COMMIT_REF_NAME in
$DEVELOPMENT_BRANCH)
  APP_ENV=$DEVELOPMENT
  ;;
$QA_BRANCH)
  APP_ENV=$QA
  ;;
$STAGE_BRANCH)
  APP_ENV=$STAGE
  ;;
$PROD_BRANCH)
  APP_ENV=$PROD
  ;;
*) ;;
esac

echo "Environment: $APP_ENV"

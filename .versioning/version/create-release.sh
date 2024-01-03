#!/usr/bin/env bash

echo "Creating new tag $NEXT_TAG"

git tag "$NEXT_TAG" -m "$(git log --pretty=%B $LAST_TAG...)"

git push --tags

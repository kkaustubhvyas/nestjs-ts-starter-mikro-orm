#!/usr/bin/env bash
increment_semver_loc="$(pwd)/.gitlab/version/increment-semver.sh"

source $increment_semver_loc

PREID="test"

case $APP_ENV in
$DEVELOPMENT)
    PREID=alpha
    ;;
$QA)
    PREID=beta
    ;;
$STAGE)
    PREID=rc
    ;;
$PROD)
    PREID=
    ;;
*) ;;
esac

echo "PREID: $PREID"

if [ -n "$PREID" ]; then
    LAST_TAG=$(git tag -l "$VERSION-$PREID*" | sort -V | tail -n1)
else
    LAST_TAG=$(git tag -l "v[0-9]*.[0-9]*.[0-9]*" | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -n1)
fi

echo "Last Tag: $LAST_TAG"

if [ -n "$LAST_TAG" ]; then
    echo "Found last tagged version $LAST_TAG"
    if [ -n "$PREID" ]; then
        if [[ $LAST_TAG =~ $VERSION-$PREID* ]]; then
            NEXT_TAG="$(increment_semver "$LAST_TAG" "prerelease")"
        else
            NEXT_TAG="$VERSION-$PREID.0"
        fi
    else
        NEXT_TAG=$VERSION
    fi
else
    echo "Creating new tag for version $VERSION"
    if [ -n "$PREID" ]; then
        NEXT_TAG="$VERSION-$PREID.0"
    else
        NEXT_TAG=$VERSION
    fi
fi

echo "Next Tag: $NEXT_TAG"

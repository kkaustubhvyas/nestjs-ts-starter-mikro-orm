#!/usr/bin/env bash
increment_semver_loc="$(pwd)/.gitlab/version/increment-semver.sh"
source $increment_semver_loc

# Create next version
NEXT_VERSION="$(increment_semver "$VERSION" "patch")"

echo "NEXT_VERSION: $NEXT_VERSION"

# Update new version in DEVELOPMENT
HOTFIX_BRANCH="hotfix/$NEXT_VERSION"
git checkout -b $HOTFIX_BRANCH
if [[ "$VERSION" != "$NEXT_VERSION" ]]; then
    VERSION_REPLACEMENT="s/[\"]version[\"]:[[:space:]][\"]$VERSION[\"]/\"version\":SPACE\"$NEXT_VERSION\"/"
    echo "$(sed $VERSION_REPLACEMENT package.json)" >package.json
    echo "$(sed 's/SPACE/ /g' package.json)" >package.json
    git add package.json
    echo "$(sed $VERSION_REPLACEMENT package-lock.json)" >package-lock.json
    echo "$(sed 's/SPACE/ /g' package-lock.json)" >package-lock.json
    git add package-lock.json
    git commit -m "🤖 chore: Version bump to $NEXT_VERSION" --no-verify
    git push origin $HOTFIX_BRANCH

    # The description of our new MR, we want to remove the branch after the MR has been closed
    BODY="{
      \"id\": ${CI_PROJECT_ID},
      \"source_branch\": \"${HOTFIX_BRANCH}\",
      \"target_branch\": \"${TARGET_BRANCH}\",
      \"remove_source_branch\": true,
      \"squash\": true,
      \"title\": \"🤖 chore: Hotfix Release $NEXT_VERSION\"
  }"

    # Require a list of all the merge request and take a look if there is already
    # one with the same source branch
    # LISTMR=$(curl --silent "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/merge_requests?state=opened" --header "PRIVATE-TOKEN:${CI_PIPELINE_TOKEN}")

    # echo "LISTMR: $LISTMR"

    # TO DO: FIX COMMAND ISSUE FOR ALPINE IMAGES
    # COUNTBRANCHES=$(echo ${LISTMR} | grep -o "\"source_branch\":\"${BACKMERGE_BRANCH}\"" | wc -l) || "0"
    COUNTBRANCHES="0"

    # echo "Checked for Existing MRs"

    # No MR found, let's create a new one
    if [ ${COUNTBRANCHES} -eq "0" ]; then
        echo "Creating new Merge Request"
        curl --fail -X POST "${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/merge_requests" \
            --header "PRIVATE-TOKEN:${CI_BOT_ACCESS_TOKEN}" \
            --header "Content-Type: application/json" \
            --data "${BODY}"
        echo "Opened a new merge request: \"🤖 chore: Backmerge Release $VERSION\" and assigned to you"
        exit
    fi
    echo "No new merge request opened"
else
    echo "version.py doesn't have the correct version to be replaced"
fi

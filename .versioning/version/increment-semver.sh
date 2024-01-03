#!/bin/bash

increment_semver() {
  local version="$1"
  local part="$2"

  version=$(echo "$version" | sed 's/^v//') # Remove "v" prefix if present

  major=$(echo "$version" | cut -d. -f1)
  minor=$(echo "$version" | cut -d. -f2)
  patch=$(echo "$version" | cut -d. -f3)
  pre_release=$(echo "$version" | cut -d. -f4)

  case "$part" in
  "major")
    major=$((major + 1))
    minor=0
    patch=0
    pre_release=""
    ;;
  "minor")
    minor=$((minor + 1))
    patch=0
    pre_release=""
    ;;
  "patch")
    patch=$((patch + 1))
    pre_release=""
    ;;
  "prerelease")
    if [ -z "$pre_release" ]; then
      pre_release="alpha.1"
    else
      pre_release_number=$(echo "$pre_release" | sed -E 's/(.*\.)([0-9]+)/\2/')
      pre_release_number=$((pre_release_number + 1))
      pre_release="$pre_release_number"
    fi
    ;;
  *)
    echo "Invalid part: $part"
    exit 1
    ;;
  esac

  new_version="v$major.$minor.$patch$([ -n "$pre_release" ] && echo ".$pre_release")"
  echo "$new_version"
}

## Example ##
# current_version="v1.2.3"

# new_version=$(increment_semver "$current_version" "prerelease")
# echo "next prerelease: $current_version --> $new_version"

# new_version=$(increment_semver "$current_version" "patch")
# echo "next patch:      $current_version --> $new_version"

# new_version=$(increment_semver "$current_version" "minor")
# echo "next minor:      $current_version --> $new_version"

# new_version=$(increment_semver "$current_version" "major")
# echo "next major:      $current_version --> $new_version"

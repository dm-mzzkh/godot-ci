#!/usr/bin/env bash
#
# Push deploy secrets from a local .secrets file into one or more GitHub repos.
#
# GitHub does not share secrets across repos on a personal account, so each game
# repo that calls the reusable godot-web-deploy workflow needs its own copy of
# these secrets. This script sets them all in one go instead of clicking the UI.
#
# Usage:
#   ./scripts/push-secrets.sh dm-mzzkh/turn-base-combat-figth dm-mzzkh/other-game
#   SECRETS_FILE=../shared/.secrets ./scripts/push-secrets.sh dm-mzzkh/game
#
# Requires: gh (authenticated: `gh auth login`).

set -euo pipefail

SECRETS_FILE="${SECRETS_FILE:-.secrets}"
SECRET_NAMES=(DEPLOY_SSH_KEY DEPLOY_USER DEPLOY_HOST DEPLOY_PATH PROXY_USER PROXY_HOST)

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <owner/repo> [<owner/repo> ...]" >&2
  exit 1
fi

if [ ! -f "$SECRETS_FILE" ]; then
  echo "Secrets file not found: $SECRETS_FILE" >&2
  exit 1
fi

command -v gh >/dev/null || { echo "gh CLI not found. Install it and run 'gh auth login'." >&2; exit 1; }

# Load KEY=value pairs (multi-line quoted values like the SSH key are handled by source).
set -a
# shellcheck disable=SC1090
source "$SECRETS_FILE"
set +a

for repo in "$@"; do
  echo "==> $repo"
  for name in "${SECRET_NAMES[@]}"; do
    value="${!name:-}"
    if [ -z "$value" ]; then
      echo "  ! $name not set in $SECRETS_FILE — skipping" >&2
      continue
    fi
    printf '%s' "$value" | gh secret set "$name" --repo "$repo"
    echo "  ✓ $name"
  done
done

echo "Done."

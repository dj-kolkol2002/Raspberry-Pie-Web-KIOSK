#!/usr/bin/env bash
# Generic browser kiosk launcher. NO credential automation is included.
set -Eeuo pipefail

CONFIG_FILE="${KIOSK_CONFIG:-$HOME/.config/kiosk/kiosk.env}"
if [[ ! -r "$CONFIG_FILE" ]]; then
  printf 'Kiosk config is missing or unreadable.\n' >&2
  exit 1
fi

# The configuration must be owned and editable only by a trusted local user.
# shellcheck source=/dev/null
source "$CONFIG_FILE"

if [[ ! "${KIOSK_URL:-}" =~ ^https?://[^[:space:]]+$ ]]; then
  printf 'Set a valid authorized http(s) URL in the local kiosk config.\n' >&2
  exit 1
fi

if ! command -v firefox-esr >/dev/null 2>&1; then
  printf 'Firefox ESR is not installed.\n' >&2
  exit 1
fi

# The browser typically runs in the foreground. Reopen after it exits.
# No password, login name or URL is written to console output.
while :; do
  firefox-esr --private-window --kiosk "$KIOSK_URL" || \
    printf 'Browser process exited unsuccessfully. Retrying.\n' >&2
  sleep 2
done

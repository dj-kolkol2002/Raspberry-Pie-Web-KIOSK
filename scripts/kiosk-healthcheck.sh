#!/usr/bin/env bash
# Read-only checks. No application URLs or credentials are printed.
set -Eeuo pipefail

ok() { printf '[ OK ] %s\n' "$1"; }
warn() { printf '[WARN] %s\n' "$1"; }

printf 'ARM64 web kiosk - local health check\n'

if systemctl is-active --quiet lightdm; then
  ok 'LightDM active'
else
  warn 'LightDM inactive'
fi

if [[ "$(systemctl get-default)" == 'graphical.target' ]]; then
  ok 'Graphical target configured'
else
  warn 'Default target is not graphical.target'
fi

if getent passwd kiosk >/dev/null; then
  ok 'Dedicated kiosk account exists'
else
  warn 'Dedicated kiosk account missing'
fi

if [[ -d /dev/dri ]] && compgen -G '/dev/dri/card*' >/dev/null; then
  ok 'DRM card devices detected'
else
  warn 'No DRM card detected; inspect display drivers'
fi

if command -v firefox-esr >/dev/null 2>&1; then
  ok 'Firefox ESR installed'
else
  warn 'Firefox ESR not installed'
fi

if pgrep -u kiosk -f '[f]irefox' >/dev/null 2>&1; then
  ok 'Firefox process for kiosk user detected'
else
  warn 'Firefox process for kiosk user not detected'
fi

printf 'For details see docs/TROUBLESHOOTING.md.\n'

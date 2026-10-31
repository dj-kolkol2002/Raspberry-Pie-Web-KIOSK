# Kiosk acceptance checklist

[← Home](../README.md) · [Troubleshooting](TROUBLESHOOTING.md)

Record results **locally**, not in the public repo when they contain asset IDs, people, business system names or internal URLs.

| Check | Expected outcome | Result |
| --- | --- | --- |
| Boot | Debian boots and reaches graphical mode | ☐ |
| DRM/KMS | Compatible display nodes exist in `/dev/dri` | ☐ |
| Graphical seat | `loginctl show-seat seat0 -p CanGraphical` confirms graphical support | ☐ |
| LightDM | `systemctl is-active lightdm` reports `active` | ☐ |
| User session | Dedicated kiosk account has an Openbox session | ☐ |
| Firefox ESR | Browser opens in fullscreen kiosk mode | ☐ |
| URL configuration | Only the authorized test application is opened | ☐ |
| Screen blanking | Display does not blank unexpectedly | ☐ |
| Recovery | Firefox starts again after the process exits | ☐ |
| Reboot persistence | Same flow succeeds after a full reboot | ☐ |
| Security | No secrets appear in scripts, public logs or Git history | ☐ |
| Recovery access | Authorized administrator can access a maintenance path | ☐ |

Useful commands:

```bash
systemctl is-active lightdm
loginctl list-sessions
loginctl show-seat seat0 -p CanGraphical
pgrep -af 'openbox|firefox' || true
bash scripts/kiosk-healthcheck.sh
```

**Acceptance limitation:** This template is not evidence that the supplied public files have been deployed or passed all tests on a target device.

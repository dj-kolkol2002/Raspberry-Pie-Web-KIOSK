# Troubleshooting playbook

[← Home](../README.md) · [Setup](SETUP.md) · [Acceptance checklist](ACCEPTANCE_CHECKLIST.md)

These checks were adapted from a practical Debian/ARM64 kiosk runbook. **Inspect logs before sharing them externally**: they can contain usernames, device names and application addresses.

| Symptom | Likely area | Diagnostic action |
| --- | --- | --- |
| `firefox-esr: no DISPLAY` | Browser started outside the graphical user session | Check LightDM, `DISPLAY`, the session owner and Openbox. Do not launch the kiosk browser directly from an ordinary SSH shell. |
| Blinking cursor / screen never starts | Display manager or X.Org | Inspect LightDM journal and X.Org log. |
| `Cannot run in framebuffer mode` | Legacy `fbdev` driver conflict | Check installed video drivers; remove `xserver-xorg-video-fbdev` only when confirmed as the cause. |
| `no screens found` | Incorrect DRM mapping or KMS setup | Verify `vc4-kms-v3d`, available `/dev/dri/card*` devices and the selected `kmsdev`. |
| Login screen is shown | LightDM autologin configuration | Check `autologin` group, username and configuration precedence. |
| Black screen with cursor | Openbox started but application failed | Check launcher, autostart file permissions and Firefox installation. |
| Browser works, app does not | DNS, connectivity, application availability | Test name resolution and HTTPS reachability to an **authorized** URL. |
| Form automation is unreliable | UI timing / focus | Prefer application-supported authentication. UI automation using `xdotool` is brittle and is not included in this public demo. |
| Browser remains closed | Launcher did not start or exited | Inspect script ownership, executable flag, Bash syntax and active processes. |

## systemd and session

```bash
systemctl status lightdm --no-pager
sudo journalctl -u lightdm -b -n 100 --no-pager
loginctl list-sessions
loginctl show-seat seat0 -p CanGraphical -p ActiveSession
```

## Graphics and driver state

```bash
ls -la /dev/dri
lsmod | grep -E 'vc4|v3d|drm'
for c in /sys/class/drm/card[0-9]; do
  echo "=== $(basename "$c") ==="
  ls "$c" | grep -E 'HDMI|DP|DSI' || true
done
sudo tail -n 100 /var/log/Xorg.0.log
```

## Browser and launch scripts

```bash
command -v firefox-esr
pgrep -af 'firefox|openbox|kiosk-launch' || true
ls -l /home/kiosk/.config/openbox/autostart
ls -l /home/kiosk/.local/bin/kiosk-launch.sh
bash -n /home/kiosk/.local/bin/kiosk-launch.sh
```

## DNS and web reachability

Do not paste corporate hostnames or private addresses into public tickets. Substitute your approved test hostname:

```bash
getent hosts example.invalid
curl -I --max-time 10 'https://example.invalid/'
```

The reserved `.invalid` domain is **expected not to resolve**. Use it only as a documentation placeholder; for a real test use a permitted endpoint.

## General health

```bash
free -h
df -h /
systemctl get-default
```

Where logs or screenshots are needed for troubleshooting, sanitize them before sharing.

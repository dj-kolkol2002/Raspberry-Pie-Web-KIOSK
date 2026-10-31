# Setup guide — Debian 13 ARM64 kiosk

[← Home](../README.md) · [Troubleshooting](TROUBLESHOOTING.md) · [Security](SECURITY.md)

This is a **generalized public installation guide**, not a copy of a live organization's workstation setup. Use test hardware and a URL you are authorized to access. Commands assume you are in the repository root and have administrative `sudo` access.

## 1. Starting conditions

- Debian 13 for ARM64 is installed and starts in a console.
- HDMI monitor and keyboard (for initial recovery) are connected.
- Network access and package repositories work.
- The graphics stack is compatible with the target board.

Inspect the baseline:

```bash
hostnamectl
cat /etc/os-release
uname -m
ip -br address
sudo timedatectl set-timezone Europe/Warsaw
sudo apt update && sudo apt full-upgrade -y
```

`uname -m` should usually report `aarch64` on an ARM64 kernel. Reboot if core packages or the kernel were upgraded.

## 2. Accounts and packages

Create a **dedicated non-admin kiosk account**. Do not publish its real-world password or reuse an organization's production account in demonstrations.

```bash
sudo adduser kiosk
getent group autologin || sudo groupadd -r autologin
sudo usermod -aG autologin kiosk
id kiosk
```

Install required packages:

```bash
sudo apt install -y \
  openssh-server xserver-xorg-core xserver-xorg-input-libinput \
  xinit lightdm lightdm-gtk-greeter openbox dbus-x11 \
  firefox-esr x11-xserver-utils xdotool curl
```

If the package manager prompts for a display manager, select **LightDM**. Enable SSH only if remote management is authorized:

```bash
sudo systemctl enable --now ssh
```

Prefer SSH keys, least privilege and suitable firewall rules. Auto-login bypasses the OS password prompt for local access; assess physical-security requirements first.

## 3. Configure the graphics stack

On Raspberry Pi-class hardware, review `/boot/firmware/config.txt` and merge the options shown in [`config/firmware/config.txt.snippet`](../config/firmware/config.txt.snippet) **without replacing the rest of the firmware configuration**:

```ini
[all]
dtoverlay=vc4-kms-v3d
max_framebuffers=2
disable_fw_kms_setup=1
```

Avoid duplicate conflicting `dtoverlay` settings. These values come from the documented KMS-based configuration and may need adjustment for a different board, firmware or kernel.

After reboot:

```bash
ls -la /dev/dri
lsmod | grep -E 'vc4|v3d'
loginctl show-seat seat0 -p CanGraphical
```

**Identify the actual DRM card** that exposes HDMI (do not blindly assume `card1`):

```bash
for c in /sys/class/drm/card[0-9]; do
  echo "=== $(basename "$c") ==="
  readlink -f "$c/device/driver"
  ls "$c" | grep -E 'HDMI|DP|DSI' || true
done
```

If explicit X.Org device selection is necessary, edit the template [`config/xorg/20-modesetting.conf`](../config/xorg/20-modesetting.conf), uncomment `Option "kmsdev"` and replace the **example path** with the correct local `/dev/dri/cardN`. Then install:

```bash
sudo install -d -m 755 /etc/X11/xorg.conf.d
sudo install -m 644 config/xorg/20-modesetting.conf \
  /etc/X11/xorg.conf.d/20-modesetting.conf
```

If X.Org automatically detects the proper device, the override can be omitted. On an environment with a confirmed framebuffer conflict, consider removing `xserver-xorg-video-fbdev` after checking dependencies:

```bash
# Only if the fbdev driver causes the documented failure:
# sudo apt purge xserver-xorg-video-fbdev
```

## 4. Install the LightDM session configuration

Review [`config/lightdm/99-kiosk.conf`](../config/lightdm/99-kiosk.conf) before installing it:

```bash
sudo install -d -m 755 /etc/lightdm/lightdm.conf.d
sudo install -m 644 config/lightdm/99-kiosk.conf \
  /etc/lightdm/lightdm.conf.d/99-kiosk.conf
sudo lightdm --show-config | grep -E 'logind-check|autologin|user-session'
```

The `logind-check-graphical=false` setting is a compatibility workaround included in the source deployment. Use it only when your hardware/session requires it.

## 5. Install browser launch files

Create directories with correct ownership and permissions:

```bash
sudo install -d -o kiosk -g kiosk -m 700 /home/kiosk/.config/kiosk
sudo install -d -o kiosk -g kiosk -m 700 /home/kiosk/.config/openbox
sudo install -d -o kiosk -g kiosk -m 755 /home/kiosk/.local/bin
```

Install the scripts and templates:

```bash
sudo install -o kiosk -g kiosk -m 600 config/kiosk.env.example \
  /home/kiosk/.config/kiosk/kiosk.env
sudo install -o kiosk -g kiosk -m 700 config/openbox/autostart \
  /home/kiosk/.config/openbox/autostart
sudo install -o kiosk -g kiosk -m 755 scripts/kiosk-launch.sh \
  /home/kiosk/.local/bin/kiosk-launch.sh
```

Edit the **local** URL setting:

```bash
sudo -u kiosk nano /home/kiosk/.config/kiosk/kiosk.env
```

Example of a placeholder, **not a real application endpoint**:

```bash
KIOSK_URL='https://kiosk.example.invalid'
```

Replace it with your own approved test destination. The launcher sources this kiosk-owned configuration file, so only trusted administrators should edit it. Never place passwords or API tokens in this file.

## 6. Enable the kiosk session

```bash
sudo systemctl set-default graphical.target
sudo systemctl enable lightdm
sudo reboot
```

Expected flow: boot → LightDM → Openbox → Firefox ESR in kiosk mode → configured web page. The browser launcher attempts to start Firefox again after the browser exits. For a reliable, locked-down kiosk, configure physical and OS escape controls separately.

## 7. Verify the result

```bash
systemctl is-active lightdm
loginctl list-sessions
loginctl show-seat seat0 -p CanGraphical -p ActiveSession
ls -la /dev/dri
pgrep -a firefox || true
bash scripts/kiosk-healthcheck.sh
```

Complete the [`ACCEPTANCE_CHECKLIST.md`](ACCEPTANCE_CHECKLIST.md) and see [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md) when issues occur.

## 8. Recovery and backup

- Keep a physical or authorized remote recovery path, including an alternative text console.
- Back up **configuration only** into a protected location; backups of real machines may contain internal URLs or credentials.
- Do not commit system logs, browser profiles, SSH keys, cookies, screenshots from real ERP systems or backups to this repository.
- Before publishing, verify your organization's authorization rules.

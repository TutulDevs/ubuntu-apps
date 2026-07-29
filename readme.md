# Ubuntu Setup Guide

`setup_environment.sh` is a single script that provisions a fresh Ubuntu 24.04 LTS
machine with the tools and apps below. It's organized as one function per step, all
called in order from `main()`, so any step can be commented out or re-run on its own.

## Usage

```bash
chmod +x setup_environment.sh
./setup_environment.sh
```

Notes:

- Requires `sudo` — you'll be prompted for your password.
- Safe to re-run; steps check for existing installs/config where it matters
  (NVM, SSH key, locale, heap limit) instead of redoing them.
- No Snap packages are used anywhere in the script — everything installs via
  `apt`, an official vendor repo, or a direct download.
- Log out and back in after running so the Docker group membership takes effect.

## What gets installed

| # | Step | Notes |
|---|------|-------|
| 1 | System update | `apt update` |
| 2 | Git & Git Flow | Sets global `user.name`/`user.email` — edit `installGit()` first if these aren't yours |
| 3 | NVM & Node.js 20 | Installs NVM, then Node 20 as the default |
| 4 | PostgreSQL | Enables and starts the service |
| 5 | pgAdmin 4 (Web) | Run `sudo /usr/pgadmin4/bin/setup-web.sh` afterward to set credentials |
| 6 | Redis | Configured to daemonize, enabled and started |
| 7 | Docker Engine | Installs via Docker's official apt repo; adds current user to `docker` group |
| 8 | GParted | |
| 9 | Claude Code CLI | |
| 10 | Cheese | Webcam app |
| 11 | CPU-X | |
| 12 | Gnumeric | |
| 13 | Cursor AI IDE | **Disabled by default** (call is commented out in `main()`) — uncomment `installCursor` to enable |
| 14 | VS Code | Downloaded `.deb` from Microsoft, installed via `dpkg` |
| 15 | Google Chrome | Downloaded `.deb` from Google, installed via `dpkg` |
| 16 | Brave Browser | Official install script |
| 17 | Microsoft Edge | Installs via Microsoft's official apt repo |
| 18 | GNOME Shell Extensions support | `chrome-gnome-shell` |
| 19 | Yarn | Installed globally via npm (depends on step 3) |
| 20 | VLC | |
| 21 | Cascadia Code font | |
| 22 | SSH key | `ed25519`, no passphrase, skipped if `~/.ssh/id_ed25519` already exists |
| 23 | Remove unnecessary apps | Purges Thunderbird, LibreOffice, Remmina |
| 24 | Monday as first day of week | Patches the `en_US` locale and regenerates it — reboot to apply |
| 25 | Node.js heap limit fix | Adds `NODE_OPTIONS="--max-old-space-size=8192"` to `~/.bashrc` |

## Customizing

Each step is a standalone function. To skip a step, comment out its call inside
`main()` (as already done for `installCursor`). The script calls `main` unconditionally
when run, so sourcing the file will execute every step — there's no separate
opt-in flag for running a single function in isolation.

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
| 2 | curl | |
| 3 | Git & Git Flow | Sets global `user.name`/`user.email` — edit `installGit()` first if these aren't yours |
| 4 | NVM & Node.js 24.15.0 | Installs NVM, then Node 24.15.0 as the default |
| 5 | PostgreSQL | Enables and starts the service |
| 6 | pgAdmin 4 (Web) | Run `sudo /usr/pgadmin4/bin/setup-web.sh` afterward to set credentials |
| 7 | Redis | Configured to daemonize, enabled and started |
| 8 | Docker Engine | Installs via Docker's official apt repo; adds current user to `docker` group; also installs `docker-compose` |
| 9 | GParted | |
| 10 | Claude Code CLI | |
| 11 | Claude Desktop | Linux beta; installs via Anthropic's official apt repo, adds current user to `kvm` group (for Cowork) |
| 12 | Command Code CLI | **Disabled by default** — uncomment `installCommandCodeCli` in `main()` to enable. Installed globally via npm (depends on step 4); run `cmd` in a project |
| 13 | Command Code Desktop | **Disabled by default** — uncomment `installCommandCodeDesktop` in `main()` to enable. Official install script from CommandCodeAI's GitHub; Ubuntu/Debian x64 only |
| 14 | OpenCode CLI | **Disabled by default** — uncomment `installOpencode` in `main()` to enable |
| 15 | CPU-X | |
| 16 | Gnumeric | |
| 17 | Cursor AI IDE | **Disabled by default** (call is commented out in `main()`) — uncomment `installCursor` to enable |
| 18 | VS Code | Downloaded `.deb` from Microsoft, installed via `dpkg` |
| 19 | Google Chrome | Downloaded `.deb` from Google, installed via `dpkg` |
| 20 | Brave Browser | Official install script |
| 21 | Microsoft Edge | Installs via Microsoft's official apt repo |
| 22 | GNOME Shell Extensions support | `chrome-gnome-shell` |
| 23 | Yarn | Installed globally via npm (depends on step 4) |
| 24 | pnpm | Installed globally via npm (depends on step 4) |
| 25 | VLC | |
| 26 | Cascadia Code font | |
| 27 | SSH key | `ed25519`, no passphrase, skipped if `~/.ssh/id_ed25519` already exists |
| 28 | Remove unnecessary apps | Purges Thunderbird, LibreOffice, Remmina |
| 29 | Monday as first day of week | Patches the `en_US` locale and regenerates it — reboot to apply |
| 30 | Node.js heap limit fix | Adds `NODE_OPTIONS="--max-old-space-size=8192"` to `~/.bashrc` |

## Customizing

Each step is a standalone function. To skip a step, comment out its call inside
`main()` (as already done for `installCursor`, `installOpencode`, `installCommandCodeCli`
and `installCommandCodeDesktop`). The script calls `main` unconditionally
when run, so sourcing the file will execute every step — there's no separate
opt-in flag for running a single function in isolation.

## Next steps (post-install checks)

A handful of steps need a manual follow-up after the script finishes — either to
verify they actually work, or to finish configuration the script can't safely
automate (passwords, group membership, reboots).

- **Docker** — log out/in (or `newgrp docker`) so your user picks up the `docker`
  group, then smoke-test both the engine and Compose:
  ```bash
  docker run --rm hello-world
  docker compose version
  docker-compose --version
  ```
- **Redis** — confirm it's enabled on boot and actually reachable:
  ```bash
  sudo systemctl is-enabled redis-server
  sudo systemctl status redis-server
  redis-cli ping   # expect PONG
  ```
- **PostgreSQL** — confirm the service is enabled/running, then set a password
  for the `postgres` role if you plan to connect over TCP:
  ```bash
  sudo systemctl is-enabled postgresql
  sudo -u postgres psql -c "\du"
  sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'yourpassword';"
  ```
- **pgAdmin 4 (Web)** — the script only installs the package; you still need to
  finalize the web credentials before logging in:
  ```bash
  sudo /usr/pgadmin4/bin/setup-web.sh
  ```
  Then browse to `http://localhost/pgadmin4`.
- **Git** — the script hardcodes `user.name`/`user.email`; verify (and fix) them
  before your first commit:
  ```bash
  git config --global --list
  ```
- **SSH key** — a new `~/.ssh/id_ed25519` was generated but isn't registered
  anywhere yet. Copy the public key to GitHub/GitLab/your server:
  ```bash
  cat ~/.ssh/id_ed25519.pub
  ssh -T git@github.com   # after adding it, sanity-check auth
  ```
- **NVM / Node / Yarn / pnpm** — open a new shell (so `~/.bashrc` is re-sourced) and
  confirm the versions actually resolve:
  ```bash
  node -v
  npm -v
  yarn --version
  pnpm --version
  ```
- **Claude Code CLI / OpenCode CLI / Command Code CLI** — open a new shell and
  confirm each is on `PATH`, then log in:
  ```bash
  claude --version && claude login
  opencode --version
  command -v cmd   # Command Code CLI
  ```
- **Claude Desktop** — launch **Claude** from the app menu (or run `claude-desktop`)
  and sign in. Log out and back in first so the `kvm` group applies, otherwise
  Cowork won't start. Updates arrive via regular `sudo apt upgrade`.
- **Locale change (Monday as first weekday)** — this only takes effect after a
  reboot (or full logout) — a new terminal alone isn't enough.
- **Node.js heap limit** — also only takes effect in a new shell (or `source ~/.bashrc`).

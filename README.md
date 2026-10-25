# SCAAI COMMUNITY — Releases

This repository hosts **only release artifacts** for SCAAI Desktop.

Source code is **not** published here.

## Releases

### Windows

| Asset | Purpose |
|---|---|
| `SCAAI-Setup-<version>-x64.exe` | The installer users download and run |
| `latest.yml` | Auto-updater index — installed apps poll this to discover new versions |
| `SCAAI-Setup-<version>-x64.exe.blockmap` | Differential update map for delta downloads |

### macOS (universal)

| Asset | Purpose |
|---|---|
| `SCAAI-<version>-universal.dmg` | The DMG for manual install (Intel + Apple Silicon) |
| `SCAAI-<version>-mac-universal.zip` | Auto-updater payload — the updater installs this zip |
| `latest-mac.yml` | Auto-updater index for macOS — the app polls this for updates |
| `SCAAI-<version>-universal.dmg.blockmap` | Differential update map for the DMG |
| `SCAAI-<version>-mac-universal.zip.blockmap` | Differential update map for the zip |

## Latest release: v5.3.6

Published 2026-10-24 (macOS artifacts added 2026-10-25).

- **Windows:** `SCAAI-Setup-5.3.6-x64.exe` + `latest.yml` + blockmap
- **macOS (universal):** `SCAAI-5.3.6-universal.dmg` + `SCAAI-5.3.6-mac-universal.zip` + `latest-mac.yml` + both blockmaps

Download from the [v5.3.6 release](https://github.com/Nooran3994/SCAAI-COMMUNITY/releases/tag/v5.3.6).

## Run Environment

| Component | Requirement |
|---|---|
| OS | Windows 10 / 11 (64-bit) |
| Architecture (Windows) | x64 |
| Installer (Windows) | SCAAI-Setup-<version>-x64.exe (NSIS) |
| Auto-update (Windows) | Supported via latest.yml + blockmap |
| OS (macOS) | macOS 12+ (Monterey or newer) |
| Architecture (macOS) | Universal — Apple Silicon & Intel x64 |
| Installer (macOS) | SCAAI-<version>-universal.dmg |
| Auto-update (macOS) | Supported via latest-mac.yml + zip + blockmap |
| Min RAM | 4 GB (8 GB recommended) |
| Disk | ~300 MB free |

## Update flow (Windows)

1. Installed app polls `releases/latest/download/latest.yml` on launch and every 4 hours.
2. If the remote version is newer than the installed version, the app offers an update.
3. The updater downloads the new installer (or blockmap delta) and installs it.

## Update flow (macOS)

1. Installed app polls `releases/latest/download/latest-mac.yml` on launch.
2. If the remote version is newer, the app offers an update.
3. The updater downloads `SCAAI-<version>-mac-universal.zip` (or blockmap delta) and replaces the app bundle.

## Versioning

Semantic versioning. Every release must bump the version — the updater compares tags,
so shipping the same version twice silently skips the update for existing installs.

## License & Terms

- [LICENSE](LICENSE) — MIT License
- [TERMS.md](TERMS.md) — Terms of Use for the SCAAI Desktop release artifacts

## Security

See [SECURITY.md](./SECURITY.md) for vulnerability reporting and policy.

## Repository Contents

This repository intentionally contains **only**:

- `LICENSE` (MIT)
- `TERMS.md`
- `README.md`
- `SECURITY.md`
- `release/<version>/latest.yml` (auto-update index)

**Installers and update artifacts are distributed exclusively via GitHub Releases** (`/releases`). No binaries are tracked in this repository.

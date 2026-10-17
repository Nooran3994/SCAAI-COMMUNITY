# SCAAI COMMUNITY — Releases

This repository hosts **only release artifacts** for SCAAI Desktop.

Source code is **not** published here.

## Releases

Every release contains:

| Asset | Purpose |
|---|---|
| `SCAAI-Setup-<version>-x64.exe` | The installer users download and run |
| `latest.yml` | Auto-updater index — installed apps poll this to discover new versions |
| `SCAAI-Setup-<version>-x64.exe.blockmap` | Differential update map for delta downloads |

## Run Environment

| Component | Requirement |
|---|---|
| OS | Windows 10 / 11 (64-bit) |
| Architecture | x64 |
| Installer | SCAAI-Setup-<version>-x64.exe (NSIS) |
| Auto-update | Supported via latest.yml + blockmap |
| Min RAM | 4 GB (8 GB recommended) |
| Disk | ~300 MB free |

## Update flow

1. Installed app polls `releases/latest/download/latest.yml` on launch and every 4 hours.
2. If the remote version is newer than the installed version, the app offers an update.
3. The updater downloads the new installer (or blockmap delta) and installs it.

## Versioning

Semantic versioning. Every release must bump the version — the updater compares tags,
so shipping the same version twice silently skips the update for existing installs.

## License & Terms

- [LICENSE](LICENSE) — MIT License
- [TERMS.md](TERMS.md) — Terms of Use for the SCAAI Desktop release artifacts
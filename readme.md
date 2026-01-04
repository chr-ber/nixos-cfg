# 🏗️ SYSTEM BLUEPRINTS

> **Repository:** `~/nixos-cfg`  
> **Architecture:** NixOS with Flakes and Home Manager

---

## 🗺️ Directory Structure

```text
~/nixos-cfg/
├── hosts/                     # Systems: Host based configuration
│   ├── hmsrvr/
│   │   ├── configuration.nix  # System settings, drivers, services
│   │   ├── hardware-config... # Hardware configuration (auto generated)
│   │   └── home.nix           # Home settings, apps, shell
│   └── wrkstn/
│   │   ├── configuration.nix  # System settings, drivers, services
│   │   ├── hardware-config... # Hardware configuration (auto generated)
│   │   └── home.nix           # Home settings, apps, shell
├── modules/                   # Reusable configs
├── docker/                    # Docker compose files
├── scripts/                   # Scripts for common tasks
├── flake.nix                  # Entry point. Connects system and home
├── flake.lock                 # Records the exact versions of all dependencies
└──.cache/                     # Non-tracked, imperative files
    ├── builds/                # Test builds & binaries
    ├── backup/                # Reference files & snapshots
    └── sources/               # Cloned repos for source access
``` 

## 🧩 Component Architecture

### 1. Nix Flakes (`flake.nix`)
**Role:** Declarative System Definition & Version Pinning
- Defines the system architecture and inputs (dependencies).
- Locks all dependencies to specific commit hashes via `flake.lock` to ensure reproducible builds.
- Serves as the single entry point for all configurations.

### 2. System Configuration (`hosts/`)
**Role:** System-Level Management (Root Context)
- Manages the operating system core: Bootloader, Kernel, Hardware Drivers, and Networking.
- Handles system-wide services (Docker, Systemd, etc.) and security policies.
- **Access Level:** Requires `sudo` (root privileges) to apply changes.

### 3. Home Manager (`home.nix` & modules)
**Role:** User Environment Management (User Context)
- Manages user-specific applications (Browsers, IDEs, Tools).
- Configures dotfiles, shell environments (Zsh), and theming.
- **Access Level:** User-space only (typically matches the `~/.config` scope).

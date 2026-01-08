#!/usr/bin/env bash
# Initialize directory structure for media stack
# Atomic Move strategy requires consistent paths across all services

set -euo pipefail

echo "Creating media stack directories..."

# Torrent directories (where qBittorrent saves files)
mkdir -p /data/torrents/movies
mkdir -p /data/torrents/tv
mkdir -p /data/torrents/incomplete
mkdir -p /data/torrents/mixed

# Media directories (where Sonarr/Radarr organize files)
mkdir -p /data/media/movies
mkdir -p /data/media/tv

# Docker config directories
mkdir -p /data/docker/{prowlarr,sonarr,radarr,bazarr,overseerr,qbittorrent,plex}

# Set ownership to match container PUID:PGID (1000:100)
echo "Setting ownership to 1000:100..."
chown -R 1000:100 /data/torrents
chown -R 1000:100 /data/media
chown -R 1000:100 /data/docker

echo "Directory structure ready!"
ls -la /data/

#!/usr/bin/env bash
# Initialize directory structure for media stack
# Atomic Move strategy requires consistent paths across all services

set -euo pipefail

echo "Creating media stack directories..."

# Usenet directories (where SABnzbd saves files)
mkdir -p /data/usenet/complete/movies
mkdir -p /data/usenet/complete/tv
mkdir -p /data/usenet/complete/mixed
mkdir -p /data/usenet/incomplete

# Torrent directories (where qBittorrent saves files)
mkdir -p /data/torrents/complete/movies
mkdir -p /data/torrents/complete/tv
mkdir -p /data/torrents/complete/mixed
mkdir -p /data/torrents/incomplete

# Media directories (where Sonarr/Radarr organize files)
mkdir -p /data/media/movies
mkdir -p /data/media/tv
mkdir -p /data/media/mixed
mkdir -p /data/media/music

# Docker config directories
mkdir -p /data/docker/{prowlarr,sonarr,radarr,bazarr,overseerr,sabnzbd,plex}

# Set ownership to match container PUID:PGID (1000:100)
echo "Setting ownership to 1000:100..."
chown -R 1000:100 /data/usenet
chown -R 1000:100 /data/torrents
chown -R 1000:100 /data/media
chown -R 1000:100 /data/docker

echo "Directory structure ready!"
ls -la /data/


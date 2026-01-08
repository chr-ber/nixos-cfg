#!/usr/bin/env python3
"""
Media Stack Configuration Script

Configures SABnzbd, Sonarr, Radarr, and Prowlarr via their APIs.
Run this after the stack is up and you've set API keys in .env

Usage:
    python3 configure-media-stack.py [--host HOST]
"""

import os
import sys
import json
import argparse
from pathlib import Path

try:
    import requests
except ImportError:
    print("Error: 'requests' library not found. Install with: pip install requests")
    sys.exit(1)


# ============================================================================
# Configuration
# ============================================================================

# Service ports (external ports from docker-compose)
PORTS = {
    "prowlarr": 10101,
    "sonarr": 10102,
    "radarr": 10103,
    "bazarr": 10104,
    "overseerr": 10105,
    "sabnzbd": 10106,
}

# SABnzbd settings
SABNZBD_CONFIG = {
    "complete_dir": "/data/usenet/complete",
    "incomplete_dir": "/data/usenet/incomplete",
}

SABNZBD_CATEGORIES = {
    "movies": "/data/usenet/complete/movies",
    "tv": "/data/usenet/complete/tv",
}

# ============================================================================
# Helper Functions
# ============================================================================

def load_env():
    """Load API keys from .env file"""
    env_path = Path(__file__).parent / ".env"
    env = {}
    
    if env_path.exists():
        with open(env_path) as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#") and "=" in line:
                    key, value = line.split("=", 1)
                    env[key.strip()] = value.strip()
    
    # Also check environment variables
    for key in ["SONARR_API_KEY", "RADARR_API_KEY", "PROWLARR_API_KEY", "SABNZBD_API_KEY"]:
        if key in os.environ:
            env[key] = os.environ[key]
    
    return env


def api_request(method, url, api_key=None, **kwargs):
    """Make an API request with error handling"""
    headers = kwargs.pop("headers", {})
    if api_key:
        headers["X-Api-Key"] = api_key
    
    try:
        resp = requests.request(method, url, headers=headers, timeout=30, **kwargs)
        resp.raise_for_status()
        return resp
    except requests.exceptions.RequestException as e:
        print(f"  ✗ Request failed: {e}")
        return None


# ============================================================================
# SABnzbd Configuration
# ============================================================================

def configure_sabnzbd(host, sabnzbd_key):
    """Configure SABnzbd host_whitelist and categories.
    
    Note: SABnzbd API key is shown on first launch. Categories can be set up
    via the API once you have the key, but initial setup is done via web UI.
    """
    base_url = f"http://{host}:{PORTS['sabnzbd']}/api"
    
    print("\n📦 Configuring SABnzbd...")
    
    if not sabnzbd_key:
        print("  ℹ SABnzbd requires initial web UI setup.")
        print(f"  → Open: http://{host}:{PORTS['sabnzbd']}/")
        print("  → Complete the wizard to get your API key")
        print("  → Add categories 'tv' and 'movies' in Config → Categories")
        print("    Set paths to:")
        for name, path in SABNZBD_CATEGORIES.items():
            print(f"      - {name}: {path}")
        return True
    
    # Configure host_whitelist to allow connections from Docker network
    print("  → Configuring host whitelist...")
    whitelist_hosts = ["sabnzbd", "sabnzbd.hmsrvr.lan"]
    
    try:
        # Get current config
        resp = requests.get(f"{base_url}?mode=get_config&apikey={sabnzbd_key}&output=json", timeout=10)
        if resp.status_code == 200:
            config = resp.json().get("config", {})
            current_whitelist = config.get("misc", {}).get("host_whitelist", [])
            
            # Add our hosts if not already present
            updated = False
            for h in whitelist_hosts:
                if h not in current_whitelist:
                    current_whitelist.append(h)
                    updated = True
            
            if updated:
                whitelist_str = ",".join(current_whitelist)
                resp = requests.get(
                    f"{base_url}?mode=set_config&section=misc&keyword=host_whitelist&value={whitelist_str}&apikey={sabnzbd_key}&output=json",
                    timeout=10
                )
                if resp.status_code == 200:
                    print(f"    ✓ Host whitelist updated: {whitelist_hosts}")
                else:
                    print(f"    ✗ Failed to update whitelist: {resp.status_code}")
            else:
                print("    ○ Host whitelist already configured")
        else:
            print(f"    ✗ Could not get SABnzbd config: {resp.status_code}")
    except requests.exceptions.RequestException as e:
        print(f"    ✗ SABnzbd not reachable: {e}")
    
    # Print category setup instructions (manual step for now)
    print("  ℹ Set up categories in Config → Categories:")
    for name, path in SABNZBD_CATEGORIES.items():
        print(f"      - {name}: {path}")
    
    return True


# ============================================================================
# Sonarr Configuration
# ============================================================================

def configure_sonarr(host, api_key, sabnzbd_key):
    """Configure Sonarr root folder and download client"""
    base_url = f"http://{host}:{PORTS['sonarr']}/api/v3"
    
    print("\n📺 Configuring Sonarr...")
    
    # Add root folder
    print("  → Adding root folder...")
    existing = api_request("GET", f"{base_url}/rootfolder", api_key)
    if existing:
        paths = [rf["path"] for rf in existing.json()]
        if "/data/media/tv" in paths:
            print("    ○ Root folder already exists")
        else:
            resp = api_request("POST", f"{base_url}/rootfolder", api_key, 
                             json={"path": "/data/media/tv"})
            if resp:
                print("    ✓ Root folder added: /data/media/tv")
    
    # Add download client (SABnzbd for Usenet)
    print("  → Adding download client...")
    clients = api_request("GET", f"{base_url}/downloadclient", api_key)
    if clients:
        names = [c["name"] for c in clients.json()]
        if "SABnzbd" in names:
            print("    ○ SABnzbd client already exists")
        else:
            if not sabnzbd_key:
                print("    ⚠ No SABNZBD_API_KEY in .env - add manually")
            else:
                client_config = {
                    "enable": True,
                    "protocol": "usenet",
                    "priority": 1,
                    "removeCompletedDownloads": True,
                    "removeFailedDownloads": True,
                    "name": "SABnzbd",
                    "fields": [
                        {"name": "host", "value": "sabnzbd"},
                        {"name": "port", "value": 8080},
                        {"name": "useSsl", "value": False},
                        {"name": "urlBase"},
                        {"name": "apiKey", "value": sabnzbd_key},
                        {"name": "username", "value": ""},
                        {"name": "password", "value": ""},
                        {"name": "tvCategory", "value": "tv"},
                        {"name": "recentTvPriority", "value": -100},
                        {"name": "olderTvPriority", "value": -100},
                    ],
                    "implementationName": "SABnzbd",
                    "implementation": "Sabnzbd",
                    "configContract": "SabnzbdSettings",
                    "tags": []
                }
                resp = api_request("POST", f"{base_url}/downloadclient", api_key, 
                                 json=client_config)
                if resp:
                    print("    ✓ SABnzbd client added")
    
    return True


# ============================================================================
# Radarr Configuration
# ============================================================================

def configure_radarr(host, api_key, sabnzbd_key):
    """Configure Radarr root folder and download client"""
    base_url = f"http://{host}:{PORTS['radarr']}/api/v3"
    
    print("\n🎬 Configuring Radarr...")
    
    # Add root folder
    print("  → Adding root folder...")
    existing = api_request("GET", f"{base_url}/rootfolder", api_key)
    if existing:
        paths = [rf["path"] for rf in existing.json()]
        if "/data/media/movies" in paths:
            print("    ○ Root folder already exists")
        else:
            resp = api_request("POST", f"{base_url}/rootfolder", api_key, 
                             json={"path": "/data/media/movies"})
            if resp:
                print("    ✓ Root folder added: /data/media/movies")
    
    # Add download client (SABnzbd for Usenet)
    print("  → Adding download client...")
    clients = api_request("GET", f"{base_url}/downloadclient", api_key)
    if clients:
        names = [c["name"] for c in clients.json()]
        if "SABnzbd" in names:
            print("    ○ SABnzbd client already exists")
        else:
            if not sabnzbd_key:
                print("    ⚠ No SABNZBD_API_KEY in .env - add manually")
            else:
                client_config = {
                    "enable": True,
                    "protocol": "usenet",
                    "priority": 1,
                    "removeCompletedDownloads": True,
                    "removeFailedDownloads": True,
                    "name": "SABnzbd",
                    "fields": [
                        {"name": "host", "value": "sabnzbd"},
                        {"name": "port", "value": 8080},
                        {"name": "useSsl", "value": False},
                        {"name": "urlBase"},
                        {"name": "apiKey", "value": sabnzbd_key},
                        {"name": "username", "value": ""},
                        {"name": "password", "value": ""},
                        {"name": "movieCategory", "value": "movies"},
                        {"name": "recentMoviePriority", "value": -100},
                        {"name": "olderMoviePriority", "value": -100},
                    ],
                    "implementationName": "SABnzbd",
                    "implementation": "Sabnzbd",
                    "configContract": "SabnzbdSettings",
                    "tags": []
                }
                resp = api_request("POST", f"{base_url}/downloadclient", api_key, 
                                 json=client_config)
                if resp:
                    print("    ✓ SABnzbd client added")
    
    return True


# ============================================================================
# Prowlarr Configuration
# ============================================================================

def configure_prowlarr(host, api_key, sonarr_key, radarr_key):
    """Configure Prowlarr to sync with Sonarr and Radarr"""
    base_url = f"http://{host}:{PORTS['prowlarr']}/api/v1"
    
    print("\n🔍 Configuring Prowlarr...")
    
    # Get existing applications
    apps = api_request("GET", f"{base_url}/applications", api_key)
    if not apps:
        return False
    
    existing_names = [a["name"] for a in apps.json()]
    
    # Add Sonarr
    print("  → Adding Sonarr application...")
    if "Sonarr" in existing_names:
        print("    ○ Sonarr already configured")
    else:
        sonarr_config = {
            "name": "Sonarr",
            "syncLevel": "fullSync",
            "fields": [
                {"name": "prowlarrUrl", "value": f"http://prowlarr:9696"},
                {"name": "baseUrl", "value": "http://sonarr:8989"},
                {"name": "apiKey", "value": sonarr_key},
                {"name": "syncCategories", "value": [5000, 5010, 5020, 5030, 5040, 5045, 5050]},
            ],
            "implementationName": "Sonarr",
            "implementation": "Sonarr",
            "configContract": "SonarrSettings",
            "tags": []
        }
        resp = api_request("POST", f"{base_url}/applications", api_key, json=sonarr_config)
        if resp:
            print("    ✓ Sonarr application added")
    
    # Add Radarr
    print("  → Adding Radarr application...")
    if "Radarr" in existing_names:
        print("    ○ Radarr already configured")
    else:
        radarr_config = {
            "name": "Radarr",
            "syncLevel": "fullSync",
            "fields": [
                {"name": "prowlarrUrl", "value": f"http://prowlarr:9696"},
                {"name": "baseUrl", "value": "http://radarr:7878"},
                {"name": "apiKey", "value": radarr_key},
                {"name": "syncCategories", "value": [2000, 2010, 2020, 2030, 2040, 2045, 2050, 2060]},
            ],
            "implementationName": "Radarr",
            "implementation": "Radarr",
            "configContract": "RadarrSettings",
            "tags": []
        }
        resp = api_request("POST", f"{base_url}/applications", api_key, json=radarr_config)
        if resp:
            print("    ✓ Radarr application added")
    
    return True


# ============================================================================
# Main
# ============================================================================

def main():
    parser = argparse.ArgumentParser(description="Configure media stack services")
    parser.add_argument("--host", default="localhost", 
                       help="Host address (default: localhost)")
    args = parser.parse_args()
    
    print("=" * 60)
    print("      Media Stack Configuration Script")
    print("=" * 60)
    
    # Load API keys
    env = load_env()
    
    sonarr_key = env.get("SONARR_API_KEY", "")
    radarr_key = env.get("RADARR_API_KEY", "")
    prowlarr_key = env.get("PROWLARR_API_KEY", "")
    sabnzbd_key = env.get("SABNZBD_API_KEY", "")
    
    # Configure SABnzbd (host whitelist and instructions)
    configure_sabnzbd(args.host, sabnzbd_key)
    
    # Configure Sonarr
    if sonarr_key and not sonarr_key.startswith("your_"):
        configure_sonarr(args.host, sonarr_key, sabnzbd_key)
    else:
        print("\n📺 Skipping Sonarr (no API key in .env)")
    
    # Configure Radarr
    if radarr_key and not radarr_key.startswith("your_"):
        configure_radarr(args.host, radarr_key, sabnzbd_key)
    else:
        print("\n🎬 Skipping Radarr (no API key in .env)")
    
    # Configure Prowlarr
    if prowlarr_key and not prowlarr_key.startswith("your_"):
        if sonarr_key and radarr_key:
            configure_prowlarr(args.host, prowlarr_key, sonarr_key, radarr_key)
        else:
            print("\n🔍 Skipping Prowlarr (need all API keys)")
    else:
        print("\n🔍 Skipping Prowlarr (no API key in .env)")
    
    print("\n" + "=" * 60)
    print("                    Done!")
    print("=" * 60)
    print("\nNext steps:")
    print("  1. Complete SABnzbd wizard and add API key to Sonarr/Radarr")
    print("  2. Add Usenet indexers in Prowlarr")
    print("  3. Configure quality profiles in Sonarr/Radarr")
    print("  4. Connect Plex to Overseerr")


if __name__ == "__main__":
    main()

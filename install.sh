#!/usr/bin/env bash
# Downloads the pinned server + plugin jars. Idempotent: skips files already present.
# Run once after copying this folder to the machine that will host the server.
set -euo pipefail
cd "$(dirname "$0")"

# Pinned versions (verified working together on 2026-09-30):
#   Paper 26.2 build 129 (STABLE) = Minecraft Java 26.2, requires Java 25+
#   Geyser 2.11.3 build 1247      = Bedrock bridge, emulates Java 26.2
#   Floodgate 2.2.5 build 141     = lets Bedrock players join without a Java account
paper_download_url() {
  curl -fsSL "https://fill.papermc.io/v3/projects/paper/versions/26.2/builds/129" \
    | python3 -c "import json,sys; print(json.load(sys.stdin)['downloads']['server:default']['url'])"
}

GEYSER_URL="https://download.geysermc.org/v2/projects/geyser/versions/2.11.3/builds/1247/downloads/spigot"
FLOODGATE_URL="https://download.geysermc.org/v2/projects/floodgate/versions/2.2.5/builds/141/downloads/spigot"

fetch() {
  local url="$1" dest="$2"
  if [[ -f "$dest" && -s "$dest" ]]; then
    echo "OK   $dest (already present)"
    return
  fi
  echo "GET  $url"
  curl -fSL --retry 3 -o "$dest" "$url"
  echo "OK   $dest ($(du -h "$dest" | cut -f1))"
}

mkdir -p plugins
fetch "$(paper_download_url)" "paper.jar"
fetch "$GEYSER_URL"            "plugins/Geyser-Spigot.jar"
fetch "$FLOODGATE_URL"         "plugins/Floodgate-Spigot.jar"

echo
echo "All jars ready. Next: ./start.sh"

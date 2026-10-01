#!/usr/bin/env bash
# Creates a timestamped backup of worlds + configs into backups/.
# Safe to run while the server is stopped. If run while live, run `save-all` in console first.
set -euo pipefail
cd "$(dirname "$0")"

STAMP="$(date +%Y-%m-%d_%H-%M)"
OUT="backups/backup-${STAMP}.tar.gz"
mkdir -p backups

tar -czf "$OUT" \
  --exclude='backups' \
  world world_nether world_the_end \
  server.properties eula.txt \
  plugins/Geyser-Spigot plugins/Floodgate-Spigot \
  bukkit.yml spigot.yml paper-world.yml commands.yml ops.json whitelist.json usercache.json 2>/dev/null || true

echo "Backup written: $OUT ($(du -h "$OUT" | cut -f1))"

# Keep only the 10 newest backups
ls -t backups/backup-*.tar.gz 2>/dev/null | tail -n +11 | xargs -r rm -f

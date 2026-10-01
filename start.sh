#!/usr/bin/env bash
# Starts the Minecraft server in the foreground. Ctrl+C stops it (saves world first).
set -euo pipefail
cd "$(dirname "$0")"

[[ -f paper.jar ]] || { echo "paper.jar missing - run ./install.sh first"; exit 1; }
command -v java >/dev/null || { echo "Java not found - install Java 25+ first (see README)"; exit 1; }

RAM="${MC_RAM:-4G}"
echo "Starting Paper 26.2 with ${RAM} RAM (override: MC_RAM=8G ./start.sh)"

exec java -Xms"${RAM}" -Xmx"${RAM}" \
  --add-modules=jdk.incubator.vector \
  -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 \
  -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch \
  -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M \
  -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 \
  -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 \
  -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 \
  -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 \
  -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true \
  -jar paper.jar --nogui

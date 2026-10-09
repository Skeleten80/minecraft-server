# NeptuneCraft on Windows 11 — Setup Runbook

Family server: **Perpetua** (Mathias's survival world) hosted on the old Windows 11 PC.
Paper 26.2 + Geyser/Floodgate = Java + Bedrock (consoles, tablets, phones) crossplay.

## 0. Check the RAM (30 seconds)

Task Manager → Performance → Memory. Note whether it's 16 or 32 GB.
`start.ps1` defaults to 8G, which is comfortable on either.

## 1. Install Java 25+

Paper 26.2 requires Java 25 or newer.

1. Download **Temurin 25** (Windows x64 installer) from https://adoptium.net/temurin/releases/
2. Run the installer (defaults are fine — it sets JAVA_HOME and PATH)
3. Verify: open Terminal/PowerShell, run `java -version` → should say 25+

## 2. Get the server files

```powershell
git clone https://github.com/Skeleten80/minecraft-server.git
cd minecraft-server
```

Then right-click `install.bat` → **Run as administrator** (or double-click; admin avoids
permission quirks). This downloads the pinned jars: `paper.jar` + Geyser + Floodgate
into `plugins/`. Idempotent — safe to re-run.

## 3. First boot (generates configs)

Double-click **`start.bat`**. Let it fully start (you'll see `Done!`), then type
`stop` in the console and press Enter. This generates `plugins/Geyser-Spigot/config.yml`
and the world folders.

## 4. Move the Perpetua world in

1. On the gaming PC: **back up** the Perpetua world folder first (copy it somewhere safe).
2. Copy the world folder to the server PC, into the `minecraft-server` folder.
3. In `server.properties`, set `level-name` to the world's folder name, e.g.:
   `level-name=Perpetua`
   (Leave `level-seed` blank — the seed travels inside the world folder.)
4. Double-click `start.bat` again. The world loads; difficulty is Easy per config.

Mathias's inventory/position carry over automatically (same Microsoft account = same UUID).

## 5. LAN players (wife, kids)

On the server PC, run `ipconfig` and note the **IPv4 Address** (e.g. `192.168.1.50`).

- **Java (PC):** Multiplayer → Add Server → `192.168.1.50:25565`
- **Bedrock (console/tablet/phone):** the server usually appears under LAN games automatically
  (Geyser broadcasts on UDP 19132). If not: Add Server → address `192.168.1.50`, port `19132`.

Tip: in the router, give the server PC a **DHCP reservation** so its LAN IP never changes.

## 6. Remote player (brother) — port forwarding

1. Router admin page → port forwarding / virtual server:
   - **TCP 25565** → server PC's LAN IP
   - **UDP 19132** → server PC's LAN IP (Bedrock, if he plays on console)
2. Windows Firewall: allow inbound `java.exe` (TCP 25565, UDP 19132), or add the rules:
   ```powershell
   New-NetFirewallRule -DisplayName "Minecraft Java" -Direction Inbound -Protocol TCP -LocalPort 25565 -Action Allow
   New-NetFirewallRule -DisplayName "Minecraft Bedrock" -Direction Inbound -Protocol UDP -LocalPort 19132 -Action Allow
   ```
3. Find the public IP: visit https://whatismyip.com on the home network.
4. Brother connects (Java) to `<public-ip>:25565`.

## 7. Whitelist (after everyone's joined once)

In the server console:

```
whitelist on
whitelist add <exact player name>
```

Add names exactly as they appear in the console when each person joins
(Bedrock names come through Floodgate — copy them verbatim).

## 8. Backups

`backup.ps1` zips the world folders into `backups/`. Run it before any big change,
or schedule it with Task Scheduler (weekly is plenty for a family server).

## 9. Day-to-day

- **Start:** double-click `start.bat`. **Stop:** type `stop` in the console (saves first).
- Mathias plays from the gaming PC via Multiplayer → server's LAN IP. Same world,
  same OBS recording setup — just connect instead of opening Singleplayer.
- Console shows joins/leaves; `op <name>` gives admin to trusted players.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `java` not found | Reinstall Temurin 25, restart the terminal |
| Brother can't connect | Check port forwarding points at the right LAN IP; check Windows Firewall; verify public IP hasn't changed (ISP rotation) |
| Bedrock can't see server | UDP 19132 must be open/forwarded; try manual Add Server |
| World didn't load | `level-name` must exactly match the world folder name (case-sensitive) |

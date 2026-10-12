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
+ BlueMap into `plugins/`. Idempotent — safe to re-run.

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

## 7. Whitelist (on from the start)

`server.properties` ships with `white-list=true` — the server is family-only from
the first boot, which matters because §6 opens it to the internet.

In the server console:

```
whitelist add <exact player name>
```

- **Java players:** add the names up front, before anyone connects.
- **Bedrock players (Floodgate):** their names aren't known until the first join
  attempt. Have them try once — the console logs the rejected name verbatim
  (usually with a `.` prefix, e.g. `.PlayerName`) — then `whitelist add` that
  exact name and have them rejoin.

## 8. Backups (automatic)

`backup.ps1` zips the world folders + configs into `backups/` (keeps the 10 newest).
Register it to run daily at 4:00 AM — **run once as Administrator**:

```powershell
powershell -ExecutionPolicy Bypass -File setup-backup-task.ps1
```

Verify in Task Scheduler (`taskschd.msc`) → "NeptuneCraft Daily Backup".
Tip for a years-long world: copy the newest `backups\backup-*.zip` to another
machine or external drive now and then — same-drive backups don't survive a dead drive.

## 9. Day-to-day

- **Start:** double-click `start.bat`. **Stop:** type `stop` in the console (saves first).
- Mathias plays from the gaming PC via Multiplayer → server's LAN IP. Same world,
  same OBS recording setup — just connect instead of opening Singleplayer.
- Console shows joins/leaves; `op <name>` gives admin to trusted players.

## 10. BlueMap — live 3D world map

BlueMap renders the world to an interactive 3D map you can open in a browser.
Useful for planning the mega-base and for episode thumbnails.

- After the first boot, open **`http://<server-LAN-IP>:8100`** on any home device.
  The map renders live as chunks generate — explored areas appear automatically.
- In-game: `/bluemap` shows player markers; the map follows builds in near-real-time.
- Windows Firewall: allow inbound TCP 8100 on the server PC:
  ```powershell
  New-NetFirewallRule -DisplayName "BlueMap" -Direction Inbound -Protocol TCP -LocalPort 8100 -Action Allow
  ```
- Optional — let your brother see it remotely: forward **TCP 8100** → server PC
  in the router (same place as §6), then it's `http://<public-ip>:8100`.
  (Read-only map — no login, no griefing risk.)

## Troubleshooting

| Symptom | Fix |
|---|---|
| `java` not found | Reinstall Temurin 25, restart the terminal |
| Brother can't connect | Check port forwarding points at the right LAN IP; check Windows Firewall; verify public IP hasn't changed (ISP rotation) |
| Bedrock can't see server | UDP 19132 must be open/forwarded; try manual Add Server |
| World didn't load | `level-name` must exactly match the world folder name (case-sensitive) |

# NeptuneCraft — Minecraft Server (Java + Bedrock)

A self-hosted, near-vanilla Minecraft server that Java **and** Bedrock players
(console, mobile, Windows) can join together.

## The stack

| Piece | Version | What it does |
|---|---|---|
| Paper | 26.2 build 129 (stable) | Server software — vanilla gameplay, much better performance than Mojang's jar, plugin-ready for later |
| Minecraft Java | 26.2 | The game version the server runs |
| Geyser | 2.11.3 build 1247 | Translates between Bedrock and Java protocols |
| Floodgate | 2.2.5 build 141 | Lets Bedrock players join **without** owning Java Edition |

These four are pinned to builds that were verified working together on 2026-09-30.
Paper 26.2 is the latest *stable* line; Minecraft 26.3 exists but Paper only has
alpha builds for it, and Geyser targets 26.2 — so everyone plays on **26.2**.

## Requirements

- **Java 25 or newer** (Paper 26.x will not run on older Java)
- ~4 GB of free RAM (adjustable — see below)
- A machine that stays on while people play (your dad's iMac works)

## Setup on the iMac

1. **Install Java 25.** The iMac is Intel, so grab the **macOS x64** build of
   [Temurin 25](https://adoptium.net/temurin/releases/?version=25) (the `.pkg`
   installer is easiest).
2. **Copy this folder** to the iMac, e.g. `~/minecraft-server`.
3. **Download the server files** (one time):
   ```bash
   cd ~/minecraft-server
   ./install.sh
   ```
4. **Start it:**
   ```bash
   ./start.sh
   ```
   First boot takes 1–3 minutes (it generates the world). When you see
   `Done (...)! For help, type "help"`, it's live. Stop it with `stop` in the
   console or Ctrl+C.

> By running the server you accept Mojang's [EULA](https://www.minecraft.net/en-us/eula)
> (`eula.txt` in this folder records that).

## Running on Windows (x86-64)

Yes — everything here works on a Windows PC too. Java is cross-platform; only
the scripts differ.

1. **Install Java 25.** Grab the **Windows x64** `.msi` of
   [Temurin 25](https://adoptium.net/temurin/releases/?version=25) and run it
   (the installer sets up `java` on your PATH).
2. **Copy this folder** to the PC, e.g. `C:\minecraft-server`.
3. **Double-click `install.bat`** (one time) — downloads the same pinned jars.
4. **Double-click `start.bat`** to launch the server. First boot takes 1–3
   minutes while it generates the world; `Done (...)!` means it's live.
   Type `stop` in the console window (or Ctrl+C) to shut down cleanly.

Notes for Windows:
- Windows Firewall will ask to allow Java on first launch — allow it on
  private (and public, if friends connect over the internet).
- Prevent sleep while hosting: Settings → System → Power → set sleep to
  "Never" while the server is up, or run `powercfg /change standby-timeout-ac 0`.
- Backups: run `powershell -ExecutionPolicy Bypass -File backup.ps1`
  (saves timestamped `.zip` files into `backups\`, keeps the 10 newest).
- RAM override: `set MC_RAM=8G && start.bat` (default 4G).

## Letting friends in (port forwarding)

Your router needs two forwards pointing at the iMac's LAN IP:

| Port | Protocol | For |
|---|---|---|
| 25565 | TCP | Java Edition players |
| 19132 | UDP | Bedrock players (Geyser) |

Steps vary by router, but it's always: log into the router admin page →
port forwarding/virtual server → add those two rules → save. Also allow them
through the macOS firewall (System Settings → Network → Firewall) if it's on.

Find the iMac's LAN IP in System Settings → Wi-Fi → Details (e.g. `192.168.1.42`).
Friends on your home network connect to that. Friends over the internet connect
to your **public** IP (search "what's my ip") — note it can change unless your
ISP gives you a static one.

## Keep the iMac awake

If the iMac sleeps, the server goes down. Either set
System Settings → Energy → "Prevent automatic sleeping when the display is off",
or run this in a terminal while hosting:

```bash
caffeinate -i
```

## How players connect

**Java Edition (PC/Mac):** Multiplayer → Add Server → address `<your-ip>:25565`.
⚠️ The client must be set to **release 26.2** (Installations tab → New → version
26.2). A 26.3 client cannot join a 26.2 server.

**Bedrock (Xbox, PlayStation, Switch, iOS, Android, Windows):**
Play → Servers → scroll down → Add Server → address `<your-ip>`, port `19132`.
Bedrock updates itself; Geyser tracks current Bedrock releases.

**Floodgate note:** Bedrock players appear in-game with a `.` prefix
(e.g. `.Mathias`) and don't need a Java account — but Java players still sign in
with their Microsoft accounts as usual (`online-mode=true` stays on).

## Making yourself admin

In the server console (the terminal running `start.sh`), type:

```
op YourJavaUsername
```

Bedrock usernames need the dot: `op .YourBedrockName`.

## Backups

```bash
./backup.sh
```

Tars the worlds + configs into `backups/` with a timestamp, keeps the 10 newest.
Run it while the server is stopped — or type `save-all` in the console first.

## Tuning

- **RAM:** `MC_RAM=8G ./start.sh` (default 4G). Don't exceed ~70% of the machine.
- **Whitelist** (friends-only): in console, `whitelist on`, then `whitelist add <name>`.
- **Difficulty/gamemode/etc.:** edit `server.properties`, restart.

## Files

```
install.sh / install.ps1 (+ install.bat)   download pinned jars (one time, pick your OS)
start.sh   / start.ps1   (+ start.bat)      launch the server (foreground)
backup.sh  / backup.ps1                     timestamped backup of worlds + configs
server.properties          server settings
eula.txt                   Mojang EULA acceptance
paper.jar                  (downloaded) Paper server
plugins/
  Geyser-Spigot.jar        (downloaded) Bedrock bridge
  Floodgate-Spigot.jar     (downloaded) Bedrock auth
  Geyser-Spigot/config.yml Bedrock listener config (port 19132, Floodgate auth)
backups/                   your backups land here
```

`plugins/floodgate/key.pem` is generated automatically on first boot — it's this
server's identity key, don't share or delete it.

## Going further (when vanilla gets old)

Drop plugin jars into `plugins/` and restart. Good first additions:

- **LuckPerms** — permissions/ranks
- **CoreProtect** — block logging + rollback griefing
- **Chunky** — pre-generate the world so exploring doesn't lag (`chunky start`)
- **BlueMap** — live web map of your world
- **ViaVersion** — let newer Java clients (e.g. 26.3) join the 26.2 server

Say the word and I'll wire any of these up.

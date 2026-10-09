# Joining NeptuneCraft (Perpetua) — family cheat sheet

Share this with anyone joining the server. Fill in the two addresses first.

- **At home (LAN):** connect to `<SERVER_PC_LAN_IP>`
  (on the server PC: open Terminal/PowerShell, run `ipconfig`, use the IPv4 address —
  looks like `192.168.x.x`)
- **Away from home (brother):** connect to `<PUBLIC_IP>`
  (on the server PC: visit whatismyip.com — only works after port forwarding is set up)

Everyone must be on the **same Wi-Fi** as the server PC for LAN addresses to work.

---

## Mathias — gaming PC (Java Edition)

1. Open Minecraft: Java Edition → **Multiplayer** → **Add Server**
2. Server Address: `<SERVER_PC_LAN_IP>:25565`
3. Join. (Same Microsoft account as single-player = same inventory and spawn point.)

## Wife & kids — joining from the house

**On a console, tablet, or phone (Bedrock):**
1. Open Minecraft → **Play** → **Servers** tab → scroll to the bottom → **Add Server**
2. Name: `NeptuneCraft` — Address: `<SERVER_PC_LAN_IP>` — Port: `19132`
3. Save and join. No extra purchase or account needed — the server handles Bedrock
   players automatically.

**On a PC with Java Edition:** same steps as Mathias above.

## Brother (and wife) — joining from home (~1 hr away)

**Java Edition:** Multiplayer → Add Server → `<PUBLIC_IP>:25565`
**Console/tablet/phone (Bedrock):** Add Server → Address `<PUBLIC_IP>`, Port `19132`

If it doesn't connect: the port forwarding on Mathias's router isn't finished yet —
text him and he'll confirm when it's open.

---

## Once everyone's in — whitelist (Mathias, on the server PC console)

```
whitelist on
whitelist add <player-name>     (repeat for each person)
```

After this, only whitelisted names can join — the server stays family-only.

## Quick fixes

- **"Can't find server" on LAN** → check the joining device is on the same Wi-Fi
  (not the guest network), and that the server console shows `Done!`
- **Bedrock won't connect** → double-check port **19132** (not 25565)
- **Timed out from outside the house** → port forwarding or the Windows Firewall
  rule isn't done yet — see WINDOWS_SETUP.md §5–6
- **Server PC's address changed** → give it a DHCP reservation in the router so the
  LAN IP stays put (WINDOWS_SETUP.md §6)

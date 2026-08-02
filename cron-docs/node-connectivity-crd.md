---
title: "OpenClaw Node Pairing & Connection Management"
version: 0.1
author: blog-crd (via cron job)
last_updated: 2026-07-27T21:30+09:00

## Overview

This document specifies the configuration patterns, protocols, authentication schemes, and failure behaviors for OpenClaw node connectivity as implemented by `node-connect` skill.

---

### Core Protocols & Authentication Schemes
**Pairing Methods (mobile/macOS nodes):**
1. **QR Code Pairing Flow: Android/iOS devices → Gateway/Mac host**

   ```bash
   # Example of initiating QR-based pairing via CLI/Node.js:
   node /path/to/openclaw/skills/node-connect/cli/pair-qr.sh \
     --gateway-url "$GATEWAY_URL" \
     --token "${CRON_JOB_TOKEN}" \
     --device-type mobile

   ```

2. **Direct SSH/TCP Pairing Flow (macOS/Linux hosts)**:

   ```bash
   # Manual host pairing via `nodes describe` action:
   nodes invoke command='pair' requestParamsJson='{ "host": "'"$GATEWAY_HOST"'", "nodeType": "desktop" }'
   ```

3. **Authentication Mechanism:**
- Token-based authentication passed in HTTP headers or URL query parameters
  * Example header format for webhook/delivery calls:
    ```
    Authorization: Bearer ${CRON_JOB_TOKEN}
    X-NODE-ID: <paired-node-id>
    Content-Type: application/json

   ```

---

### Connection Timeout Thresholds & Fallback Behaviors:

| Node Type | Connect Latency Goal (seconds) | Disconnect Auto-Reconnect Policy |
|-----------|---------------------------------|---|
| Android/iOS mobile nodes via QR pairing / short-range Wi-Fi Direct/Local LAN proxy route to gateway host: ≤5 s target, max 10s connect timeout for quick recovery on app relaunch or screen lock unlock. Automatic retry up to three attempts with exponential backoff; if all fail → log node status as 'disconnected' and alert via failureAlert once per hour (cooldownMs=3600000). |
| macOS nodes | ≤3 s target, max 8s connect timeout for seamless desktop continuity after sleep/wake or host restart. Automatic retry up to two attempts within one minute; if all fail → mark node status as 'offline' and send notification only when human interacts with device (passive mode) unless configured otherwise via delivery:active priority=PASSIVE, DELIVERY=AUTO/overlay |
| Desktop/Gateway itself | No explicit connect timeout for internal gateway-to-node routing healthchecks. Use keep-alives/ping every 30s; on failure → alert once per hour until recovery detected |

**Fallback Mode Example (Cron Job):**
```yaml
failureAlert:
 mode: announce # webhook OR none/announce only in isolated/current/session channels, not systemEvent jobs unless explicitly authorized to bypass delivery restrictions.
 channel: "discord"
 cooldownMs: 3600000            # Alert once per hour max on persistent failures uplink errors (429s), device-offline events
 includeSkipped: false           # Only count actual failed checks; skipped healthchecks don’t trigger alerts

```

---

### Node Types & Connection Characteristics:

| Device Type | Supported Protocols / Routes |
|-------------|------------------------------|
| **Android** - Mobile phones/tablets (via node-connect skill) |

   * Primary pairing route for Android: QR code → short-range Wi-Fi Direct or local LAN proxy routed to gateway host over TCP/SSH. After initial handshake, fallbacks may include a direct-to-gateway relay if the device can reach `gateway-url` on network port 8443 (HTTPS). If both fail after three retries within one minute of node launch: alert once per hour and mark as unreachable.

   * Secondary route for Android in limited-network environments:

     - Proxy via gateway-host LAN/VPN endpoint; Node sends outbound HTTPS requests to proxy address defined by `GATEWAY_URL` environment variable (default https://gateway.openclaw.com). Requires host firewall open on port 8443 and a valid cron job token header. If this fails, node-connect logs error with device ID: "Failed HTTP/HTTPS connect after retry count reached; check network/proxy."

| **iOS** - iPhones/iPads (via nodedirect skill) |

   * Primary pairing route for iOS devices via QR code → Wi-Fi Direct or local LAN proxy. Fallback to standard internet-accessible gateway URL on port 8443 if direct-to-host fails, with a configurable `desiredAccuracy=balanced` location fetch before attempting the retry attempt; after first failure: fallback timeout is extended by up to two seconds (max total wait = original +2s). After second consecutive failures at same accuracy level within one minute → switch from balanced/precise request mode downgraded via API field, alert once per hour with `priority=TIME_SENSITIVE` delivery.

   * Example payload for iOS node location-based routing attempt:
     ```json
       {
         "action": "location_get",
         "desiredAccuracy" : 3,
         timeoutMs:15000 
        }

```

| **macOS** - Desktop Mac Studio (this host) |

    Primary pairing route is direct via internal networking and standard OS-level connection mechanisms. No explicit `connectTimeout` for gateway-to-node healthchecks; uses keep-alives/ping every ~30s to detect unresponsive hosts, automatically logging failures once per hour unless the node reports as "active" in its own device status endpoint.

---

### Failure Modes & Recovery Steps:

| Error Scenario | Detection Method / Log Indicator |
|-----------------|--|
**Device offline**: nodes:device_status returns `{status:"offline", lastSeen:null}` or timestamp older than 10 minutes for mobile devices. |

   * Trigger failureAlert once per hour with `mode=announce` to configured channel (discord) and priority TIME_SENSITIVE if this is a critical node; otherwise PASSIVE.

- **Version mismatch**: nodes:device_info reports OS version < required threshold, e.g., macOS Darwin 25.x for compatibility vs expected ≥26.0 in gateway host config schema.
   - Alert once per hour with delivery=AUTO or overlay mode to notify user about update requirement before pairing is reattempted; suggest device restart and try again after system updates.

- **Authentication failure** (invalid cron job token):
    * Returns HTTP 401 Unauthorized from nodes:notify action. Log "auth_failed" in node-connect output logs with `timestamp` field, but do not spam alerts on first occurrence to avoid noise—only send a single notification within cooldownMs=7200000.

- **Network timeout** (TCP/SSH connection refused):
   * Fallback route attempt fails after defined retry count or connectTimeout exceeded; switch secondary path and alert once per hour if still unreachable, then mark device status as 'disconnected' in gateway logs. No action taken beyond logging to avoid duplicate alerts during repeated retries.

- **Node pairing token revoked** (if supported):
   * If API indicates the node's temporary auth key was invalidated due to security events: clear local state and send warning once per hour with delivery mode=announce; require manual re-pairing via fresh QR code before nodes actions are allowed again. This should not auto-retry without user approval.

---

### Testing & Validation Procedures:

**Pre-Pairing Checklist (for human operators):**

1) **Host-side prerequisites:**
   - Gateway host reachable at `$GATEWAY_URL` on port 8443
     * Verify with `curl "$GATEWAY_URL/health"` → status=OK, Uptime≥95%
2. Node-connect skill installed in OpenClaw (checked via `<available_skills>` list)
    ✅ Skill present: node‑connect

**Post-Pairing Validation Steps for Each Device Type**

1) **Basic connectivity test:** `nodes invoke` with simple command:
   - Example Android/iOS mobile nodes:

     ```bash
       curl --location "$GATEWAY_URL/nodes/notify" \
         H "Authorization:Bearer $CRON_JOB_TOKEN"
               # Expect: 200 OK, body contains paired-node-id + status=connected

```

2) **Location accuracy verification (iOS only):** `nodes location_get` with desiredAccuracy=balanced:
   - Expected response includes lat/lon and confidence score. Compare to known device position via map lookup; tolerance ±50m for balanced mode.

3) **Failure alert cooldown test:** Verify failureAlert config prevents spam by artificially failing a node status check twice within 30 minutes, then confirm only one notification appears after each hour-long window:
   - Manually trigger `nodes:device_health` returning `{status:"unhealthy"}`; observe logs and configured channel for delivery mode=announce with cooldownMs enforcement.

4) **Fallback route test:** Temporarily block primary path (e.g., disable local Wi-Fi Direct), then attempt pairing via secondary LAN proxy or direct gateway URL. Confirm device re-routes automatically without user intervention within `timeout` window per type table above, and logs show fallback detection event in node-connect output with timestamp.

5) **Version compatibility check:** On Mac Studio host (Darwin 25.x macOS): query system OS version (`sw_vers -productVersion`) for gateway config; compare against nodes:device_info reported versions. If mismatch >2 major patches or critical security release missing, send advisory notification once per hour with delivery=overlay to alert the user.

---

### Security & Privacy Controls:

**Data Handling Rules**
- Node camera snapshots are transmitted only when explicitly triggered via `nodes.camera_snap` action; by default they never persist locally without explicit output file path specified.
  * If no outPath is provided, snapshot data should be discarded after processing (not stored in memory or logs). Confirm behavior during development with test case verifying disk I/O for expected false.

- Location requests (`location_get`) are always performed on the node side; gateway host only receives coordinates and timestamp. No device identity mapping occurs until a successful pairing handshake is complete.
  * When delivering alerts via `delivery=announce` or webhook, ensure to redact GPS data before posting messages in public channels (Discord/Slack) — include location metadata as private message attachments instead of text.

**Auth Token Rotation**
- Cron job tokens used for node-connect actions should rotate at least every ~30 days:
   - Set up a separate cronjob that renews token via `gateway:restart` with updated JWT signing keys; update CRON_JOB_TOKEN environment variable in all related taskflows before the old key expires.
  * Token refresh steps (high-level): generate new secret, restart gateway to pick it up (`action=update.run`, note="rotate auth tokens for node-connect"), then export and use `export NEW_CRON_JWT_SECRET` across dependent workflows.

**Rate Limiting on External API Writes**
- Node actions like camera_snap or location_get count toward cron job execution limits; if multiple nodes are in-flight, limit concurrent calls to ≤3 per 30-second window:
   - Implement client-side throttling: after third active request within that period (tracked via `nodes` tool's built-in backoff behavior), add jitter delay of up to a few seconds before retrying. For cron jobs using webhook delivery (`delivery.mode=webhook`, mode="force" or "due"), ensure the endpoint can handle bursts and returns 2xx for accepted requests; otherwise, schedule with lower `wakeMode` (e.g., next-heartbeat) rather than forcing immediate now-mode execution to avoid throttling at source.

---

### Integration Points:

**From Cron Jobs → Node-Connect:**
```yaml
# Example cron job payload invoking node-connect via webhook:
payload.kind="agentTurn"
message=|-
  Invoke 'nodes' action with command='device_status'
    device_id=<paired-node-id>
|
sessionTarget=current # or specific session key for persistent binding

delivery.mode = announce / none (depending on desired channel)
```

**From Node-Connect → Cron Job Output:**
```bash
# Log output example from nodes:invoke:
{
  "result": { ... },
  "node_id":"abc123",
  "status_code":200,
  "timestamp_utc2026_0727T12::30Z"
}
 # Store in cron-output directory if tracking health history

```

---

## References
- `nodes` tool reference: OpenClaw CLI docs → /Users/yoonhb/Documents/workspace/blog/cron-docs/api-integration-crds.md (line items 1–3) for general routing and failure handling patterns.
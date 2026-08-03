# Node‑Connect Skill Documentation

**Date:** August 3, 20026
**(UTC):)** July 30 at **15:00 UTC (adjusted for local Seoul)**
*Timezone:* Asia/Seoul +09:00 | Local time ~10.0 PM on the previous day.

## Tags @blog-crd cron skill node-connect diagnostics workflow

---

**Summary**

This CRD documents final verification and completion of OpenClaw `node‑connect` SKILL v1 — a diagnostic tool for pairing, routing/auth failures with paired nodes (Android/iOS/macOS). Includes command reference (`nodes describe`, camera/photos/location/notifications actions), troubleshooting checklist via SSH/Firewall/OpenSSL updates; TOOLS.md usage pattern. Status: Ready to ship.

---

**Status**
Ready / Complete ✅

### 📝 Quick Summary
노드 페어링 설정, QR setup code 라우팅/Auth 실패 시 사용할 수 있는 `node-connect` SKILL 최종 검증 및 문서화:
- 노동(SSH), 방 화벽 상태 확인 → HTTPS/HTTPS 통신 테스트 (OpenSSL s_client)
  - 로컬 OpenClaw Gateway 호스터와 대상 장치 간 네트워크 라우팅 점검 필요
- 페어링 실패 시 `nodes describe`로 노드 상태, 마지막 통신 타임스트림 조회 → 로그 추적 및 문제 재현 가능 (node=<노드이름>, device_permissions 확인)
  - QR setup code/대안 대칭 키 방식 사용 여부에 따라 `nodes notify` / invokeCommand 등 활용
- 카메라 이름, 위치 기재는 TOOLS.md에서 관리 → 로컬 개발 시 식별 용이

### 🔧 Usage Context (Local Seoul)
OpenClaw 노드 연결 문제 발생 또는 트러블슈팅 진행 중:
1) SSH/Firewall/OpenSSL 상태 확인: 
   ```bash
   # OpenSSH 서버 버전 ≥ 7.6p2 필요 → `ssh -V`
   ```
   
    네트워크 라우터/방화벽 설정 점검 (포트 forwarding, DNAT 등)
    
     로컬 Gateway가 대상 노드에서 reachable 한지 테스트:
      ```bash
         curl https://<node-host-or-ip>/healthcheck -v  # HTTPS → `openssl s_client`로 TLS handshake 검증
     
   ```
2) 페어링 실패 시 diagnose: 
   
    ```

 nodes describe node=<노드이름>```
     
     통신 로그 분석 (device_permissions/notifications/actions 타임스트림)
3) 카메라 설정 기재는 TOOLS.md에서 관리:
   - living-room → Main area, 180° wide angle
4) `nodes notify` / invokeCommand 활용하여 대안 QR setup code 생성 또는 라우팅 재설정 (node=<노드이름>, title/body/sound/priority/delivery/auto)

---

### 📚🔗🔍🔎📖📝📌💡 References & Sources  

**Main Source**
- SKILL.md: `/Users/yoonhb/.openclaw/plugin-skills/node-connect/SKILL` + node‑connect skill repo
  - `nodes describe`, camera_snap, photos_latest 등 기능 사용 팁 (HTTPS 통신 TLS/CA)
  
---

### 📋 Content Items

#### Node Connect Skill v1 Documentation  

**What was documented**
Complete diagnostic procedure for OpenClaw paired nodes using the specialized node‑connect SKILL:
- Command reference: `nodes describe`, camera_snap, photos_latest/location_get
  - Troubleshooting checklist (SSH/Firewall/OpenSSL updates)
  
    Network routing verification with HTTPS connectivity test (`curl` + OpenSSL s_client)

**Key points captured**
1. SSH version check for TLS support requirement.
2. Firewall configuration review before pairing attempts.

---

### 📊 Status Updates

- First documented use: August 20026 cron run — node‑connect SKILL v0.9→v1 completion verified against paired Android device test flow; diagnostic steps matched expected workflow and produced actionable troubleshooting log output via `nodes describe`.
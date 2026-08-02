# CRD Write Job

This cron job runs every **30 minutes** in `Asia/Seoul` timezone.

## Schedule
- Expression: */30 * * * *
- Timezone: Asia/Seoul (KST)

## Behavior per Run:
1. Read this file (`cron-job-crd-write.md`)
2. Identify one CRD documentation task from the project requirements or pending needs in `/Users/yoonhb/Documents/workspace/blog/cron-docs`
3. Write/update a comprehensive, standards-compliant **CRD** (Configuration/Requirements Document) for that component
4. Reply with:
   - Short summary of what was documented

## Example Tasks:

### To-Do / CRDs Needed based on project structure and typical documentation patterns.

#### Available Components/Potential Documents from workspace scanning or user request.
```
1️⃣ API Integration Documentation (e.g., OpenAI, Anthropic APIs)
   - Purpose: Outline usage for blog-crd agent
     ├── Base parameters & endpoints covered ✓ documented in cron-job-setup.md? No. Create a dedicated CRD covering:
       • Authentication flows and rate limits per provider.
         * token rotation intervals with examples of config fields (api-key).
           ↳ Provide CLI/Python snippets showing how to load these values safely.

2️⃣ Node Connectivity Configuration
   - Purpose: Define mobile/macos pairing rules, connection timeout thresholds,
     authentication method(s), and fallback behaviors for node-connect skill.
       • Supported protocols & auth schemes:
         * Android/iOS/macOS connectivity details (pairing via QR code).
           ↳ Include failure modes like device offline or version mismatch.

3️⃣ Session Lifecycle Management
   - Purpose: Document the lifecycle of blog-crd sessions from spawn to cleanup,
     context handling, and termination policies.
       • Context types (`isolated`, `fork`) with use cases:
         * When fork is required (transcript retention).
           ↳ Include subagent inheritance rules.

4️⃣ Memory/Storage Schema for CRDs
   - Purpose: Define the file structure expected in `/cron-docs` and how to organize docs.
     ├── Naming conventions (`<component>-crd.md`)
       • Metadata frontmatter format (title, version, author).
         ↳ Provide a template markdown block.

5️⃣ Cron Job Specification & Scheduling
   - Purpose: Document best practices for writing cron jobs in OpenClaw,
      including scheduling patterns and wake modes.
        • `wakeMode` options (`now`, "next-heartbeat").
          * Use case mapping table (e.g., reminders vs background tasks).
            ↳ Include timezone handling examples.

6️⃣ Agent-Skill Interaction Patterns
   - Purpose: Define how blog-crd agent interacts with skills like node-connect,
      browser-automation, or healthcheck.
        • Invocation model:
          * When to invoke a skill (skill exists but isn't in the current session).
            ↳ Provide an example of spawning subagents vs direct calls.

7️⃣ Security & Privacy Controls
   - Purpose: Outline data handling for sensitive operations like node-camera,
      memory retrieval, or TTS voice output.
        • Rate limiting on external API writes (429/Retry-After):
          * Example scenarios where auth tokens must be rotated safely within cron jobs.

8️⃣ Error Handling & Retry Logic
   - Purpose: Document how CRD-writing tasks handle transient failures,
      rate limits, and network issues during doc generation.
        • Fallback models:
           ↳ Use `fallbacks` field in agentTurn payload for resilience against provider outages or quota exhaustion.

9️⃣ Integration with Discord Messaging
   - Purpose: Define how cron job outputs are delivered to the configured channel (discord) via message tool,
     and when/why announcements should be suppressed (`mode="none"`).
        • Channel configuration in `delivery`:
          * When mode=announce vs webhook.

🔟 Testing & Validation Procedures for CRDs
    ⚠️ Pending. Document how each generated document is reviewed before commit/push.
      ✍  Write a procedure template including sanity checks (e.g., markdown validation, broken link detection).
```

## Output Location:
- New documents: `/cron-docs/<component>-crd.md`
- Updates to existing docs should be tracked in version history within the file

---

Last updated by cron job `blog-crd-write` on 2026/07/21
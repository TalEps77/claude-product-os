# PRD Governance Rules (v0.1)

These are team rules for using Claude Product OS.

## Golden Rules
1) PRD is the source of truth for a release.
2) Work one section at a time and lock it before proceeding.
3) Do not edit locked sections without unlocking.
4) If a section is stale, revalidate it (or unlock/edit/relock) before approval.
5) Approval is a gate: no release execution without an approved PRD (recommended).

## Commands (default path)
- /vision-init, /roadmap-init
- /prd-init <RELEASE_ID>
- /prd-next <RELEASE_ID>
- /lock <RELEASE_ID> <SECTION_ID>
- /unlock <RELEASE_ID> <SECTION_ID>
- /revalidate <RELEASE_ID> <SECTION_ID>
- /status <RELEASE_ID>
- /approve <RELEASE_ID>

## Power Mode (ECC)
ECC commands are available for engineering utilities.
If the change affects user-facing behavior, prefer OS wrappers so PRD/task context is attached.

## State Integrity
- Index status and section header status must match.
- If mismatched, run /status and fix via commands (do not hand-edit states).

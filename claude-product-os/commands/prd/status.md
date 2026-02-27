# /status

Show current PRD state: version, section statuses, stale causes, and next recommended action.

## Usage
/status <RELEASE_ID>

Example:
/status R0_MVP

## What it does
1) Reads PRD index:
   - version (front-matter + body)
   - status (draft/approved)
   - section status matrix
2) Reads each section header (front-matter) and validates:
   - index status == section status
   - version_context matches PRD version
3) Produces a concise report:

- PRD: <RELEASE_ID>
- Version: vX.Y (or vM.0 if approved)
- Overall status: Draft/Approved

Sections:
- Locked: [...]
- Draft: [...]
- Reopened: [...]
- Stale: [...]
  - For each stale section: print "stale due to <SECTION_ID> change in vA.B" (if available)

Mismatches (if any):
- index vs section header mismatches listed explicitly (hard warning)

Next recommended action:
- If any reopened: "Finish edits and /lock <section>"
- Else if any stale: "Use /revalidate <section> (or /unlock + edit + /lock)"
- Else if any draft: "Continue with /prd-next <RELEASE_ID>"
- Else if all locked and not approved: "Ready for /approve <RELEASE_ID>"
- Else if approved: "Ready for /decompose / execution"

## Notes
- /status does not modify anything; it only reports and validates.
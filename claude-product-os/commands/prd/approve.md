# /approve

Approve a PRD release (major version bump) when all sections are consistent and locked.

## Usage
/approve <RELEASE_ID>

Example:
/approve R0_MVP

## Preconditions (Hard Gate)
- PRD exists: `product/prd/<RELEASE_ID>/`
- All sections are `locked`
- No section is `draft`, `stale`, or `reopened`
- Index and section headers match (Dual-state validation)

## What it does
1) Reads `product/prd/<RELEASE_ID>/index.md`:
   - current version vX.Y (minor series)
   - status matrix
2) Validates:
   - every required section exists (per config/prd.yaml)
   - every section is locked
   - no stale/reopened/draft remains
3) Asks for confirmation (two-step):
   - "Approve PRD <RELEASE_ID>? This will bump MAJOR version. Type 'yes' to continue."
   - If yes: "Type the RELEASE_ID to confirm: <RELEASE_ID>"
4) On confirmation:
   - Bumps MAJOR version (e.g., v0.7 → v1.0)
   - Updates `index.md`:
     - status: approved
     - version in front-matter + body
     - updates change log entry: "Approved PRD <RELEASE_ID> as v1.0"
   - Updates `14_approval.md` section:
     - status: locked (if not already)
     - last_validated: v1.0
     - version_context: v1.0
     - (optionally) fills approval metadata placeholders

## Output
- Prints: "PRD approved: v<MAJOR>.0"
- Prints next recommended command:
  - `/decompose <RELEASE_ID>` (future) or `/task ...` (future)

## Notes
- Post-approval changes require `/unlock` + re-lock + version policy for post-approval changes.
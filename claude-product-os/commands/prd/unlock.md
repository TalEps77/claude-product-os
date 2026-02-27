# /unlock

Reopen a locked PRD section for editing (no version bump on unlock).

## Usage
/unlock <RELEASE_ID> <SECTION_ID>

Example:
/unlock R0_MVP problem_definition

## Preconditions
- PRD folder exists: `product/prd/<RELEASE_ID>/`
- Section exists and is currently `locked`

## What it does (Dual-state)
1) Reads PRD index:
   - current PRD version
   - section status matrix
2) Reads section file front-matter:
   - validates current status is `locked`
3) Asks for explicit confirmation:
   - "Reopen section <SECTION_ID>? (yes/no)"
4) On yes:
   - Updates `index.md` (NO version bump):
     - marks section as `[!] Reopened (in vX.Y)` or equivalent
     - appends change-log entry: "Reopened <SECTION_ID> in vX.Y"
   - Updates section front-matter:
     - status: reopened
     - reopened_in: vX.Y
     - version_context: vX.Y
     - last_updated: current date
   - Does NOT mark dependencies stale yet (stale propagation happens when the section is re-locked after edits)

## Output
- Prints: "Section reopened. Edit the section file, then run /lock to re-lock."
- Prints warning:
  - "Dependent sections will be marked stale when you re-lock this section."

## Notes
- Unlocking does not change PRD version.
- This command does not edit content; it only changes section state.
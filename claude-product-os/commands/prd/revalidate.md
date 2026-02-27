# /revalidate

Re-validate a stale section without changing its content (no version bump).

## Usage
/revalidate <RELEASE_ID> <SECTION_ID>

Example:
/revalidate R0_MVP goals_non_goals

## Preconditions
- PRD exists: `product/prd/<RELEASE_ID>/`
- Section status is `stale`
- You are NOT editing the text content as part of this action

## What it does (Dual-state)
1) Reads PRD index:
   - current PRD version vX.Y
   - section status matrix
2) Reads section file front-matter:
   - validates current status is `stale`
3) Asks for explicit confirmation:
   - "Re-validate section <SECTION_ID> WITHOUT changing content? (yes/no)"
4) On yes:
   - Updates `index.md` (NO version bump):
     - marks section as `Locked (Re-validated in vX.Y)`
     - appends change-log entry: "Re-validated <SECTION_ID> in vX.Y"
   - Updates section front-matter:
     - status: locked
     - last_validated: vX.Y
     - version_context: vX.Y
     - last_updated: current date
     - keeps `locked_in` unchanged (original lock version remains)
5) If the section still depends on unresolved stale parents, it warns and refuses to complete.

## Output
- Prints: "Section re-validated (no version bump)."
- Prints next recommended action:
  - `/status <RELEASE_ID>` or `/prd-next <RELEASE_ID>`

## Notes
- If you need to edit content, do NOT use /revalidate. Use /unlock → edit → /lock.
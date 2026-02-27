# /lock

Lock a PRD section and (by policy) bump PRD minor version.

## Usage
/lock <RELEASE_ID> <SECTION_ID>

Example:
/lock R0_MVP problem_definition

## Preconditions
- PRD folder exists: `product/prd/<RELEASE_ID>/`
- Section file exists and matches config/prd.yaml mapping
- Section status must be `draft` or `reopened`
- If section is `stale`, use `/revalidate` unless you will edit content (then you may unlock/edit/relock)

## What it does (Dual-state)
1) Reads `product/prd/<RELEASE_ID>/index.md`:
   - current PRD version (front-matter + body)
   - status matrix
2) Reads the section file (e.g. `02_problem_definition.md`) front-matter:
   - validates section_id and current status
3) Asks for explicit confirmation:
   - "Lock section <SECTION_ID>? This will bump minor version. (yes/no)"
4) On yes:
   - Increments PRD minor version (per config/versioning.yaml)
   - Updates `index.md`:
     - version in front-matter AND body
     - marks section as `[x] Locked (vX.Y)` or equivalent
     - appends change-log entry for the lock
   - Updates section front-matter:
     - status: locked
     - locked_in: vX.Y
     - last_validated: vX.Y
     - version_context: vX.Y
     - last_updated: current date
5) Stale propagation:
   - If this lock follows an edit of a previously locked section (i.e., section was reopened),
     then mark dependent sections as `stale` in BOTH:
       a) index status matrix
       b) section front-matter (status: stale, affected_by filled)
   - Dependency list is taken from `config/dependencies.yaml`

## Output
- Prints new PRD version
- Prints any sections that were marked stale
- Prints next recommended command:
  - `/prd-next <RELEASE_ID>` or `/status <RELEASE_ID>`

## Notes
- Do not manually toggle checkboxes/status text in index; always use commands.
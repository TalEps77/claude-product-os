# /prd-next

Continue PRD authoring by automatically selecting the next section to work on
and invoking the PRD Orchestrator behavior.

## Usage
/prd-next <RELEASE_ID>

Example:
/prd-next R0_MVP

## Preconditions
- PRD exists at: `product/prd/<RELEASE_ID>/`
- Index exists: `product/prd/<RELEASE_ID>/index.md`

## Selection Rule (deterministic)
Pick the next section in this priority order:
1) Any section in state `reopened` (must be re-locked)
2) Any section in state `stale` (must be revalidated or edited+relocked)
3) Next `draft` section by the canonical order defined in `config/prd.yaml`

## What it does
1) Reads `product/prd/<RELEASE_ID>/index.md` and determines:
   - current PRD version
   - overall status (draft/approved)
   - current section statuses
2) Validates:
   - section list matches `config/prd.yaml`
   - warns if index/header mismatches exist (suggest: `/status <RELEASE_ID>`)
3) Identifies the next target section using the selection rule.
4) Prints:
   - "Next section: <SECTION_ID> (<FILE>) — status: <STATUS> — PRD version: vX.Y"
5) Enters Orchestrator mode:
   - Ask up to 3 focused questions
   - Draft the section content according to its template
   - Ask for approval
   - Recommend the next command:
     - Draft/Reopened: `/lock <RELEASE_ID> <SECTION_ID>`
     - Stale (no content change): `/revalidate <RELEASE_ID> <SECTION_ID>`
     - Stale (needs edit): `/unlock` → edit → `/lock`

## Notes
- This command does not itself modify files; it orchestrates the authoring workflow.
- File writes/state transitions are done via: /lock /unlock /revalidate /approve

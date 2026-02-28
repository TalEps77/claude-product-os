# /prd-init

Create a modular Release PRD folder from OS templates.

## Usage
/prd-init <RELEASE_ID>

Example:
/prd-init R0_MVP

## What it does
1) Checks whether `product/vision.md` and `product/roadmap.md` exist in the current project repo.
   - If missing, it warns and asks:
     "Vision/Roadmap not found. Create them now? (yes/no)"
   - If yes:
     - Run: `/vision-init`
     - Then: `/roadmap-init`
   - If no: continues with PRD initialization.
2) Creates `product/prd/<RELEASE_ID>/` (if not exists).
3) Copies PRD templates into that folder:
   - `templates/prd/index.md` → `product/prd/<RELEASE_ID>/index.md`
   - All files in `templates/release-prd/*.md` → `product/prd/<RELEASE_ID>/`
4) Replaces placeholders minimally (v0.1):
   - {{RELEASE_ID}} = <RELEASE_ID>
   - {{DATE_ISO}} = current date (ISO)
   - {{DATE_HUMAN}} = current date (human readable)
   - {{OWNER}} = current user (if known) or "TBD"
   - {{PRODUCT_NAME}} = inferred from repo name or asks once if unclear
   - {{VISION_REF}} = `/product/vision.md@v<vision_version_or_TBD>`
5) Prints next step:
   - "PRD initialized. Next: /prd-next <RELEASE_ID>"

## Constraints (v0.1)
- Does not lock sections.
- Does not validate config mismatch (handled by /status and orchestrator).
- Does not decompose tasks (future command: /decompose).

## Notes
- The PRD folder is the source of truth.
- Do not manually edit section status fields; use commands.

# /roadmap-init

Create `product/roadmap.md` from the OS template.

## Usage
/roadmap-init

## Preconditions (recommended)
- `product/vision.md` exists (recommended, not hard required)

## What it does
1) Checks if `product/roadmap.md` already exists.
   - If yes: warns and asks if you want to overwrite (yes/no).
2) Creates `product/` directory if missing.
3) Copies OS template:
   - `claude-product-os/templates/roadmap.md` → `product/roadmap.md`
4) Replaces minimal placeholders (v0.1):
   - {{PRODUCT_NAME}} = inferred from repo name (or "TBD")
   - {{OWNER}} = current user (or "TBD")
   - {{DATE_ISO}} / {{DATE_HUMAN}} = current date
   - {{VISION_REF}} = `/product/vision.md@vTBD`
5) Prints next suggestion:
   - "Next: /prd-init <RELEASE_ID>"

## Notes
- Roadmap is milestone-oriented; features live in Release PRDs.

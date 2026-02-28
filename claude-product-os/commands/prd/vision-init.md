# /vision-init

Create `product/vision.md` from the OS template.

## Usage
/vision-init

## What it does
1) Checks if `product/vision.md` already exists.
   - If yes: warns and asks if you want to overwrite (yes/no).
2) Creates `product/` directory if missing.
3) Copies OS template:
   - `claude-product-os/templates/vision.md` → `product/vision.md`
4) Replaces minimal placeholders (v0.1):
   - {{PRODUCT_NAME}} = inferred from repo name (or "TBD")
   - {{OWNER}} = current user (or "TBD")
   - {{DATE_ISO}} / {{DATE_HUMAN}} = current date
5) Prints next suggestion:
   - "Next: /roadmap-init"

## Notes
- Vision is flexible and can evolve over time.
- Vision is not the Release PRD.

A# Integration Runbook — Claude Product OS ↔ everything-claude-code (ECC)

This OS vendors ECC as a pinned dependency (by tag) under:
claude-product-os/vendor/everything-claude-code

Policy (v0.1):
- Overlay-first: do NOT copy all ECC content.
- Wrap only the workflows we need (OS commands). Keep ECC available for power users.
- ECC is pinned to a specific tag for deterministic behavior across the team.
- Update mode is manual (v0.1).

------------------------------------------------------------
1) Current Integration State
------------------------------------------------------------
- ECC location: claude-product-os/vendor/everything-claude-code
- Pin type: Git tag (e.g., v1.7.0)
- Update mode: Manual (v0.1)
- Project consumption: OS repo as a submodule (branch stable)

------------------------------------------------------------
2) Clone OS correctly (including ECC)
------------------------------------------------------------
Clone + init submodules:

$ git clone <OS_REPO_URL>
$ cd <OS_REPO_DIR>
$ git submodule update --init --recursive

If OS was already cloned but ECC is missing:

$ git submodule update --init --recursive

Verify ECC pin:

$ git submodule status

Expected: ECC appears with a tag marker, e.g. (v1.7.0)

------------------------------------------------------------
3) Update ECC (Pinned Tag Update)
------------------------------------------------------------

3.1 Pre-check (OS repo root):
$ git status
$ git submodule status
Ensure working tree is clean.

3.2 List available tags in ECC:
$ cd claude-product-os/vendor/everything-claude-code
$ git fetch --tags
$ git tag --list | tail -n 30

3.3 Pin ECC to the new tag:
$ git checkout <NEW_TAG>
$ git describe --tags --always

Expected output: <NEW_TAG>
Note: “detached HEAD” is expected for a pinned dependency.

3.4 Return to OS repo root:
$ cd ../../../..

3.5 Commit the new pin in the OS repo:
$ git add .gitmodules claude-product-os/vendor/everything-claude-code
$ git commit -m "Pin ECC to <NEW_TAG>"

3.6 Push:
$ git push

------------------------------------------------------------
4) Smoke Test (Required before releasing OS)
------------------------------------------------------------
Goal: ensure PRD templates + configs are consistent AND ECC is reachable.

4.1 Verify templates exist:
$ ls claude-product-os/templates/prd
$ ls claude-product-os/templates/release-prd

Expected:
- templates/prd/index.md
- templates/prd/section.md
- templates/release-prd/02_problem_definition.md ... 14_approval.md

4.2 Verify configs exist:
$ ls claude-product-os/config

Expected:
- prd.yaml
- dependencies.yaml
- versioning.yaml

4.3 Verify ECC commands exist (sanity):
$ ls claude-product-os/vendor/everything-claude-code/commands | head -n 10

Expected: files like plan.md, tdd.md, verify.md, etc.

4.4 Verify submodule status pinned:
$ git submodule status

Expected: ECC shows a commit + tag.

------------------------------------------------------------
5) Release OS to the team
------------------------------------------------------------

5.1 Update changelog:
Edit: claude-product-os/versions/CHANGELOG.md
Add:
- OS version (e.g., os-v0.2)
- ECC pinned tag (e.g., ECC=v1.7.0)
- Notable changes

5.2 Tag OS release:
$ git tag os-v0.2
$ git push origin os-v0.2

5.3 Update stable branch (if stable is the consumption channel):
$ git push origin main:stable

(If you work directly on stable, just use: $ git push)

------------------------------------------------------------
6) Update OS inside a project repo (consumer workflow)
------------------------------------------------------------
Projects consume OS via submodule pointing to branch stable.

From the project repo:
$ git submodule update --remote --merge
$ git add <path-to-os-submodule>
$ git commit -m "Update Claude Product OS"
$ git push

(Optional) If you want to pin the project to a specific OS tag:
- cd into the OS submodule directory
- checkout the tag
- commit the pointer in the project repo

------------------------------------------------------------
7) Troubleshooting
------------------------------------------------------------

“Detached HEAD” in ECC submodule:
- Expected. ECC is pinned to a tag.

Submodule directory empty:
$ git submodule update --init --recursive

Authentication fails on push:
- Use GitHub token (PAT) or SSH.

------------------------------------------------------------
8) Notes (v0.1 limitations)
------------------------------------------------------------
- Updates are manual (no auto-sync script yet).
- Wrappers do not cover all ECC commands.
- ECC remains available for direct (power) use.
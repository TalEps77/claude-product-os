SMOKE TEST — Claude Product OS (v0.1)

Goal:
Validate that the OS repository includes required configs/templates, and that the vendored ECC dependency is present and pinned.

Prerequisites:
- You cloned the OS repo and ran:
  git submodule update --init --recursive

Checks:

1) OS structure exists
- claude-product-os/config/
- claude-product-os/templates/
- claude-product-os/commands/
- claude-product-os/agents/
- claude-product-os/vendor/everything-claude-code/

2) Configs exist
- config/prd.yaml
- config/dependencies.yaml
- config/versioning.yaml

3) PRD templates exist
- templates/prd/index.md
- templates/prd/section.md
- templates/release-prd/02_problem_definition.md ... 14_approval.md

4) ECC presence (sanity)
- vendor/everything-claude-code/commands/plan.md
- vendor/everything-claude-code/commands/tdd.md
- vendor/everything-claude-code/commands/verify.md

5) ECC pin check
Run:
  git submodule status
Expected:
  ECC shows a commit + (vX.Y.Z) tag, e.g. (v1.7.0)

Notes:
- This smoke test is updated when:
  a) OS paths/files change
  b) ECC tag upgrade changes required ECC files/paths
  c) OS adds new mandatory capabilities

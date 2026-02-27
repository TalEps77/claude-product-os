# Claude Product OS

Team-grade Product Governance layer for Claude Code workflows.

This repo provides:
- Vision + Roadmap templates
- Release PRD templates (modular, section-by-section)
- PRD as a state machine (Lock/Unlock/Stale/Revalidate + Minor/Major versioning) via YAML configs

Integration plan:
- `vendor/everything-claude-code/` will be used as a pinned dependency (by tag), and selected parts will be re-exported/wrapped by this OS.

Status:
- v0.1 bootstrap includes configs + templates.

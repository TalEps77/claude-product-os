# How to integrate Claude Product OS into a project (v0.1)

Planned approach:
- Projects consume this OS via git submodule (branch: stable).
- This OS will vendor `everything-claude-code` as a pinned dependency by tag under `vendor/`.

Next steps:
- Add integration layer docs + smoke tests.
- Add commands (/prd-init, /lock, /unlock, /revalidate, /approve, /status).

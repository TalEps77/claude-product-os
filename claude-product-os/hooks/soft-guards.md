# Soft Guards (v0.1)

This file defines warnings (not hard blocks) to reduce context rot and state drift.

## Guard 1 — PRD State Mismatch (Index vs Section Headers)
When detected:
- Warn: "PRD state mismatch detected (index vs section headers). Run /status <RELEASE_ID> and fix via commands."
- Recommend: Do not proceed to approval or execution until resolved.

## Guard 2 — Attempting Execution without Approved PRD (Release-level)
When user intends to run release-level execution (verify release, e2e for release, etc):
- Warn: "Release PRD is not approved. Recommended: finish PRD and run /approve <RELEASE_ID>."

## Guard 3 — Attempting Large Feature Work without Task Context
When user starts implementation for a feature without a task spec or PRD references:
- Warn: "No task context detected. Recommended: create task spec or reference PRD sections (FR/AC) before coding."

## Guard 4 — Stale Sections Present
When stale sections exist:
- Warn: "Stale sections exist. Recommended: /revalidate or /unlock→edit→/lock before approval."

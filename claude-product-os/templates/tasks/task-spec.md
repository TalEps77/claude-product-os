---
doc_type: task_spec
task_id: "{{TASK_ID}}"
title: "{{TITLE}}"
status: "draft"                 # draft | in_progress | done
owner: "{{OWNER}}"
created_at: "{{DATE_ISO}}"
updated_at: "{{DATE_ISO}}"

release_id: "{{RELEASE_ID}}"
prd_ref:
  - "{{PRD_REF}}"
  - "{{PRD_REF}}"

scope:
  in_scope:
    - "{{IN_SCOPE}}"
  out_of_scope:
    - "{{OUT_OF_SCOPE}}"

context:
  repo_areas:
    - "{{PATH_HINT}}"
  related_components:
    - "{{COMPONENT}}"

acceptance:
  criteria:
    - "{{AC_REF}}"
  verification:
    - "Unit tests"
    - "Manual check"

constraints:
  non_functional:
    - "{{NFR_HINT}}"
  security:
    - "{{SECURITY_HINT}}"

notes:
  assumptions:
    - "{{ASSUMPTION}}"
  risks:
    - "{{RISK}}"
---

# Task: {{TASK_ID}} — {{TITLE}}

## Goal
What outcome this task delivers.

## Background (Why)
Short context for why this exists.

## Requirements (What)
- Requirement 1
- Requirement 2

## Implementation Notes (How - non-binding)
- Suggested approach (optional)
- Touchpoints (optional)

## Definition of Done
- Tests added/updated
- Acceptance criteria met
- No regressions
- Docs updated (if needed)

## Links
- PRD references: see front-matter

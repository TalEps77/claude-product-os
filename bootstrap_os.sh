#!/usr/bin/env bash
set -euo pipefail

# Claude Product OS - Bootstrap (v0.1)
# Creates repo structure + config + templates that were authored in this chat.

ROOT="claude-product-os"

mkdir -p "$ROOT"/{agents,commands,config,docs,hooks,rules,templates,versions,examples,vendor}
mkdir -p "$ROOT"/templates/{prd,release-prd}
mkdir -p "$ROOT"/commands/prd

# --- README (minimal) ---
cat > "$ROOT/README.md" <<'EOF'
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
EOF

# --- Configs ---
cat > "$ROOT/config/prd.yaml" <<'EOF'
schema_version: 0.1
doc_type: prd_config
name: default_prd
description: "Default Product/Engineering-first PRD structure (progressive locking, modular files)."

paths:
  prd_root: "product/prd"
  index_file: "product/prd/index.md"

versioning:
  minor_bump_on_lock: true
  major_bump_on_approval: true
  bump_on_content_change_when_revalidating: true   # if stale section requires edits, bump minor

states:
  allowed:
    - draft
    - locked
    - stale
    - reopened
    - approved

  blocking_for_approval:
    - draft
    - stale
    - reopened

transitions:
  draft:
    - locked
  locked:
    - reopened
    - stale
  reopened:
    - locked
  stale:
    - locked
  approved: []

rules:
  single_active_section_edit: true
  forbid_edit_locked_without_unlock: true
  index_and_section_header_must_match: true
  section_statuses_source: "both"            # both index + section headers
  require_section_lock_ack: true             # explicit confirmation before locking

sections:
  - id: problem_definition
    file: "02_problem_definition.md"
    title: "Problem Definition"
    order: 2
    lockable: true

  - id: goals_non_goals
    file: "03_goals.md"
    title: "Goals & Non-Goals"
    order: 3
    lockable: true

  - id: user_journeys
    file: "04_user_journeys.md"
    title: "User Journeys"
    order: 4
    lockable: true

  - id: functional_requirements
    file: "05_functional_requirements.md"
    title: "Functional Requirements"
    order: 5
    lockable: true

  - id: non_functional_requirements
    file: "06_non_functional_requirements.md"
    title: "Non-Functional Requirements"
    order: 6
    lockable: true

  - id: data_model
    file: "07_data_model.md"
    title: "Data Model (Logical)"
    order: 7
    lockable: true

  - id: system_architecture
    file: "08_system_architecture.md"
    title: "System Architecture (High Level)"
    order: 8
    lockable: true

  - id: integrations
    file: "09_integrations.md"
    title: "Integrations"
    order: 9
    lockable: true

  - id: success_metrics
    file: "10_success_metrics.md"
    title: "Success Metrics"
    order: 10
    lockable: true

  - id: risks_assumptions
    file: "11_risks_assumptions.md"
    title: "Risks & Assumptions"
    order: 11
    lockable: true

  - id: open_questions
    file: "12_open_questions.md"
    title: "Open Questions"
    order: 12
    lockable: true

  - id: acceptance_criteria
    file: "13_acceptance_criteria.md"
    title: "Acceptance Criteria"
    order: 13
    lockable: true

  - id: approval
    file: "14_approval.md"
    title: "Approval"
    order: 14
    lockable: true
EOF

cat > "$ROOT/config/dependencies.yaml" <<'EOF'
schema_version: 0.1
doc_type: prd_dependencies
name: default_dependencies
description: "Deterministic PRD section dependency map for stale propagation."

dependencies:
  problem_definition:
    affects:
      - goals_non_goals
      - user_journeys
      - functional_requirements
      - success_metrics
      - acceptance_criteria

  goals_non_goals:
    affects:
      - user_journeys
      - functional_requirements
      - success_metrics
      - acceptance_criteria

  user_journeys:
    affects:
      - functional_requirements
      - data_model
      - acceptance_criteria

  functional_requirements:
    affects:
      - data_model
      - system_architecture
      - integrations
      - acceptance_criteria

  non_functional_requirements:
    affects:
      - system_architecture
      - acceptance_criteria

  data_model:
    affects:
      - system_architecture
      - integrations

  system_architecture:
    affects:
      - integrations
      - acceptance_criteria

  integrations:
    affects:
      - acceptance_criteria

  success_metrics:
    affects:
      - acceptance_criteria
EOF

cat > "$ROOT/config/versioning.yaml" <<'EOF'
schema_version: 0.1
doc_type: prd_versioning
name: default_versioning
description: "PRD versioning policy: minor bumps on locks, major bump on approval, efficient revalidation."

version_format:
  minor_prefix: "v"
  store_as: "major_minor"

policy:
  bump_minor_on_section_lock: true
  bump_major_on_prd_approval: true

  revalidate:
    bump_if_no_content_change: false
    bump_if_content_changes: true
    require_explicit_action: true

  reopen:
    bump_on_unlock: false
    bump_on_relock_after_edit: true

  post_approval:
    default_bump: "major"                  # major | minor
    require_explicit_override: true        # e.g. /reopen --minor

document_states:
  approved_label: "Approved"
  draft_label: "Draft"

recording:
  index_file:
    store_version_in_front_matter: true
    store_version_in_body: true
    store_change_log_entries: true

  section_files:
    store_status_in_front_matter: true
    store_locked_in: true
    store_last_validated: true
    store_reopened_in: true

validation:
  require_index_and_section_version_match: true
  require_index_and_section_status_match: true
EOF

# --- Templates: PRD control plane ---
cat > "$ROOT/templates/prd/index.md" <<'EOF'
---
doc_type: prd_index
prd_id: "{{PRD_ID}}"
product_name: "{{PRODUCT_NAME}}"
release_id: "{{RELEASE_ID}}"            # e.g. R0_MVP
version: "0.1"
status: "draft"                          # draft | approved
created_at: "{{DATE_ISO}}"
updated_at: "{{DATE_ISO}}"
source_of_truth: true
---

# PRD Index — {{PRODUCT_NAME}} — {{RELEASE_ID}}

## Document Version
- **Version:** 0.1
- **Status:** Draft
- **Owner:** {{OWNER}}
- **Last Updated:** {{DATE_HUMAN}}
- **Linked Vision:** {{VISION_REF}}      # e.g. /product/vision.md@v0.3

---

## Section Status Matrix
> Rule: Section status in this index must match the section header in each file.
> Rule: This list must match config/prd.yaml (validated by agent). Do not reorder manually.

- [ ] 02_problem_definition — Draft
- [ ] 03_goals_non_goals — Draft
- [ ] 04_user_journeys — Draft
- [ ] 05_functional_requirements — Draft
- [ ] 06_non_functional_requirements — Draft
- [ ] 07_data_model — Draft
- [ ] 08_system_architecture — Draft
- [ ] 09_integrations — Draft
- [ ] 10_success_metrics — Draft
- [ ] 11_risks_assumptions — Draft
- [ ] 12_open_questions — Draft
- [ ] 13_acceptance_criteria — Draft
- [ ] 14_approval — Draft

---

## Change Log (PRD-local)
- v0.1 — Initialized PRD structure (Draft)

---

## Notes
- Use `/lock <section_id>` to lock a section (minor version bump).
- Use `/unlock <section_id>` to reopen a locked section.
- If a section becomes stale due to dependency changes, it must be `/revalidate`’d before approval.
EOF

cat > "$ROOT/templates/prd/section.md" <<'EOF'
---
doc_type: prd_section
section_id: "{{SECTION_ID}}"            # e.g. data_model
section_title: "{{SECTION_TITLE}}"
order: {{ORDER_NUMBER}}                 # must match config/prd.yaml

status: "draft"                         # draft | locked | stale | reopened
locked_in: null                         # e.g. v0.3
last_validated: null                    # e.g. v0.4
reopened_in: null                       # e.g. v0.5 (if applicable)

depends_on: []                          # filled only if needed (informational)
affected_by: []                         # auto-calculated via dependencies.yaml

version_context: "{{PRD_VERSION}}"      # sync check vs index.md

last_updated: "{{DATE_ISO}}"
owner: "{{OWNER}}"
---

# {{SECTION_TITLE}}

> This section must align with the current PRD version.
> If marked as "stale", it must be re-validated before approval.

---

## Content

<!--
Write the content for this section here.
Follow the structure defined for this section type.
Do not modify status fields manually — use commands.
-->
EOF

# --- Templates: Vision + Roadmap ---
cat > "$ROOT/templates/vision.md" <<'EOF'
---
doc_type: product_vision
product_name: "{{PRODUCT_NAME}}"
version: "0.1"
status: "draft"              # draft | approved
owner: "{{OWNER}}"
created_at: "{{DATE_ISO}}"
updated_at: "{{DATE_ISO}}"
---

# Product Vision — {{PRODUCT_NAME}}

## 1. One-liner
> {{ONE_LINER}}

## 2. Core Promise
> {{CORE_PROMISE}}

## 3. Target Persona (ICP)
- Primary persona:
- Context (where/when they use it):
- Constraints (time, environment, devices):

## 4. Problem Space (high level)
- What frustrates users today?
- Why existing alternatives fail?

## 5. Principles (Product Constitution)
List 5–7 principles that should remain true even as features change.
1.
2.
3.
4.
5.

## 6. Non-Goals (Evergreen)
Explicitly state what this product will NOT try to become.
-
-
-

## 7. Experience Pillars
Define the core experience pillars.
- Pillar 1:
- Pillar 2:
- Pillar 3:

## 8. Risk Posture & Constraints (Evergreen)
- Privacy & security posture:
- Offline expectations:
- Platform scope:
- Cost constraints (AI inference, storage):

## 9. Roadmap Themes (Multi-release)
> Themes, not features. Features belong in Release PRDs.
- R0 Theme:
- R1 Theme:
- R2 Theme:
- R3+ Theme:

## 10. Definition of Success (Vision-level)
- What “winning” looks like in 6 months:
- In 12 months:
- In 24 months:

## 11. Open Questions (Vision-level)
-
-
-

---

## Approval
- Owner: {{OWNER}}
- Approved by: {{APPROVER}}
- Date: {{DATE_HUMAN}}
- Vision Version: 0.1
EOF

cat > "$ROOT/templates/roadmap.md" <<'EOF'
---
doc_type: product_roadmap
product_name: "{{PRODUCT_NAME}}"
version: "0.1"
status: "draft"                # draft | active | frozen
owner: "{{OWNER}}"
created_at: "{{DATE_ISO}}"
updated_at: "{{DATE_ISO}}"
linked_vision: "{{VISION_REF}}"
---

# Product Roadmap — {{PRODUCT_NAME}}

## Status Legend
- ⬜ Planned
- 🟡 In Progress
- 🟢 Completed
- 🔴 Dropped
- 🔵 Deferred

---

## Roadmap Principles
> Derived from Vision. Must not contradict it.

- Principle 1:
- Principle 2:
- Principle 3:

---

## Milestones

### R0 — {{RELEASE_NAME}}
Status: ⬜ Planned
Linked PRD: `product/prd/R0/index.md`

Goal:
-

Scope Summary:
-

Out of Scope:
-

Success Signal:
-

---

### R1 — {{RELEASE_NAME}}
Status: ⬜ Planned
Linked PRD: `product/prd/R1/index.md`

Goal:
-

Scope Summary:
-

Out of Scope:
-

Success Signal:
-

---

### R2 — {{RELEASE_NAME}}
Status: ⬜ Planned
Linked PRD: `product/prd/R2/index.md`

Goal:
-

Scope Summary:
-

Out of Scope:
-

Success Signal:
-

---

## Cross-Release Themes
- Theme:
- Theme:
- Theme:

---

## Risks to Roadmap
- Technical risk:
- Product risk:
- Market risk:

---

## Changes Log
- v0.1 — Initial roadmap
EOF

# --- Templates: Release PRD Sections (02-14) ---
cat > "$ROOT/templates/release-prd/02_problem_definition.md" <<'EOF'
---
doc_type: prd_section
section_id: problem_definition
section_title: Problem Definition
order: 2
status: draft
locked_in: null
last_validated: null
reopened_in: null
version_context: "{{PRD_VERSION}}"
last_updated: "{{DATE_ISO}}"
owner: "{{OWNER}}"
---

# Problem Definition

## Problem Statement
> [Persona] struggles with [specific problem] because [root cause], which leads to [measurable consequence].

## Who Experiences the Problem
### Primary Persona
- Description:
- Context of use:
- Constraints:
- Technical literacy:

### Secondary Personas (if relevant)
-

## Current Alternatives
### What users do today
-

### Why it fails
-

## Root Causes
- Structural:
- Behavioral:
- Technical:
- Economic:

## Frequency & Severity
- How often:
- Severity:
- Consequence if unresolved:

## Why Now
- Technology shifts:
- Behavioral shifts:
- Market changes:

## Evidence
- Observations:
- Assumptions:
- Unknowns:

## Problem Boundaries
-
-
-
EOF

cat > "$ROOT/templates/release-prd/03_goals.md" <<'EOF'
---
doc_type: prd_section
section_id: goals_non_goals
section_title: Goals & Non-Goals
order: 3
status: draft
locked_in: null
last_validated: null
reopened_in: null
version_context: "{{PRD_VERSION}}"
last_updated: "{{DATE_ISO}}"
owner: "{{OWNER}}"
---

# Goals & Non-Goals

## 1. Release Goal (One Sentence)
> In {{TIMEFRAME}}, the product will {{PRIMARY_OUTCOME}} for {{PRIMARY_PERSONA}}.

## 2. Goals (Must Achieve)
> 3–7 goals. Each must be testable or measurable.

- **G1 —**
  - Definition:
  - Measure:
  - Notes:

- **G2 —**
  - Definition:
  - Measure:
  - Notes:

## 3. Non-Goals (Explicitly Out of Scope)
- **NG1 —**
  - Why excluded now:
  - When later:

- **NG2 —**
  - Why excluded now:
  - When later:

## 4. Constraints & Guardrails (Release-Level)
- Budget constraints:
- Time constraints:
- Platform constraints:
- Privacy/security constraints:
- Offline constraints:

## 5. Trade-offs (What we chose to optimize)
- We optimize for:
- We accept:
- We will not optimize for:

## 6. Open Questions (Goals-related)
-
-
EOF

cat > "$ROOT/templates/release-prd/04_user_journeys.md" <<'EOF'
---
doc_type: prd_section
section_id: user_journeys
section_title: User Journeys
order: 4
status: draft
locked_in: null
last_validated: null
reopened_in: null
version_context: "{{PRD_VERSION}}"
last_updated: "{{DATE_ISO}}"
owner: "{{OWNER}}"
---

# User Journeys

> Describe how users accomplish meaningful outcomes.
> Focus on outcomes, not UI screens.

## Journey Structure
For each journey define:
- Trigger
- Preconditions
- User Steps
- System Responsibilities
- Data Changes
- Success Signal
- Edge Cases

## Journey J1 — {{Journey Name}}
### Goal
### Trigger
### Preconditions
### Steps
1.
2.
3.
### System Responsibilities
-
### Data Impact
- Entities created:
- Entities updated:
- Entities read:
### Success Signal
### Edge Cases
-
-

## Journey J2 — {{Journey Name}}
### Goal
### Trigger
### Preconditions
### Steps
1.
2.
3.
### System Responsibilities
-
### Data Impact
- Entities created:
- Entities updated:
- Entities read:
### Success Signal
### Edge Cases
-
-

## Journey Coverage Check
- Each Goal has ≥1 journey
- Each journey maps to FR
- Each journey touches defined entities

## Open Questions
-
-
EOF

cat > "$ROOT/templates/release-prd/05_functional_requirements.md" <<'EOF'
---
doc_type: prd_section
section_id: functional_requirements
section_title: Functional Requirements
order: 5
status: draft
locked_in: null
last_validated: null
reopened_in: null
version_context: "{{PRD_VERSION}}"
last_updated: "{{DATE_ISO}}"
owner: "{{OWNER}}"
---

# Functional Requirements

> Describe what the system must do, independent of UI/implementation.

## Requirement Format
Each FR must include:
- ID
- Description
- Trigger
- Inputs/Outputs
- System Behavior
- Failure Handling
- Related Journeys
- Data Impact

## FR-1 — {{Requirement Name}}
### Description
### Trigger
### Inputs
### Outputs
### System Behavior
### Failure Handling
### Related Journeys
### Data Impact
- Read:
- Write:
- Update:
- Delete:

## FR-2 — {{Requirement Name}}
### Description
### Trigger
### Inputs
### Outputs
### System Behavior
### Failure Handling
### Related Journeys
### Data Impact
- Read:
- Write:
- Update:
- Delete:

## Consistency Check
- Every Journey maps to ≥1 FR
- Every FR maps to ≥1 Journey
- Every FR touches Data Model

## Open Questions
-
-
EOF

cat > "$ROOT/templates/release-prd/06_non_functional_requirements.md" <<'EOF'
---
doc_type: prd_section
section_id: non_functional_requirements
section_title: Non-Functional Requirements
order: 6
status: draft
locked_in: null
last_validated: null
reopened_in: null
version_context: "{{PRD_VERSION}}"
last_updated: "{{DATE_ISO}}"
owner: "{{OWNER}}"
---

# Non-Functional Requirements

## Performance
- Response time targets:
- AI inference latency:
- Throughput:
- Batch vs realtime rules:

## Reliability
- Availability:
- Error tolerance:
- Retry behavior:
- Fallback:

## Scalability
- Expected user scale:
- Data growth:
- AI usage growth:

## Security
- Authentication:
- Authorization:
- Encryption:
- Key management:
- Secrets:

## Privacy
- Personal data:
- Image storage:
- AI data usage:
- Retention:
- Deletion:

## Offline Behavior
- What works offline:
- Degraded mode:
- Sync assumptions:

## Observability
- Logs:
- Metrics:
- Alerts:
- Tracing:

## Cost Constraints
- AI budget:
- Storage budget:
- Compute assumptions:
- Tradeoffs:

## Cross-Requirement Impact
- Architecture:
- Data model:
- Integrations:

## Open Questions
-
-
EOF

cat > "$ROOT/templates/release-prd/07_data_model.md" <<'EOF'
---
doc_type: prd_section
section_id: data_model
section_title: Data Model (Logical)
order: 7
status: draft
locked_in: null
last_validated: null
reopened_in: null
version_context: "{{PRD_VERSION}}"
last_updated: "{{DATE_ISO}}"
owner: "{{OWNER}}"
---

# Data Model (Logical)

## 1. Core Entities

### Entity: {{Entity Name}}
#### Description
#### Fields (Logical)
| Field | Type (Logical) | Required | Description |
|---|---|---|---|
#### Identity
- Primary identifier:
- External identifiers:
#### Lifecycle
- Created when:
- Updated when:
- Deleted when:
- Archived when:

## 2. Relationships
### Relationship: {{Entity A}} → {{Entity B}}
- Type: 1:1 | 1:N | M:N
- Ownership:
- Cascade rules:

## 3. Derived / Computed Data
- Derived field:
- Logic:
- When computed:

## 4. AI-Specific Data
- Embeddings:
- Model inputs:
- Model outputs:
- Feedback signals:

## 5. Data Consistency Rules
- Uniqueness:
- Referential rules:
- Validation rules:

## 6. Data Volume Assumptions
- Users:
- Items/user:
- Growth:
- Retention:

## 7. Data Access Patterns
- Read-heavy:
- Write-heavy:
- Query patterns:
- Realtime vs batch:

## 8. Privacy-Sensitive Data
- Personal data:
- Sensitive attributes:
- Retention rules:

## 9. Open Questions
-
-
EOF

cat > "$ROOT/templates/release-prd/08_system_architecture.md" <<'EOF'
---
doc_type: prd_section
section_id: system_architecture
section_title: System Architecture (High Level)
order: 8
status: draft
locked_in: null
last_validated: null
reopened_in: null
version_context: "{{PRD_VERSION}}"
last_updated: "{{DATE_ISO}}"
owner: "{{OWNER}}"
---

# System Architecture (High Level)

## 1. Architecture Overview
- Core system shape:
- Key responsibilities:
- Data ownership boundaries:

## 2. System Components
### Component: {{Name}}
- Responsibility:
- Inputs:
- Outputs:
- Data interaction:
- Failure behavior:

## 3. AI Components
### AI Capability: {{Name}}
- Purpose:
- Inputs:
- Outputs:
- Trigger:
- Feedback loop:
- Latency expectations:

## 4. Data Flow
- Main data paths:
- Request vs event flow:
- Sync vs async:

## 5. State Management
- Source of truth:
- Cached data:
- Derived state:
- Sync model:

## 6. Integration Boundaries
- APIs:
- Webhooks:
- Batch:
- Streaming:

## 7. Scaling Strategy (Conceptual)
- Stateless vs stateful:
- AI scaling assumptions:

## 8. Failure Modes
- Component failure:
- AI failure:
- Data inconsistency:
- Integration downtime:

## 9. Observability Hooks
- Metrics:
- Logs:
- Alerts:

## 10. Open Questions
-
-
EOF

cat > "$ROOT/templates/release-prd/09_integrations.md" <<'EOF'
---
doc_type: prd_section
section_id: integrations
section_title: Integrations
order: 9
status: draft
locked_in: null
last_validated: null
reopened_in: null
version_context: "{{PRD_VERSION}}"
last_updated: "{{DATE_ISO}}"
owner: "{{OWNER}}"
---

# Integrations

## Integration Format
- Purpose
- Data exchanged (in/out)
- Direction (push/pull/bidirectional)
- Trigger
- Dependency impact
- Failure handling
- Latency expectations
- Security & privacy impact

## Integration I1 — {{Integration Name}}
### Purpose
### Data Exchanged
- Outgoing:
- Incoming:
### Direction
### Trigger
### System Dependency
### Failure Handling
- Retry:
- Fallback:
- Degraded mode:
### Latency
### Security Considerations
### Privacy Impact

## Integration I2 — {{Integration Name}}
(repeat)

## Integration Risk Summary
- Highest risk:
- Lock-in risk:
- Cost risk:

## Open Questions
-
-
EOF

cat > "$ROOT/templates/release-prd/10_success_metrics.md" <<'EOF'
---
doc_type: prd_section
section_id: success_metrics
section_title: Success Metrics
order: 10
status: draft
locked_in: null
last_validated: null
reopened_in: null
version_context: "{{PRD_VERSION}}"
last_updated: "{{DATE_ISO}}"
owner: "{{OWNER}}"
---

# Success Metrics

## 1. Primary Success Metric
- Name:
- Definition:
- Target:
- Timeframe:

## 2. Secondary Metrics
- S1:
- S2:

## 3. Product Health Metrics
- Reliability:
- Performance:
- AI quality:
- Error rate:

## 4. Adoption Metrics
- Activation:
- Engagement:
- Retention:
- Frequency:

## 5. Business Metrics (If Relevant)
- Revenue:
- Cost:
- Conversion:
- Affiliate:

## 6. Qualitative Signals
- Feedback:
- Behavioral indicators:
- Support signals:

## 7. Guardrail Metrics
- Performance:
- Privacy:
- Cost:
- Accuracy:

## 8. Measurement Infrastructure
- Data sources:
- Instrumentation:
- Dashboards:
- Ownership:

## 9. Open Questions
-
-
EOF

cat > "$ROOT/templates/release-prd/11_risks_assumptions.md" <<'EOF'
---
doc_type: prd_section
section_id: risks_assumptions
section_title: Risks & Assumptions
order: 11
status: draft
locked_in: null
last_validated: null
reopened_in: null
version_context: "{{PRD_VERSION}}"
last_updated: "{{DATE_ISO}}"
owner: "{{OWNER}}"
---

# Risks & Assumptions

## 1. Product Risks
### Risk R1 —
- Description:
- Impact:
- Likelihood:
- Mitigation:
- Detection:

## 2. Technical Risks
### Risk T1 —
- Description:
- Impact:
- Likelihood:
- Mitigation:
- Detection:

## 3. AI-Specific Risks
### Risk A1 —
- Hallucination/inconsistency:
- Bias:
- Latency:
- Cost:

## 4. Integration Risks
- Vendor change:
- API limits:
- SLA mismatch:
- Rate limits:

## 5. Data Risks
- Data quality:
- Missing data:
- Privacy exposure:

## 6. Assumptions
### Assumption A1 —
- Statement:
- Why we believe it:
- What invalidates it:
- How to test:

## 7. Validation Plan
- Experiments:
- Spikes:
- User validation:
- Technical POCs:

## 8. Open Questions
-
-
EOF

cat > "$ROOT/templates/release-prd/12_open_questions.md" <<'EOF'
---
doc_type: prd_section
section_id: open_questions
section_title: Open Questions
order: 12
status: draft
locked_in: null
last_validated: null
reopened_in: null
version_context: "{{PRD_VERSION}}"
last_updated: "{{DATE_ISO}}"
owner: "{{OWNER}}"
---

# Open Questions

## Question Format
- Question
- Why it matters
- Options
- Owner
- Target resolution time
- Impact if unresolved

## Q1 —
### Question
### Why it matters
### Options
### Owner
### Target Resolution
### Impact if Unresolved

## Q2 —
### Question
### Why it matters
### Options
### Owner
### Target Resolution
### Impact if Unresolved

## Resolution Log
- Q1 → Decision:
- Q2 → Decision:

## Blocking Questions
-
-
EOF

cat > "$ROOT/templates/release-prd/13_acceptance_criteria.md" <<'EOF'
---
doc_type: prd_section
section_id: acceptance_criteria
section_title: Acceptance Criteria
order: 13
status: draft
locked_in: null
last_validated: null
reopened_in: null
version_context: "{{PRD_VERSION}}"
last_updated: "{{DATE_ISO}}"
owner: "{{OWNER}}"
---

# Acceptance Criteria

## Acceptance Format
Each AC must be:
- Observable
- Testable
- Binary (pass/fail)
- Linked to FR/Journey/Metrics

## AC-1 —
### Statement
### Verification Method
- Automated test | Manual validation | Monitoring metric | User validation
### Related
- FR:
- Journey:
- Metric:
### Pass Condition
### Fail Condition

## AC-2 —
(repeat)

## Cross-System Acceptance
- End-to-end flows:
- AI output quality:
- Performance thresholds:

## Release Gate
- All AC pass
- No blocking open questions
- No stale sections

## Observability Requirements
- Logs:
- Metrics:
- Alerts:

## Open Questions
-
-
EOF

cat > "$ROOT/templates/release-prd/14_approval.md" <<'EOF'
---
doc_type: prd_section
section_id: approval
section_title: Approval
order: 14
status: draft
locked_in: null
last_validated: null
reopened_in: null
version_context: "{{PRD_VERSION}}"
last_updated: "{{DATE_ISO}}"
owner: "{{OWNER}}"
---

# PRD Approval

## Approval Checklist
- All sections are Locked
- No sections marked Stale
- All Open Questions resolved or accepted
- Acceptance Criteria defined
- Risks acknowledged
- Dependencies reviewed
- Major version bump ready

## Approval Decision
### Approved By
- Product:
- Engineering:
- Design (if relevant):
- QA (if relevant):

### Approval Date
{{DATE}}

### Approved Version
v{{VERSION_MAJOR}}.0

## Execution Authorization
This PRD is authorized for:
- Task decomposition
- Engineering execution
- Test planning

## Notes
-
-

## Post-Approval Changes
If PRD changes after approval:
- Requires reopen
- Requires version bump
- Must record change log
EOF

# --- Placeholders for docs/governance ---
cat > "$ROOT/versions/CHANGELOG.md" <<'EOF'
# Changelog

## v0.1
- Bootstrap: configs + templates (Vision/Roadmap + modular Release PRD)
EOF

cat > "$ROOT/docs/how-to-integrate.md" <<'EOF'
# How to integrate Claude Product OS into a project (v0.1)

Planned approach:
- Projects consume this OS via git submodule (branch: stable).
- This OS will vendor `everything-claude-code` as a pinned dependency by tag under `vendor/`.

Next steps:
- Add integration layer docs + smoke tests.
- Add commands (/prd-init, /lock, /unlock, /revalidate, /approve, /status).
EOF

cat > "$ROOT/docs/integration.md" <<'EOF'
# Integration with everything-claude-code (planned)

- Dependency location: vendor/everything-claude-code (pinned by tag).
- Re-export mode: Copy/Sync selected assets into this OS for customization.
- Update flow (v0.1): manual tag update + smoke test.
EOF

# --- Git hygiene ---
cat > "$ROOT/.gitignore" <<'EOF'
.DS_Store
EOF

echo "✅ Bootstrap complete: created '$ROOT' with configs + templates."
echo "Next: add vendor/everything-claude-code as a submodule (pinned by tag), then implement commands."

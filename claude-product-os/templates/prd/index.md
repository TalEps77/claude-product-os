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

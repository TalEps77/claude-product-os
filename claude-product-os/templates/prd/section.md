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

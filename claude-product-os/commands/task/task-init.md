# /task-init

Create a new Task Spec file from OS template.

## Usage
/task-init <TASK_ID> "<TITLE>" <RELEASE_ID>

Example:
/task-init T-001 "Add garment capture flow" R0_MVP

## What it does
1) Creates `engineering/tasks/` if missing.
2) Creates `engineering/tasks/<TASK_ID>.md` from template:
   - `claude-product-os/templates/tasks/task-spec.md`
3) Fills minimal placeholders (v0.1):
   - {{TASK_ID}}, {{TITLE}}, {{RELEASE_ID}}
   - {{OWNER}} (or "TBD")
   - {{DATE_ISO}} (current date)
4) Prints next steps:
   - "Fill PRD references + scope + acceptance"
   - "Then run /task <TASK_ID> (future) or use ECC /tdd with task context"

## Notes
- Task specs prevent context rot in execution.
- Keep scope small; split tasks if needed.

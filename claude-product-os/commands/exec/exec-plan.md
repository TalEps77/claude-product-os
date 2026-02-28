# /exec-plan

Run planning workflow with task context.

Usage:
/exec-plan <TASK_ID>

What it does:
- Loads engineering/tasks/<TASK_ID>.md
- (Soft) warns if PRD for release_id is missing or not approved
- Instructs ECC: /plan with the task context (goal/scope/DoD)

Maps to ECC: /plan

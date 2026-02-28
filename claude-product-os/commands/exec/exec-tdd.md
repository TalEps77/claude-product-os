# /exec-tdd

Run TDD workflow with task context.

Usage:
/exec-tdd <TASK_ID>

What it does:
- Loads engineering/tasks/<TASK_ID>.md
- (Soft) warns if PRD for release_id is missing or not approved
- Instructs ECC: /tdd with the task context (requirements + acceptance refs)

Maps to ECC: /tdd

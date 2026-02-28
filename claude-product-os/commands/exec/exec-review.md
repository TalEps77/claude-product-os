# /exec-review

Run code review workflow with PRD/Task context.

Usage:
/exec-review <TASK_ID>

What it does:
- Loads engineering/tasks/<TASK_ID>.md
- (Soft) warns if no PRD refs exist
- Instructs ECC: /code-review and includes scope + DoD

Maps to ECC: /code-review

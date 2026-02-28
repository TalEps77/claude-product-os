# /exec-refactor

Refactor/cleanup after feature completion without changing intended behavior.

Usage:
/exec-refactor <TASK_ID>

What it does:
- Loads engineering/tasks/<TASK_ID>.md
- Instructs ECC: /refactor-clean with constraints (no behavior change unless specified)

Maps to ECC: /refactor-clean

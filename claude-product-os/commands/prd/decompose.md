# /decompose

Decompose an approved Release PRD into milestones and Task Specs (bounded context).

## Usage
/decompose <RELEASE_ID>

Example:
/decompose R0_MVP

## Preconditions (recommended)
- PRD exists: product/prd/<RELEASE_ID>/
- PRD is approved (soft gate in v0.1: warn if not approved)

## What it does (v0.1)
1) Reads PRD index + key sections:
   - 04_user_journeys
   - 05_functional_requirements
   - 07_data_model
   - 13_acceptance_criteria
2) Builds a decomposition plan:
   - 3–7 milestones maximum
   - each milestone yields 2–6 tasks maximum
3) For each task, creates a Task Spec using the OS template:
   - claude-product-os/templates/tasks/task-spec.md
   - output path: engineering/tasks/<TASK_ID>.md
4) Ensures each task has:
   - clear in_scope/out_of_scope
   - PRD references (FR/AC)
   - definition of done
   - repo areas / components (best effort)

## Task ID Policy
- TASK_ID format: T-<3digits> (T-001, T-002, ...)
- Start at T-001 per release unless the project already has tasks
- If tasks already exist, continue the sequence

## Output
- Creates/updates engineering/tasks/
- Prints a milestone summary + the list of tasks created
- Recommends next step:
  - /task-init (manual additions) or /task <TASK_ID> (execution)

## Notes
- v0.1 is guidance-based; generation may be semi-manual.
- Keep tasks small; split if >1 component or >1 user journey is involved.

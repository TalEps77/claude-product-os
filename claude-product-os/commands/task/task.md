# /task

Load a Task Spec and start the appropriate execution workflow (interactive selection).

## Usage
/task <TASK_ID>

Example:
/task T-001

## Preconditions
- Task file exists: `engineering/tasks/<TASK_ID>.md`
- (Recommended) Release PRD exists for the task release_id: `product/prd/<RELEASE_ID>/`

## What it does
1) Reads the task file `engineering/tasks/<TASK_ID>.md` and extracts:
   - title, release_id, scope (in/out), acceptance criteria refs, repo areas, constraints
2) (Recommended) Loads referenced PRD sections based on `prd_ref` entries (if paths exist).
3) Prints a short context package summary:
   - Task goal + in-scope/out-of-scope + DoD + verification
4) Asks the user to choose a workflow:
   - 1) Plan (ECC: /plan)
   - 2) TDD (ECC: /tdd)
   - 3) Verify (ECC: /verify)
   - 4) Build fix (ECC: /build-fix)
   - 5) Code review (ECC: /code-review)
   - 6) Refactor clean (ECC: /refactor-clean)
   - 7) E2E (ECC: /e2e)
5) Based on selection, instructs the corresponding ECC command and passes the context package.

## Output (v0.1)
- Prints the selected ECC command to run
- Prints the context that should be included (task excerpt + PRD excerpt refs)
- Reminds the user to run /exec-verify or /status as appropriate after changes

## Notes
- v0.1 is guidance-based; wrappers that automatically invoke ECC come later.
- If PRD is not approved, the OS should warn (soft) but not block.

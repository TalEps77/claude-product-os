# Integration Mapping — Claude Product OS ↔ everything-claude-code (ECC)

This OS provides Product Governance and a recommended execution path.
ECC provides execution workflows (plan/tdd/review/fix/verify) and rich skills.

## Principles
1) Default path: use OS commands (governance + context packaging).
2) Full access: ECC commands remain available for power users.
3) Gates: execution should not run without appropriate product/task context.

---

## Layers

### Governance Layer (OS-owned)
- Vision / Roadmap / Release PRD (state machine)
- Lock / Unlock / Stale / Revalidate / Approve
- Context packaging for tasks

### Execution Layer (ECC-owned)
- Implementation workflows: /plan, /tdd, /verify, /code-review, /build-fix, /refactor-clean, /e2e, etc.
- Language reviewers: /go-review, /python-review
- Multi-workflows: /multi-plan, /multi-execute, /multi-workflow

---

## Default Commands (OS) → Execution (ECC)

> Note: OS commands listed here will be implemented as wrappers.
> For v0.1, wrappers may call ECC commands directly after preparing context.

| OS Command (Proposed) | Purpose | Preconditions (Gates) | Maps to ECC Command | Notes |
|---|---|---|---|---|
| `/vision-init` | Create vision doc from template | none | (OS-only) | Creates `product/vision.md` |
| `/roadmap-init` | Create roadmap doc from template | vision exists (recommended) | (OS-only) | Creates `product/roadmap.md` |
| `/prd-init <R*>` | Create modular PRD folder (index + sections) | none | (OS-only) | Creates `product/prd/<Release>/...` |
| `/prd-next` | Continue PRD section-by-section | PRD exists | (OS-only) | Reads PRD index, selects next draft/stale section |
| `/lock <section>` | Lock PRD section + bump minor | section is draft/reopened | (OS-only) | Updates index + section header |
| `/unlock <section>` | Reopen locked section | section locked | (OS-only) | Marks reopened; dependent sections may become stale after relock |
| `/revalidate <section>` | Close stale without content change | section stale | (OS-only) | No bump if no text change |
| `/approve` | Approve PRD + bump major | no draft/stale/reopened | (OS-only) | Marks PRD Approved (major) |
| `/decompose` | Turn PRD → milestones/tasks | PRD Approved | (OS-only for now) | Future: generate `engineering/tasks/` |
| `/task <id>` | Load task context + execute | task exists; PRD Approved (recommended) | `/plan` or `/tdd` (ECC) | Wrapper picks ECC workflow based on task type |
| `/exec-plan` | Run planning workflow with packaged context | task exists | `/plan` (ECC) | OS ensures repo map + task scope included |
| `/exec-tdd` | Run TDD workflow with packaged context | task exists | `/tdd` (ECC) | Default for implementation tasks |
| `/exec-verify` | Verify acceptance for task/release | task exists or PRD AC exists | `/verify` (ECC) | Use after changes; connects to Acceptance Criteria |
| `/exec-review` | Code review workflow | PR exists or diff ready | `/code-review` (ECC) | Wrapper can attach PRD refs + DoD |
| `/exec-fix` | Fix build/test failures | failing output exists | `/build-fix` (ECC) | Wrapper can attach logs + env |
| `/exec-refactor` | Cleanup/refactor after feature | task exists | `/refactor-clean` (ECC) | Wrapper enforces “no behavior change unless specified” |
| `/exec-e2e` | Run/guide e2e validation | e2e tests exist | `/e2e` (ECC) | Wrapper ties to ACs |
| `/checkpoint` | Snapshot before big change | none | `/checkpoint` (ECC) | Keep ECC behavior |

---

## When to use ECC directly (Power Mode)

Use ECC commands directly when:
- You need a specific workflow not yet wrapped by OS.
- You are doing exploratory engineering with no product gating required.
- You are in a mature project and executing a narrow dev-only task.

Examples:
- `/test-coverage`
- `/update-docs`
- `/go-test`
- `/multi-execute`
- `/orchestrate`
- `/sessions`

Recommended rule:
- If the command affects user-facing behavior, prefer OS wrappers so PRD/Task context is attached.

---

## Gate Policy (v0.1)

- Execution commands SHOULD have task context.
- Release-level execution (e.g., verifying the release) SHOULD require PRD Approved.
- For small fixes/chores, OS wrappers may allow execution with a minimal task note.

---

## Compatibility
- ECC is vendored as a submodule pinned to a tag.
- OS should track which ECC tag it supports in `versions/CHANGELOG.md`.
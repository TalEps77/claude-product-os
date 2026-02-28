CONSUMER FLOW EXAMPLE — Claude Product OS (v0.1)

Goal:
Demonstrate the intended day-to-day usage for a team using:
- Vision/Roadmap
- Release PRD (modular)
- Task specs
- Execution wrappers (ECC-assisted)

------------------------------------------------------------
0) Setup (project repo consuming OS)
------------------------------------------------------------
- Add OS as a submodule in the project repo (branch stable)
- Init submodules:
  $ git submodule update --init --recursive

------------------------------------------------------------
1) Start a new release (R0_MVP)
------------------------------------------------------------
1. Create product docs:
   - /vision-init
   - /roadmap-init

2. Initialize Release PRD:
   - /prd-init R0_MVP

3. Write PRD section-by-section:
   - /prd-next R0_MVP
   - (answer questions, draft section)
   - /lock R0_MVP <section_id>
   Repeat until all sections are locked.

4. Check status:
   - /status R0_MVP

5. Approve release:
   - /approve R0_MVP

------------------------------------------------------------
2) Decompose PRD into tasks
------------------------------------------------------------
- /decompose R0_MVP
Result:
- engineering/tasks/T-001.md ... (task specs)

------------------------------------------------------------
3) Execute a task (developer workflow)
------------------------------------------------------------
1. Start from a task spec:
   - /task T-001
   Choose:
   - Plan (ECC /plan) if unclear
   - TDD (ECC /tdd) for implementation
   - Verify (ECC /verify) for AC validation

2. Or use direct wrappers:
   - /exec-plan T-001
   - /exec-tdd T-001
   - /exec-verify T-001
   - /exec-review T-001
   - /exec-fix T-001
   - /exec-refactor T-001
   - /exec-e2e T-001

------------------------------------------------------------
4) Notes
------------------------------------------------------------
- ECC commands remain available for power users.
- Preferred path is OS commands to ensure PRD/task context is attached.
- If PRD changes after approval:
  - /unlock R0_MVP <section_id> → edit → /lock
  - revalidate stale sections
  - re-approve if needed

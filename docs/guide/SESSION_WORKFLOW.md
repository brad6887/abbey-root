# Session Workflow

## Purpose

Abbey Root development follows a consistent workflow that keeps implementation, documentation, planning, and project history synchronized.

The workflow emphasizes capturing information once and allowing long-term planning documents to be updated through a dedicated review process rather than during every development session.

The long-term goal is for nearly every step of this workflow to be guided or automated by the Abbey toolkit.

---

# Guiding Principles

Every development session should:

- Begin with an understanding of the current project state.
- Focus on one primary objective.
- Capture completed work once.
- Reduce manually maintained documentation.
- Leave the repository in a clean, reproducible state.
- Improve both the project and the workflow used to build it.

---

# Session Lifecycle

A complete development session follows this workflow:

```text
abbey session
        ↓
Review project context
        ↓
Review due recurring reviews
        ↓
Define session objective
        ↓
Complete focused work
        ↓
Maintain session update
        ↓
abbey-end
        ↓
Review generated session update
        ↓
Validate project
        ↓
Commit
        ↓
Push
        ↓
abbey-review
        ↓
Update planning documents
```

Session updates become the operational record of completed work.

Planning documents become the strategic view of the project.

---

# Start of Session

## 1. Synchronize the Repository

Synchronize the local repository with the remote repository.

Confirm:

- Repository is healthy.
- Working tree is clean.
- Current branch is correct.

Future versions of `abbey session` should perform these checks automatically.

---

## 2. Review Project Context

Review current project context.

This may include:

- `PROJECT_STATUS.md`
- `NEXT.md`
- Recent session updates
- Current roadmap
- Outstanding backlog items

Future versions of `abbey session` should summarize this information automatically.

---

## 3. Review Recurring Work

Determine whether recurring project reviews are due.

Examples include:

- AI News review
- Documentation audit
- Dependency review
- Infrastructure review
- Backup verification

Future versions of `abbey session` should recommend overdue reviews automatically.

---

## 4. Define Session Goals

Choose one primary objective.

Examples:

- Documentation
- Automation
- AI
- Website
- Infrastructure
- Networking

Secondary objectives are acceptable, but the session should have one clear focus.

---

# During the Session

Development should proceed in small, logical steps.

Recommended practices:

- Commit related work together.
- Keep changes focused.
- Update documentation alongside implementation.
- Record lessons learned immediately.
- Prefer automation over manual work.
- Avoid editing generated documentation directly.

---

# Session Updates

Maintain a session update throughout the development session.

The session update is the primary record of completed work.

Typical sections include:

- Summary
- Completed
- Future Direction
- Impact
- Lessons Learned

Long-term planning documents should not require continual edits during development.

Instead, capture information once in the session update.

---

# End of Session

## 1. Run `abbey-end`

The long-term purpose of `abbey-end` is to gather project information and prepare the session for completion.

Potential inputs include:

- Git status
- Git diff
- Journal entry
- Session metadata
- Existing session update

Future versions should generate a draft session update for review.

---

## 2. Review the Session Update

Confirm the session update accurately describes:

- Completed work
- Design decisions
- Lessons learned
- Future work

The session update becomes the source document for future planning updates.

---

## 3. Validate the Project

Run appropriate validation.

Examples:

- `abbey doctor`
- Website build
- Test suite
- Documentation validation

---

## 4. Commit

Create a single logical commit representing the completed work.

---

## 5. Push

Synchronize the completed work with the remote repository.

---

## 6. Run `abbey-review`

`abbey-review` examines completed session updates and recommends updates to long-term planning documents.

Examples include:

- `PROJECT_STATUS.md`
- `NEXT.md`
- `BACKLOG.md`
- `ROADMAP.md`

Planning documents become summaries of accumulated project knowledge rather than being edited throughout each development session.

---

# Future Automation

The Abbey toolkit will gradually automate this workflow.

## `abbey session`

Future capabilities:

- Verify repository health.
- Summarize project status.
- Recommend recurring reviews.
- Display planning summaries.
- Recommend next work.
- Resume previous sessions.

---

## `abbey-end`

Future capabilities:

- Analyze Git changes.
- Generate session update drafts.
- Suggest journal updates.
- Recommend commit messages.
- Run validation.
- Build the website.

---

## `abbey-review`

Future capabilities:

- Reconcile session updates into planning documents.
- Detect stale planning information.
- Recommend backlog changes.
- Generate project summaries.
- Update project metrics.

---

# Continuous Improvement

The workflow itself is part of the project.

Every improvement should reduce repetitive work while preserving understanding.

The objective is not simply to automate development, but to create a development environment that continuously improves its own workflow through documentation, automation, and AI.

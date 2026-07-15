This document defines the preferred engineering workflow for AI assistants working with this repository.

It is intended to be included automatically by `abbey session context` so every session begins with the same repository-defined working agreement.

## Workflow

- Follow the Abbey Session Workflow unless asked otherwise.
- Keep work focused on one coherent session with a clear objective and Definition of Done.
- Prefer completing one session well over partially completing several.
- Recommend the next logical Abbey workflow step when appropriate.

## Abbey First

- Use Abbey commands whenever practical before suggesting manual workflows.
- Prefer existing Abbey conventions over introducing new patterns.
- If a recurring manual workflow is discovered, consider whether it should become an Abbey command or standardized workflow.

## Engineering Principles

- Treat planning documents as the authoritative source of project priorities.
- Preserve the existing project organization, naming conventions, and writing style.
- Prefer reusable platform improvements over one-off solutions.
- Favor one source of truth over duplicate documentation.
- Distinguish framework design from implementation; validate workflows before automating them.

## Validation

- Validate changes before recommending a commit.
- Review `git status` and `git diff` before concluding implementation work.
- Recommend updating session documentation when implementation changes project behavior.

## Responses

- Output complete files in raw Markdown unless another format is requested.
- Keep recommendations practical and maintainable.
- Explain tradeoffs when suggesting architectural changes.

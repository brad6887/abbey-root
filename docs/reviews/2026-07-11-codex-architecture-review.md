 ## Project purpose

  Abbey Root is both:

  1. A working Linux home-lab and publishing platform.
  2. The reference implementation of the reusable “Abbey Framework.”

  It combines infrastructure-as-code, automation, documentation, AI-assisted workflows, a developer CLI, and BradCooke.com. The larger goal is to turn lessons from this repository into
  conventions and tooling reusable by future projects.

  The clearest introduction is docs/guide/START_HERE.md. The broader technical vision is in docs/guide/ARCHITECTURE.md.

  ## Major directory structure

  - ansible/ — Infrastructure automation: inventory, host/group variables, playbooks, and roles. It is intended to be the authoritative source for managed infrastructure.
  - config/ — Project configuration, notably the CLI metadata in config/cli/cli.yml.
  - content/ — Canonical Markdown content for BradCooke.com: journal entries, pages, projects, posts, and published plant profiles.
  - working/ — Rich source workspaces that precede publication. Plant workspaces contain facts, history, story drafts, inventories, source PDFs, photos, and metadata.
  - site/ — Astro application that turns repository content into BradCooke.com. Routes and components are under site/src/.
  - tools/ — The developer toolkit. tools/bin/ contains the newer unified CLI commands; top-level tools/abbey-* files are mostly older standalone utilities.
  - scripts/ — Supporting implementation, particularly the Python metadata renderer and shell initialization helpers.
  - docs/ — Project knowledge divided by purpose: guide, planning, framework, architecture, reference, runbooks, generated documents, ADRs, and session updates.
  - .abbey/ — Ignored generated AI/context state.
  - homepage/ — Homepage dashboard configuration.
  - docker/ — Present as a responsibility boundary, but currently sparse.
  - generated/, inventory/, journal/, planning/, and reference/ — Currently empty or legacy-looking top-level directories; their active equivalents generally live under docs/ or content/.

  The intended layout is documented in docs/reference/DIRECTORY_LAYOUT.md.

  ## Development workflow

  The prescribed session lifecycle is:

  Review → Define → Build → Validate → Document → Capture → Commit → Review

  A session is supposed to begin with:

  abbey session
  abbey status

  The developer reviews PROJECT_STATUS.md, NEXT.md, recent journal entries, and pending session updates, then chooses one focused objective. During implementation, documentation evolves
  alongside code. At the end, appropriate validation and builds are run, a session update captures the work, and the result becomes one logical commit.

  Longer-term, proposed abbey-end and abbey-review commands will turn session updates into structured planning changes. Those commands are documented as future capabilities, not current
  implementations.

  For website work:

  abbey site start
  abbey site build
  abbey site publish --dry-run
  abbey site publish

  Publishing is deliberately guarded: both source and production repositories must be clean; the site is rebuilt; rsync changes are previewed; the production CNAME is preserved; and
  commit/push require confirmation. That workflow is implemented in tools/bin/abbey-site.

  The complete intended lifecycle is in docs/guide/SESSION_WORKFLOW.md.

  ## CLI architecture

  The public entry point is tools/bin/abbey. It is a small Bash dispatcher:

  abbey <command>
        │
        └── tools/bin/abbey-<command>

  Commands currently dispatched include:

  - help
  - doctor
  - status
  - session
  - journal
  - site
  - plant
  - knowledge
  - context
  - ai
  - version

  Most implementations are focused Bash programs. Larger commands such as plant, site, ai, and context own their subcommand handling. doctor and status use an especially clean plug-in-
  like structure: numbered checks are sourced from tools/doctor/checks/ and tools/status/checks/.

  CLI descriptions, categories, usage, examples, and site subcommands are centralized in config/cli/cli.yml. scripts/abbey_cli.py consumes that metadata to render both interactive help
  and docs/generated/CLI_REFERENCE.md.

  There is also an older CLI layer: executable top-level scripts such as abbey-build, abbey-docs, abbey-validate, and abbey-git-sync. These remain useful, but are not consistently exposed
  through the unified dispatcher.

  ## Documentation conventions

  Documentation is treated as a product feature and an automation interface, not incidental prose.

  The main categories are:

  - guide/ — How to use and work with the project.
  - planning/ — Current state and future priorities.
  - framework/ — Standards meant to apply to every Abbey-style repository.
  - architecture/ — How Abbey Root itself is designed.
  - reference/ — Stable facts, schemas, naming, and conventions.
  - runbooks/ — Repeatable operational procedures.
  - generated/ — Machine-produced facts and references; never edit manually.
  - session-updates/ — Operational records of completed sessions.
  - adr/ — Durable architectural decisions.

  Important conventions include:

  - One authoritative source for each fact.
  - Generate discoverable facts instead of manually duplicating them.
  - Keep human-written documents focused on reasoning, decisions, procedures, and direction.
  - Prefer small, focused documents.
  - Use stable heading structures in planning documents because automation and AI will parse them.
  - Use uppercase filenames for major hand-written documents and lowercase names for generated documents.
  - Store journal entries as content/journal/YYYY/YYYY-MM-DD-short-title.md.
  - Treat journal history as append-only except for factual corrections.
  - Use short, direct commit messages describing the completed change.

  The best overview is docs/README.md, supplemented by docs/guide/DOCUMENTATION.md and docs/reference/PLANNING_SCHEMA.md.

  ## Especially well designed

  - The repository has a strong information architecture. “Guide vs framework vs architecture vs reference vs planning” is a meaningful separation that should scale well.
  - The distinction between framework standards and this repository’s implementation is excellent. It prevents project-specific behavior from quietly becoming a universal rule.
  - The CLI metadata model is sound: one YAML source generates both help and reference documentation.
  - The doctor and status check directories make new diagnostics easy to add without enlarging the command entry points.
  - The plant pipeline has a useful editorial model: rich canonical working material is separated from concise published Markdown.
  - The website publishing command has unusually good operational safeguards, including clean-tree checks, dry runs, CNAME preservation, diff validation, and explicit confirmations.
  - Session updates provide a sensible bridge between daily development and slower-moving strategic planning.
  - The project is candid about future capabilities and marks several architecture documents as drafts rather than pretending the design is finished.

  ## Confusing or incomplete areas

  - The project currently has two CLI generations. tools/bin/abbey-* implements the unified CLI, while top-level tools/abbey-* scripts use an older command and documentation model. There
    are even two status implementations and two CLI documentation generators.

  - The CLI standard promises universal build, validate, and publish commands, and the user guide presents them as expected commands, but the dispatcher and CLI metadata do not currently
    expose them. Equivalent standalone or nested commands exist only partially.

  - Metadata drives help text, but not dispatch or implementation. Adding a command still requires synchronizing YAML, the dispatcher, and a command file. Thus the metadata is not yet the
    complete source of truth implied by the documentation.

  - abbey_cli.py resolves config/cli/cli.yml relative to the current working directory, whereas most Bash commands calculate the repository root robustly. Help generation may therefore
    depend on where abbey is invoked.

  - The Python dependency on PyYAML is not represented by an obvious root dependency or bootstrap manifest.
  - There is no root README.md; onboarding begins under docs/. That fits the internal philosophy but makes initial repository discovery less obvious.
  - Several top-level empty directories overlap active paths under docs/ and content/, making it unclear whether they are reserved framework placeholders or abandoned layout remnants.
  - content/README.md lists several content areas that do not exist and describes an older-looking structure.
  - Documentation has some workflow drift. Older guidance says to edit planning documents during development and create journal entries at session end; newer guidance says to capture work
    once in session updates and reconcile planning later.

  - The formal planning schema’s required headings do not match the current PROJECT_STATUS.md and NEXT.md structures, despite stating that headings are stable automation interfaces.
  - PROJECT_STATUS.md was last updated July 8, while code, content, and session updates continue through July 11. That illustrates the freshness problem the proposed review automation is
    intended to solve.

  - The site-specific guidance requests Astro’s background development mode, while abbey site start independently manages the process with nohup, pgrep, and pkill. Those two process-
    management conventions could conflict.

  - Some generated artifacts live under tracked docs/generated/, while other generated state belongs in ignored .abbey/; the distinction is defensible but could be stated more directly.

  Overall, the repository has a notably thoughtful target architecture and strong documentation instincts. Its main difficulty is not poor design but visible transition: the standards
  have advanced faster than all legacy tooling, schemas, and guides have been reconciled.

  I made no file changes, created no files, and made no commits. The working tree was clean when inspected.

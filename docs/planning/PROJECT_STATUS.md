# Abbey Root Project Status

Last Updated: 2026-08-10

---

# Project Snapshot

## Project Phase

Abbey Framework Foundation

## Overall Health

🟢 Healthy

## Primary Goal

Develop Abbey Root into the reference implementation of the Abbey Framework—a self-documenting, AI-assisted engineering platform where documentation, automation, tooling, and AI share a common source of truth.

## Current Focus

- Abbey Framework
- Universal developer toolkit
- Metadata-driven engineering
- Project-aware automation
- AI-assisted workflows
- BradCooke.com

---

# Current Session

## Session Theme

Abbey Framework Foundation

## Objectives

- Standardize the Abbey Framework.
- Establish universal CLI behavior.
- Introduce framework standards.
- Improve project onboarding.
- Continue reducing manually maintained documentation.

## Session Status

Completed

---

# Overall Status

## Platform

- Infrastructure stable.
- Documentation architecture established.
- Framework standards established.
- Developer toolkit expanding.
- Metadata-driven CLI implemented.
- Website actively developed.
- AI integration increasing.

## Development Direction

- Complete the Abbey engineering workflow.
- Continue reducing manual maintenance.
- Expand the Abbey Framework.
- Increase project-aware automation.
- Expand AI-assisted engineering.
- Continue technical publishing.

---

# Immediate Priorities

- Validate the completed Abbey Research observation-candidate workflow through
  a real non-canonical research run.
- Expand onboarding documentation.
- Continue CLI standardization.
- Evaluate shared CLI libraries.
- Continue developing BradCooke.com.

---

# Infrastructure

## Status

🟢 Healthy

## Completed

- Proxmox operational.
- Linux virtual machines deployed.
- VM templates established.
- Infrastructure managed through Git and Ansible.
- 2.5 Gb networking deployed.
- Passwordless SSH configured.
- Ansible Vault configured.
- `sites01` is the Ansible-managed static-hosting platform, using native nginx
  and release-based `/srv/www` directories with atomic active-release links;
  focused provisioning is validated as idempotent.
- Bread Pitt has a validated, isolated internal staging site on `sites01`,
  using dedicated release-based nginx hosting and internal DNS while its
  production deployment remains unchanged.
- Proxmox backup storage recovered and successful VM backups validated.
- Nightly automated Open WebUI backups implemented and validated for the AI Worker, including remote verification.
- Infrastructure health and Ansible connectivity validated across managed hosts.
- Read-only Ansible infrastructure health review completed across managed hosts; the detected AI Worker issue remains under investigation.
- Operational issue tracking established under `docs/issues/`.
- `abbey lab check` reports host, NVIDIA, Ollama, and inventory-driven expected
  network-interface health across managed hosts while retaining read-only,
  timeout-protected, failure-tolerant operation; interface expectations are
  opt-in per host and use stable MAC identities, with `sites01` as the first
  declared host.
- Platform-role architecture established around stable responsibilities, with `edge01` designated as the Infrastructure Services Platform.
- Tailscale-based remote access through `ubuntu-dev01` is documented in the remote-access architecture, validated by Abbey Doctor, and supported by inventory-driven reachability checks for managed hosts.
- Technitium DNS on `edge01` is the authoritative `home.arpa` service; Ansible configures all six managed Linux hosts to use it, forward and reverse records are complete, short-name search-domain resolution is validated lab-wide, and external forwarding remains operational.
- Homepage recovery is managed through the authoritative Ansible role, with `edge01` integrated into managed inventory and the operational dashboard.
- Umami and PostgreSQL are deployed on `ubuntu-dev01` through a dedicated Ansible role with encrypted secrets, private database networking, health checks, check-mode safety, idempotency validation, and documented backup and recovery procedures.
- Ansible reproducibly manages a bounded Abbey shell configuration across managed Linux hosts while preserving distribution- and host-specific `.bashrc` content and optional `~/.bashrc.local` customization.

## Current Work

- Map apartment Ethernet wall jacks.
- Document the completed data closet.

---

# Abbey Framework

## Status

🟢 Foundation Established

## Completed

- Project Standard.
- CLI Standard.
- Metadata-driven CLI.
- Universal CLI commands.
- Framework documentation.
- Guide documentation.
- Power Infrastructure framework adoption.
- Safe default `abbey init PATH` project bootstrap with dry-run support,
  optional Git initialization, generated metadata and workflow documents,
  destination protection, result validation, and no automatic commit or remote.
- Evidence-based framework adoption guidance defines a bounded adoption and
  certification path for new and established repositories using validated
  Abbey Root, Power Infrastructure, and Bread Pitt workflows.

## Current Focus

- Project bootstrap framework.
- Shared engineering standards.
- Universal developer experience.
- Framework adoption across repositories.
- Shared CLI libraries.

---

# Developer Toolkit

## Status

🟢 Active Development

## Current Capabilities

- `abbey doctor` uses centralized, platform-aware checks supporting macOS and
  Linux, validates effective Git author name and email, reports their
  configuration sources, and runs infrastructure-specific storage, host,
  backup, and remote-access checks only when the active project declares the
  infrastructure capability, while internal-DNS checks independently require
  the internal-DNS capability
- `abbey validate` provides canonical, read-only, project-aware repository
  validation for metadata, configured paths, planning structure, Git, and
  whitespace; when Abbey Root is active, it additionally checks consistency
  among CLI metadata, dispatcher routes, command implementations, and generated
  command documentation
- `abbey status` reports deterministic local counts for toolkit commands,
  website pages, journal entries, and documentation files; an absent open task
  in `NEXT.md` is informational and does not prevent later checks from running
- `abbey git audit` and `abbey git sync` verify and apply one Ansible-owned Git
  identity, fast-forward-only pull policy, automatic pruning, GitHub SSH
  transport and published host-key trust, and normalized remotes for existing
  Abbey Root and Bread Pitt checkouts without cloning, pulling, pushing, or
  changing working files; the workflow is deployed and audit-clean across five
  Linux hosts and the separately inventoried macOS workstation
- `abbey session`
- `abbey end` follows the active project's required, event-driven, or optional
  journal policy and recognizes completed, reviewed reconciliation-only commits
  without requiring a new journal entry; branches without a configured upstream
  reach normal completion checks without crashing
- `abbey review` as a deterministic, read-only pre-commit reviewer that summarizes current-session work and recommends the next workflow step
- `abbey version`
- `abbey project show [--project PATH] [--config PATH]` reports normalized
  toolkit, active-project, and configuration context through the shared
  project resolver; malformed metadata, missing projects, and paths escaping
  the active project fail closed, and newly initialized projects explicitly
  disable toolkit configuration defaults
- `abbey init PATH` creates a minimal independent Abbey project while keeping
  framework implementation shared; core commands discover the active project
  through `.abbey/project.yml`, which also owns journal policy, project
  capabilities, and review validation commands
- `abbey journal` handles help and invalid options safely and supports explicit `--title` input
- `abbey ai`
- Metadata-driven `abbey ai decide` discovery and help
- `abbey ai decide` resolves shared libraries and decision definitions from the
  toolkit while preserving active-project configuration, knowledge, additions,
  and overrides
- `abbey ai decide ai-worker-candidate` reviews authoritative planning
  documents and recommends one bounded AI Worker research or implementation
  candidate, including a proposed future worker-command concept, inputs,
  deliverables, validation, evidence, and the remaining human boundary; it
  does not dispatch work or imply that the proposed command already exists
- Core Abbey workflows distinguish toolkit implementation from active-project
  data and are validated for external projects and macOS system Bash 3.2
- `abbey session update` generation from the standard repository template
- `abbey session capture` derives one deterministic slug from the session title,
  stores it as session metadata, reuses it for the session update and journal
  filenames, supports explicit overrides, and remains backward-compatible with
  positional slugs; journal creation follows the active project's required,
  event-driven, or optional policy, and created journal/session pairs record
  reciprocal relative paths with conflict-safe, idempotent repair on rerun
- `abbey review` strictly validates changed session metadata and reports
  untouched historical metadata debt without blocking unrelated work
- Recurring review definitions and completed occurrence artifacts are stored
  separately, and recurring review discovery reports the latest occurrence
  matching each definition; the public recurring-review workflow executes the
  read-only Documentation Audit by reusing documentation validation and reports
  findings separately from execution failure; the implemented Infrastructure
  Review reuses `abbey doctor` and separates actionable findings from expected
  operational warnings
- Recurring review due dates are evaluated centrally, and `abbey session`
  surfaces due reviews informationally without blocking normal session work
- `abbey lab`
- `abbey ssh audit` and `abbey ssh sync` provide validated, idempotent SSH key auditing and managed synchronization while preserving unrelated authorized keys
- `abbey research status` deterministically discovers formal research artifacts, resolves their relationships, and reports complete chains and legacy provenance without modifying repository state
- `abbey next` with a deterministic, explainable recommendation engine that uses unreconciled session updates as freshness evidence, suppresses backlog work recently completed in unreconciled sessions, strengthens candidates matching explicit session-update Next Steps, reports conflicts between recent session evidence and planning documents, and generates Definitions of Done from the selected recommendation using tailored criteria where available and a deterministic fallback otherwise
- `abbey next` validates the canonical six-section `NEXT.md` contract, while
  `abbey next init` safely creates a valid project-aware template without
  overwriting an existing file
- `abbey backlog refresh` maintains deterministic complete, pending, and total
  statistics in a bounded generated block for Abbey Root and external Abbey
  projects, with read-only freshness checks in `abbey review` and `abbey end`
- `abbey site build` and `abbey site publish [--dry-run]` resolve explicit
  active-project site configuration, support npm-generated and direct-static
  artifacts, and fail closed without safe publishing configuration; publishing
  performs bounded post-push live-site verification that follows redirects and
  requires a final HTTP 2xx response
- Metadata-driven CLI help
- Generated CLI reference
- `abbey docs generate` and `abbey docs check` deterministically manage the
  CLI reference, legacy command-header reference, and canonical durable
  documentation index without mutating files during freshness checks; the
  index uses stable categories, titles, and relative links while excluding
  session updates and research collections with dedicated discovery workflows
- `abbey plant validate <slug>` checks Plant Model structure, metadata,
  canonical role and documentation photo references, and undocumented or
  orphaned supported photographs; missing references fail, preserved but
  undocumented photographs warn, XMP and AppleDouble artifacts are excluded,
  and focused regression coverage protects every current validation rule
- `abbey plant new <slug> --name NAME --type TYPE` atomically creates a
  template-backed canonical workspace, imports initial photographs and adjacent
  XMP sidecars, refuses overwrites, and validates the resulting scaffold
- The single-plant `abbey plant update <slug>` workflow has been validated
  end-to-end through real use, including dry-run preview, canonical history and
  status updates, image selection, validation, publishing, and site generation
- The worksheet-driven multi-plant update workflow has been validated through
  real use, with reviewable preparation and dry-run stages followed by
  canonical updates, Plant Model validation, and publication; preparation
  warns and skips plant/date groups already present in history while apply
  retains duplicate-date validation as a final safety boundary
- The August 9 workflow processed sixteen photographs into reviewed updates and
  generated profiles for eleven Orchid Rescue plants; subsequent toolkit work
  replaced separate serialized publication invocations with the supported
  `abbey plant publish-batch` command, which serializes plants and stops on
  failure; individual publication uses isolated transactional staging,
  per-plant locking, and manifest-owned cleanup, generates deterministic
  content-versioned image URLs, and discovers NVM-managed npm for reliable
  non-interactive site workflows
- The complete new-plant onboarding and publication-verification lifecycle,
  together with proven individual, batch, and manual plant-maintenance
  procedures, is consolidated in one operational Plant Website Updates runbook
- `abbey plant publish <slug>`
- `abbey image select <entity> <item> --role <role>` provides portable,
  project-configured image-role selection with active-project validation,
  fail-closed local configuration, explicit-only toolkit fallback, resolved
  preflight reporting, safe cancellation, atomic metadata updates, and
  cross-project isolation; `abbey plant hero <slug>` is the first
  domain-specific adopter
- `abbey media rename-exports <directory> [--dry-run]` provides
  project-configured caption and capture-date naming for image/XMP pairs,
  validates complete batches before staged renames, records deterministic
  original-to-published mappings in a generated manifest, ignores macOS
  AppleDouble files while genuine missing-caption validation remains
  fail-closed, and supports plant and Bread Pitt-style workflows; `abbey plant
  rename-exports` remains a compatibility wrapper
- `abbey media publish <workflow> [--dry-run]` generates project-configured,
  privacy-safe public derivatives from prepared intake manifests, verifies
  derivative provenance and source integrity, installs outputs and a
  deterministic publication manifest transactionally, and leaves unchanged
  reruns untouched across Abbey Root and Bread Pitt-style projects
- `abbey site validate` provides a read-only publication gate for
  project-owned media manifests and required routes; it verifies active-project
  ownership, safe public destinations, source and derivative fingerprints,
  image facts, privacy flags, and generated route artifacts, and runs
  automatically during `abbey site build` and `abbey site publish`
- `abbey plant index <slug>` selects a dedicated plant index image, records it
  as canonical `photos.index` metadata, publishes it at a stable path, and
  preserves current-image then hero-image fallback when no index image is set
- Structured content workspace validation and publishing
- Canonical plant source-to-publication workflow
- `abbey session review` validated across varied historical sessions as a read-only, evidence-based reconciliation assistant; historical session reconciliation is complete and refinement remains usage-driven
- Canonical metadata normalized across historical session updates, making previously invisible sessions discoverable by the reconciliation workflow
- Abbey context generation, knowledge snapshots, and documentation health checks use `docs/planning/PROJECT_STATUS.md` as the authoritative project status
- `abbey session context` generates readable, upload-ready repository context
  for AI-assisted sessions, includes repository-defined AI guidance, and adds
  generated CLI architecture and visible registered-command summaries from
  toolkit-owned `config/cli/cli.yml`; toolkit and active-project roots are
  reported explicitly, and the workflow remains failure-tolerant in Abbey Root
  and external Abbey projects
- The obsolete universal `abbey build` workflow has been retired; current
  help and documentation expose only supported, purpose-specific commands such
  as `abbey docs`, `abbey review`, and `abbey site build`.
- External Abbey projects inherit toolkit-owned Abbey AI endpoint and model
  defaults while retaining project-specific tracked and local overrides.

## Current Focus

- Project-aware workflows.
- Documentation automation.
- Self-documenting development.
- Framework consistency.

---

# Website

## Status

🟡 Active Development

## Completed

- Project pages.
- Journal platform.
- Dynamic routing.
- Previous/next navigation.
- Documentation publishing workflow.
- The content-driven Contact page publishes `hello@bradcooke.com` for project,
  plant, and website correspondence without exposing private contact details.
- Production Astro site published to GitHub Pages at bradcooke.com through `abbey site publish`.
- BradCooke.com publishes production-domain-restricted analytics to the self-hosted Umami service, with the live tracker, public script, HTTPS path, and a real external pageview validated.
- Museum of Dumb Ideas established with OmeletYouFinish.com as its first completed exhibit.
- Museum of Dumb Ideas expanded with the Jeep Incident as its second completed
  exhibit and a reusable photographic artifact gallery.
- Canonical plant source-to-publication workflow.
- Orchid Rescue routes complete profiles by collection ID, directs draft entries to a shared Coming Soon page, and excludes drafts from generated profile routes.
- The completed Orchid Rescue search, indexing, image-metadata, and navigation
  audit verified 10 published profiles, 216 referenced public images, and zero
  broken internal links; it also documented missing discovery output, weak
  image semantics, shallow cross-profile navigation, and GPS EXIF in 44 public
  images as evidence-backed follow-up work.
- Doctor Robert generated into the Astro site as the Plant Model reference implementation.
- Helter Skelter generated into the Astro site as the second validated Plant Model profile.
- Bungalow Bill generated into the Astro site as the third Orchid Rescue profile.
- Honey Pie generated into the Astro site as the fourth complete Orchid Rescue profile from a canonical Plant Model workspace.
- Something's canonical plant workspace and generated Orchid Rescue profile,
  including its 21-photo recovery timeline, are complete; live deployment of
  the generated site changes remains pending.
- Rocky Raccoon's canonical workspace and generated Orchid Rescue profile are
  complete, including verified plant-specific content and sanitized public
  image derivatives produced through the `abbey plant new` onboarding workflow.

## Current Work

- Publish documentation journal entries.
- Expand technical content.
- Improve reusable components.
- Continue publishing and refining the live BradCooke.com site.
- Evaluate the completed Stage 1 BradCooke.com hosted build validation through
  normal pull-request use before implementing the separately approved Stage 2
  production workflow.

## Current Capabilities
- Orchid Rescue plant collection
- Plant content model
- Version-controlled publishing workspace
- Generated plant profiles and selected public images from canonical workspaces
- Plant histories can generate referenced timeline photographs with stable public filenames while sidecars and unreferenced source material remain private
- Shared plant-page styling provides consistent presentation for timeline photographs with differing dimensions
- Accepted publishing automation architecture selects GitHub-hosted build
  validation and a separate manually approved production workflow while
  preserving `abbey site publish` as the supported publication path during
  staged implementation
- Path-scoped GitHub-hosted validation installs the locked BradCooke.com
  dependency graph, builds the Astro site, and verifies its generated entry
  point for pull requests and changes to `main` without production credentials

---

# AI Platform

## Status

🟡 Rapid Development

## Current Capabilities

- Open WebUI.
- Local model experimentation.
- `abbey ai`.
- Metadata-driven AI decision framework with reusable decision definitions, structured history, and cross-model comparison validated through practical use.
- `abbey ai decide easy-win` identifies low-risk, one-session work that fully
  closes exact pending parent checkboxes, includes their required child scope,
  excludes optional expansion, expects no new backlog entries, and reports the
  verified positive net backlog reduction.
- `abbey ai decide risk-reducer` identifies bounded, one-session work that materially reduces a concrete operational or workflow risk while requiring repository review.
- `abbey ai decide workflow-friction` identifies costly recurring manual work, separates evidence from assumptions, and classifies bounded improvements as Abbey commands, standardized workflows, or local fixes.
- `abbey ai decide backlog-leverage` identifies one focused session whose shared outcome completes or materially advances the largest coherent set of documented backlog items.
- `abbey ai decide blocker` identifies pending backlog items that are not
  independently actionable, names their unfinished prerequisite checkboxes,
  and requires repository review when planning evidence cannot prove the
  dependency.
- `abbey research run` provides a reusable Ollama research runner with preserved raw output; AI-assisted normalization, `abbey research sanitize`, and deterministic artifact validation support canonical artifacts before human review; `abbey research validate-review` verifies machine-readable human-review decisions, corpus fingerprints, source identifiers, and complete exact citation text; deterministic stratified sampling, human-reviewed annotation, and Wilson intervals now support measured prevalence claims; the reusable Voice Analysis research artifact framework defines artifact types, metadata, lifecycle, provenance, evidence-chain traceability, and review-manifest scope; broader deterministic Markdown normalization remains in development.
- `abbey research create --type observation` provides a controlled,
  project-neutral candidate workflow with fingerprinted inputs, inspectable run
  manifests, immutable raw output, retained failure states, staged
  normalization and sanitization, structural validation, and review-ready
  output outside canonical research directories.
- Deterministic corpus filtering excludes anchored `Mobile uploads Place:` location metadata while preserving authored content and the existing Voice Analysis evidence conclusions.
- The full-corpus observation-discovery workflow reviews deterministic corpus batches without automatic promotion and validates each machine-readable manifest’s corpus identity, batch membership, source identifiers, and exact citation text.
- `abbey research discover` provides repository-owned, resumable batch discovery with raw-output preservation, deterministic validation, validated-result reuse, candidate aggregation, and a pending human-review scaffold.
- The complete 165-candidate quoted-language review passed exact-citation validation and produced draft EVID-004.
- The fourth formal research chain reached VAL-004 and was provisionally supported within the tested 2009–2021 Facebook population.
- The first bounded Facebook Voice Model was created and evaluated as a research draft; both free-generation runs altered supplied facts, so it is not approved for free generation.
- VOICE-MODEL-001 version 3 is approved for fact-locked application within the tested Facebook scope, with deterministic validation, semantic verification, and human proposition review required.
- The review-gated upstream fact-lock extraction workflow is operational; fully automatic extraction remains unapproved, and semantic verification remains advisory.
- `abbey research fact-lock propose` and `validate` are operational, review-gated capabilities that neither approve nor apply fact locks.
- `abbey research fact-lock review` provides validated, read-only human-review summaries without approving or modifying artifacts.
- `abbey research fact-lock review-init` creates validated, hash-bound, all-undecided review scaffolds without approval or promotion.
- Public `abbey research fact-lock` commands validate completed reviews, route rejected proposals through revision, and promote only exact hash-bound, human-approved proposals.
- `abbey research voice apply` operationalizes approved Facebook-scoped fact locks with deterministic output validation.
- The deterministic voice-eligible Facebook corpus workflow, chronological batching, and human-reviewed cross-period deadpan analysis expanded EVID-001 and VAL-001 to Version 2 with Medium confidence within Facebook; frequency, post-2021 continuity, and writing-format diversity remain limited.
- EVID-002 and VAL-002 were expanded across the full voice-eligible Facebook corpus; the result remains `Provisionally Supported`, with confidence increased from Low to Medium within Facebook writing.
- EVID-003 and VAL-003 were expanded to Version 2 across recurring Facebook narrative clusters, remaining `Provisionally Supported` with Medium confidence.
- AI benchmark planning.
- AI technology review process.

## Current Focus

- Project-aware AI.
- AI evaluation framework.
- Documentation assistance.
- Planning assistance.
- Knowledge freshness.
- Workflow assistance.

---

# Documentation

## Status

🟢 Active

## Completed

- Documentation architecture.
- Guide system.
- Framework documentation.
- Metadata-driven CLI documentation.
- Planning document standards.
- Planning schemas.
- Session update framework.

## Current Focus

- Metadata-driven documentation.
- Planning document automation.
- Session reconciliation.
- AI project context.
- Self-documenting workflows.
- Onboarding documentation.

---

# Recent Accomplishments

- Published the Abbey Root Astro site to GitHub Pages at bradcooke.com using the guarded `abbey site publish` workflow.
- Established the Abbey Framework.
- Defined Project and CLI standards.
- Introduced metadata-driven CLI architecture.
- Added universal `abbey version`.
- Generated CLI reference documentation.
- Created onboarding documentation.
- Adopted the framework within Power Infrastructure.
- Continued improving project-aware workflows.
- Validated Abbey project bootstrap and core external-project workflows through
  real use in Bread Pitt, including knowledge, context, and AI decision runs.

---

# Current Challenges

- Completing the end-to-end Abbey workflow.
- Reducing manually maintained documentation.
- AI project awareness.
- Reducing publish-preview noise.

---

# Next Major Milestones

## Near Term

- Validate the completed Abbey Research observation-candidate workflow through
  a real non-canonical research run.
- Expand onboarding documentation.
- Improve `abbey-doctor`.
- Continue metadata-driven documentation.
- Publish BradCooke.com updates.

## Long Term

- Reusable engineering framework.
- Project bootstrap platform.
- Project-aware development environment.
- Self-documenting platform.
- AI evaluation framework.
- Self-validating infrastructure.
- AI-assisted publishing.
- Reproducible Infrastructure-as-Code platform.

---

# Project Metrics

## Current

- `abbey status` automatically reports:
  - Toolkit commands.
  - Website pages.
  - Journal entries.
  - Documentation files.

## Future

Generate automatically:

- Virtual machines.
- Docker hosts.
- Containers.
- Ansible roles.
- Playbooks.
- Broader documentation statistics.
- Planning summaries.
- AI evaluation reports.
- Framework adoption metrics.

---

# Project Health

## Infrastructure

🟢 Healthy

## Documentation

🟢 Active

## Abbey Framework

🟢 Foundation Established

## Automation

🟢 Active Development

## Developer Toolkit

🟢 Active Development

## Website

🟡 Active Development

## AI Platform

🟡 Rapid Development

## Overall

🟢 Excellent Progress

---

# Notes

This document follows the schema defined in:

`docs/reference/PLANNING_SCHEMA.md`

Section names should remain stable to support future Abbey toolkit commands, documentation generation, and AI-assisted workflows.

Abbey Root serves as the reference implementation of the Abbey Framework. Other repositories are expected to adopt and extend the framework while preserving the shared engineering standards and developer experience.

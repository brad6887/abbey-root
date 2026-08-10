# Abbey Root Backlog

<!-- BEGIN GENERATED BACKLOG STATUS -->
> **Backlog Status:** 167 complete · 277 pending · 444 total
<!-- END GENERATED BACKLOG STATUS -->

This document contains work that has been identified but is not necessarily scheduled.

Items are captured here until they are promoted to the roadmap, completed during a development session, or determined to no longer be necessary.

The backlog is intentionally broad and serves as the project's working inventory of ideas, improvements, and future capabilities. However, each backlog entry should describe a finite, verifiable outcome that can eventually be completed or removed.

Ongoing practices, design principles, and general areas of improvement belong in project guidance, status documentation, or workflow policy. When those practices reveal specific work, that work should be added to the backlog as a concrete, finishable entry.

---

## High Priority

- [x] Design and implement the first safe `abbey init` project bootstrap command.
- [x] Create `abbey end` session workflow.
- [x] Establish `abbey session review` as a practical review workflow.
- [x] Establish generated documentation as the preferred alternative to manually maintained summaries.
- [x] Design secure remote access to Abbey Root for working away from home.
- [ ] Document and photograph the completed data closet layout.
- [x] Publish Doctor Robert as the reference Plant Model profile.
- [x] Connect the Plant Model to BradCooke.com.
- [x] Add generated Abbey CLI architecture and registered-command summaries to `abbey session context`.
- [x] Use unreconciled session updates as recommendation evidence.
- [x] Suppress work completed in unreconciled session updates.
- [x] Extract candidate follow-up work from session-update Next Steps.
- [x] Report conflicts between recent session updates and planning documents.

---

## Abbey Framework

- [x] Define and document the initial Bread Pitt domain model in a focused Bread Pitt project session.
- [x] Design and implement the first safe `abbey init`.
- [x] Establish shared Abbey project and configuration libraries for portable core commands.
- [x] Extract additional shared CLI behavior only when repeated implementations establish a stable reusable contract.
- [x] Define the standard universal CLI commands and their expected behavior.
- [ ] Implement and document a canonical framework-level project validation workflow.
- [ ] Create a framework adoption guide based on the validated Abbey Root, Power Infrastructure, and Bread Pitt workflows.
- [x] Create the first safe default Abbey project template through `abbey init`.
- [ ] Define whether Abbey needs multiple selectable project templates after additional project types validate the requirement.
- [ ] Define and document the Abbey Framework versioning and compatibility policy.
- [x] Establish the initial Abbey Framework documentation foundation.
- [x] Define the standard documentation structure for Abbey-style repositories.
- [ ] Verify and document documentation-standard conformance in Power Infrastructure.
- [x] Add repository-defined AI session guidance to Abbey Root.
- [x] Include repository-defined AI session guidance in newly initialized Abbey projects.
- [ ] Adopt repository-defined AI session guidance in Power Infrastructure.
- [ ] Create a framework migration guide based on at least one completed migration of an existing repository.
- [x] Improve `abbey next` NEXT.md parsing and validation.
- [x] Document the required NEXT.md structure.
- [x] Support normal Markdown headings and body content in NEXT.md.
- [x] Report clear errors when required NEXT.md sections are missing.
- [x] Add `abbey next init` to create a valid NEXT.md template without overwriting an existing file.
- [x] Make `abbey site build` and `abbey site publish` project-aware and fail closed
  - Detect the active Abbey project from the current working directory.
  - Load site build and publishing configuration from that project.
  - Support projects with direct static artifacts such as Bread Pitt's `site/` directory.
  - Refuse to publish when the active project has no explicit publishing configuration.
  - Never fall back to Abbey Root or `bradcooke.com` from an external project.
  - Display the resolved project, source directory, target, domain, and deployment method before making changes.
  - Add regression coverage proving Bread Pitt cannot invoke the BradCooke.com publishing path.
  - Validate both Abbey Root and Bread Pitt publishing workflows independently.

## Publishing Workflow Evolution

### Required Before Bake002

- [ ] Define and document the canonical Bread Pitt bake content contract, including authoritative ownership of bake metadata, narrative, photo metadata, hero selection, recipe relationships, generated artifacts, and published derivatives.
- [ ] Generate `media-intake.json` deterministically from canonical `photos.yml` data, mark it as generated, detect stale output, and add focused regression coverage.
- [ ] Render Bread Pitt bake routes from canonical `bake.yml` and `story.md` content through a shared Astro template instead of maintaining hand-written per-bake narrative markup.
- [ ] Add a Bread Pitt bake validation command that checks schemas, intake and publication manifests, source and derivative images, hero selection, recipe linkage, route uniqueness, representative images, and generated-artifact consistency.
- [ ] Prototype a safe, idempotent Bread Pitt bake scaffold that creates only canonical inputs and required directories, refuses to overwrite an existing bake, and reports every created path.
- [ ] Add and document an explicit `abbey site restart` command with regression coverage and project-aware process handling.
- [ ] Capture the validated Bake001 source-to-publication workflow as a Bread Pitt runbook and record the canonical, generated, and published ownership decisions before authoring Bake002.

### Reusable Abbey Follow-up

- [ ] Add guided media workflow management with `abbey media workflow create`, `list`, `show`, and `validate`, including safe handling of existing configuration.
- [ ] Remove the plant command's legacy partial-install fallback after normal installations and external projects have adopted `abbey media`.
- [ ] Improve unknown media-workflow diagnostics to name the missing workflow, list configured workflows or explain that none exist, suggest close matches, identify the configuration file, and show the corrective command.
- [ ] Add layered `abbey media validate` support for schema, references, source assets, derivatives, manifests, fingerprints, privacy requirements, and publication readiness.
- [ ] Preserve and document canonical working media, published derivatives, and manifests as separate pipeline layers, with manifests treated as versioned contracts rather than authoring surfaces.
- [ ] Expand publication validation monotonically through composable schema, reference, asset, publication, and presentation checks.

### Defer Until Multiple Publishing Cycles

- [ ] Evaluate a generic project-defined content command or extension contract only after bake and at least one additional domain establish a reusable abstraction.
- [ ] Evaluate one-command content publication orchestration only after scaffold, generation, validation, media publication, site build, and preview commands are stable independently.
- [ ] Evaluate development-server freshness fingerprints and configurable visual-publication policies after repeated publishing cycles establish reliable stale-state and presentation requirements.

## External Project Portability

- [x] Make `abbey session capture` resolve `abbey-journal` from the Abbey toolkit root instead of the active project.
- [x] Make `abbey review` resolve `abbey_session_metadata.py` from the Abbey toolkit root.
- [x] Make infrastructure-specific `abbey doctor` checks conditional on project capabilities.
- [x] Add configurable journal policy for initialized projects, including event-driven or optional journals.
- [x] Make `abbey review` suggest validation commands appropriate to the active project type.
- [x] Verify `abbey backlog refresh` works correctly in external Abbey projects.
- [ ] Review toolkit/project-root handling in `abbey-site`, `abbey-lab`, and `abbey-ssh`.
- [ ] Make `abbey status` capability-aware for external projects.
- [ ] Review Abbey-specific wording in external-project knowledge, context, and AI output.
- [ ] Add `abbey journal --template <name>` support.
- [ ] Allow projects to define a default journal template in Abbey configuration.
- [ ] Add a built-in project-introduction journal template for entries such as "This Is Bread Pitt."
- [ ] Preserve the current journal template as the default for existing projects.
- [ ] Validate configured journal template names and report missing templates clearly.
- [ ] Add regression coverage for built-in, configured, and explicitly selected journal templates.

## Abbey Session Workflow Improvements

- [x] Improve session capture workflow by creating session updates and journal entries through a guided process.
- [x] Validate required metadata for new or modified session updates while reporting pre-existing historical debt without blocking unrelated commits.
- [x] Fix `abbey journal` argument handling so `--title` and reserved commands like `help` behave consistently.
- [x] Add session-aware state to reduce manual slug and filename management.
- [ ] Add reliable artifact export workflow for generated research documents and other Abbey artifacts.
- [x] Investigate why `abbey end` incorrectly requires a journal entry for reconciliation-only commits and add regression coverage.

---

## Infrastructure

- [x] Make `.bashrc` Ansible-managed.
- [x] Configure hostname resolution between lab systems.
- [x] Complete `docs/architecture/EDGE01_COMMISSIONING.md` as a reusable commissioning runbook based on the actual `edge01` deployment.
- [x] Validate the completed `edge01` commissioning runbook against the deployed host and record any corrections or missing steps.
- [x] Deploy Technitium DNS on `edge01` as the authoritative `home.arpa` service and validate it from `ubuntu-dev01`.
- [x] Complete extended validation and lab-wide rollout of internal DNS.
- [x] Rotate the Wi-Fi credential exposed during DNS troubleshooting.
- [ ] Establish reliable internal access to public proxied services through Abbey DNS.
- [ ] Finalize the infrastructure naming strategy and add friendly DNS service records.
- [ ] Enhance `abbey-status` with Docker health, disk usage, and service summaries.
- [ ] Create `abbey infrastructure review`.
- [ ] Manage infrastructure systemd units and automation scripts from the Abbey repository.
- [ ] Deploy infrastructure services through Ansible.
- [ ] Automate restore validation for backups.
- [ ] Validate the documented Umami restore procedure in a safe non-production recovery test before formalizing database backup automation.
- [ ] Implement infrastructure patch management workflow.
- [ ] Define recurring infrastructure maintenance windows.
- [ ] Expand infrastructure monitoring dashboards.
- [ ] Add infrastructure backup failure alerting.
- [ ] Investigate and document Nginx Proxy Manager configuration.
- [ ] Configure the existing Nginx Proxy Manager instance to proxy `abbeyroot.com` to `sites01`.
- [ ] Evaluate moving public ingress from `ubuntu-dev01` to `edge01`.
- [ ] Reserve `192.168.1.84` for the `sites01` MAC address `BC:24:11:02:02:84`.
- [ ] Rotate the Ansible credentials and Umami secrets exposed during the `sites01` provisioning session before public exposure.
- [ ] Deploy the real `abbeyroot.com` build to the validated release structure on `sites01`.
- [ ] Automate deployment of ai-worker01 shell environment through Ansible.
- [ ] Document apartment network wall jack locations.
- [ ] Label structured wiring cabinet.
- [ ] Create network diagram.
- [ ] Keep a spare USB Ethernet adapter for lab recovery.
- [x] Evaluate VPN, Tailscale, and Cloudflare Tunnel for remote connectivity.
- [x] Design and implement secure remote access to the lab.
- [ ] Refine the remote-access architecture document.
- [ ] Create a Remote Operator Guide.
- [ ] Validate remote access from an external network.
- [ ] Design `abbey operator add`.
- [ ] Evaluate consolidating the Ansible Control Node onto `ubuntu-dev01`.
- [ ] Expand `abbey lab` with additional infrastructure diagnostics.
- [ ] Resolve and document the `ai-worker01` NVIDIA/Ollama reboot hang.
- [ ] Evaluate running `abbey lab` remotely from development workstations.
- [ ] Investigate the persistent `systemd-networkd-wait-online.service` warning reported by `abbey lab check`.
- [ ] Preserve `site.yml` as the full Ansible convergence entry point.
- [ ] Add focused Ansible playbooks for routine service deployments.
- [ ] Define the universal Abbey host baseline.
- [ ] Split the current `common` role into package, Git configuration, and Abbey shell responsibilities.
- [ ] Apply Ansible roles according to declared host purpose.
- [ ] Review and document the time-synchronization policy for Debian appliances.
- [ ] Validate check-mode behavior when package installation is followed by service management.

---

## Project-Aware Recommendations

- [x] Create `abbey next`.
- [x] Build deterministic project recommendation engine.
- [x] Generate session objectives from planning documents.
- [x] Generate Definitions of Done.
- [x] Explain recommendation reasoning.
- [x] Detect recently completed work.
- [ ] Move recommendation-specific objectives and completion criteria into structured recommendation metadata.
- [ ] Replace the next identified broad-token recommendation match with a documented project-state relationship and regression fixture.
- [ ] Expand recommendation-specific Definitions of Done beyond the current Recommendation Engine types.
- [ ] Add a clean-repository recommendation scenario to the `abbey next` regression suite.
- [ ] Define and implement stale-`NEXT.md` reporting in `abbey next`: warn when its review date exceeds a defined threshold without discarding or reducing `NEXT.md` authority or changing recommendation scores solely because of age.
- [ ] Add an explicit neglected-project-area factor to the recommendation algorithm with deterministic regression coverage.
- [ ] Add optional AI recommendation mode.

## Developer Toolkit

### Completed

- [x] Generate CLI help from metadata.
- [x] Generate CLI reference documentation.
- [x] Create `abbey-doctor`.
- [x] Create `abbey-status`.
- [x] Create `abbey-session`.
- [x] Create `abbey-journal`.
- [x] Create `abbey-version`.
- [x] Create `abbey site publish` with guarded preview and `--dry-run` support.
- [x] Create `abbey plant validate`.

### Toolkit Evolution

- [x] Retire the legacy `tools/abbey-build` workflow and remove stale `abbey build` references from current documentation.
- [ ] Add repository consistency checks.
- [ ] Create `abbey-tree`.
- [ ] Standardize tool output formatting and colors.
- [ ] Standardize artifact-creation command output so commands report the path of every generated file.
- [ ] Add automated toolkit regression testing.
- [ ] Run the real public-image derivative helper suite with ExifTool and ImageMagick for final certification.
- [x] Add regression tests for `abbey plant validate`.
- [ ] Expand `abbey site` commands.
- [ ] Implement fail-closed internal static-site release deployment
  - Load the source directory, build output, staging hostname, target host,
    remote release root, and deployment method from the active project's
    explicit configuration.
  - Refuse to deploy when the active project has no internal staging target.
  - Display the resolved project, source, artifact, host, domain, release
    directory, and deployment method before making changes.
  - Build and validate the static artifact before transferring it.
  - Create uniquely identified, immutable release directories.
  - Verify transfer integrity and required release files before activation.
  - Validate remote extraction dependencies before beginning deployment.
  - Never change the active `current` symlink when transfer, extraction, or
    validation fails.
  - Atomically activate a validated release while preserving the previous
    release for rollback.
  - Provide an explicit rollback operation.
  - Apply correct ownership and SELinux contexts to deployed content.
  - Validate the staging health endpoint, home page, representative nested
    route, and static assets after activation.
  - Add regression coverage proving a failed release cannot replace the active
    site and one project cannot deploy into another project's release tree.
  - Validate independent staging deployments for Abbey Root and Bread Pitt.
- [ ] Add `abbey site preview`.
- [ ] Add `abbey site deploy-check`.
- [ ] Reduce noise in `abbey site publish` previews.
- [ ] Display the Abbey Root commit hash in `abbey site publish`.
- [x] Add live-site verification to `abbey site publish`.
- [ ] Make `abbey site publish` fail immediately when `git push` fails and verify the expected deployed source and production revisions instead of accepting any HTTP 2xx response.
- [x] Add project metrics to `abbey-status`.
- [ ] Add documentation validation to `abbey-doctor`.
- [ ] Add network health checks to `abbey-doctor`.
- [x] Add Git author identity checks to `abbey-doctor`.
- [ ] Verify bridge-ports references an existing interface.
- [ ] Report negotiated Ethernet link speed.
- [ ] Verify gateway connectivity.
- [ ] Verify Internet connectivity.
- [ ] Detect missing or replaced network interfaces.
- [ ] Evaluate shared validation helpers after additional model validators exist.
- [x] Design `abbey review` as a deterministic, read-only pre-commit reviewer that summarizes current-session work and recommends the next workflow step.

### Plant Toolkit

- [x] Define the Plant Model.
- [x] Create a reusable plant workspace template.
- [x] Review the Plant Model against the reusable template and Doctor Robert reference implementation.
- [x] Create `abbey plant validate`.
- [x] Publish Doctor Robert through the Plant Model as its first reference profile.
- [x] Create `abbey plant new`.
- [x] Complete Rocky Raccoon's canonical workspace with real photographs and verified plant-specific story, history, inventory, and photo metadata before publication.
- [ ] Create `abbey plant inventory`.
- [ ] Add configured plant photo inbox discovery that filters AppleDouble, XMP, temporary, and unsupported files.
- [ ] Create plant photo metadata workflow.
- [ ] Reject repeated `--photo` options in `abbey plant update` until multi-photo updates are supported.
- [ ] Add multi-photo `abbey plant update` support with explicit current-photo selection.
- [ ] Add a supported plant revision workflow for existing dated observations.
- [x] Design a reviewable multi-plant prepare, review, apply, and publish workflow.
- [ ] Add regression coverage for UTC-safe Orchid Rescue date formatting.
- [ ] Add historical backfill support to `abbey plant update` so older observations are inserted chronologically without replacing the current photo, changing the current status, or moving the plant's latest-updated date backward, with regression coverage for each behavior.
- [x] Create plant publishing workflow.
- [ ] Update the Doctor Robert inventory checklist.
- [ ] Add AI-assisted plant workspace review.
- [ ] Add plant workspace consistency checks.
- [ ] Validate referenced photographs against the plant workspace.
- [ ] Detect undocumented and orphaned plant photographs.
- [ ] Generate current inventory summaries from verified observations.
- [ ] Evaluate command refactoring after additional `abbey plant` subcommands are implemented.

### Workflow

- [ ] Expand `abbey-session` with project-aware recommendations.
- [ ] Display planning summaries during `abbey session`.
- [x] Create `abbey end`.
- [ ] Evaluate future `abbey end` enhancements through practical usage.
- [x] Implement `abbey review`.
- [x] Add generated backlog completion statistics with workflow freshness checks.
- [ ] Evaluate generated backlog status and workflow messages through normal Abbey sessions before broader planning-refresh automation.
- [x] Restrict **Required Reconciliation** to changes directly required by the reviewed session.
- [ ] Report unrelated planning inconsistencies as **Planning Drift** rather than **Required Reconciliation**.
- [ ] Consider separating **Planning Drift** from **Incidental Drift**.
- [ ] Consider adding a concise **Reconciliation Scope** summary near the top of `abbey session review` output.
- [ ] Preserve a small set of unreconciled historical session updates as regression fixtures.
- [ ] Default reusable Abbey artifacts, including Codex prompts, session updates, journals, and planning documents, to raw Markdown in fenced code blocks unless another format is requested.
- [x] Normalize canonical metadata for historical session updates so they are discoverable by the reconciliation workflow.
- [x] Implement `abbey session update`.
- [ ] Associate journal entries with active Abbey sessions.

### AI Integration

- [x] Detect stale AI knowledge before running `abbey ai`.
- [x] Offer to rebuild AI knowledge automatically when project context changes.
- [ ] Add structured content consistency review.
- [ ] Add photo metadata validation assistance.
- [ ] Add inventory summarization assistance.
- [ ] Add draft publishing assembly from canonical source material.
- [ ] Audit Experiment 001 evidence documents for mismatched source identifiers, dates, and quoted posts before using them in hypotheses or the Voice Model.
- [x] Implement a fact-locked Voice Model application workflow that locks immutable propositions, rejects unsupported factual changes, and reruns the eight evaluation scenarios.
- [x] Design and evaluate an upstream fact-extraction step that converts new writing requests into reviewable fact-lock manifests.

### Abbey AI

- [x] Add discoverable `abbey ai decide` help and decision listing generated from decision-definition metadata.
- [x] Add `abbey ai decide easy-win` to identify low-risk, one-session work that delivers durable value and meaningfully reduces the backlog.
- [ ] Implement `abbey ai evaluate` across installed local models.
- [ ] Validate decision metadata before execution.
- [ ] Add decision and engine versioning to decision-history artifacts.
- [ ] Add consensus reporting across multiple models.
- [x] Add `abbey ai decide risk-reducer` to identify bounded work that materially reduces operational or workflow risk.
- [x] Add `abbey ai decide workflow-friction` to identify costly recurring manual work and classify the bounded Abbey improvement it warrants.
- [x] Add `abbey ai decide backlog-leverage` to identify one focused session whose outcome clears or materially advances the largest coherent set of backlog items.
- [ ] Evaluate `abbey ai decide backlog-leverage` through normal use in the canonical Ubuntu environment and confirm that its coverage map remains conservative.
- [ ] Validate `abbey ai decide workflow-friction` through normal use from the canonical Ubuntu environment and assess its classification and recurrence-evidence rubric before expansion.
- [ ] Evaluate `abbey ai decide risk-reducer` through normal use before expanding its rubric.
- [x] Re-run the complete Abbey AI regression suite on the Linux development host.
- [x] Fix the documented macOS portability failures in the Abbey AI test suite.
- [ ] Expand the AI decision library with additional engineering workflows.

### Abbey Research

#### Status and Visibility

- [x] Design deterministic `abbey research status` reporting using the completed Voice Analysis artifact chains as reference implementations.
- [x] Define Abbey Research artifact-discovery rules.
- [x] Define metadata-driven Abbey Research relationship mapping.
- [x] Define complete, incomplete, broken, and orphaned research-chain states.
- [x] Document the expected read-only `abbey research status` output.
- [x] Review the `abbey research status` design before implementation.
- [ ] Refine `abbey research status` for invalid, incomplete, duplicate, and broken-relationship states, with synthetic fixtures and architecture-defined severity and exit-code behavior.

#### Validation and Workflow

- [x] Design a staged canonical research artifact-creation workflow with explicit human review and promotion boundaries.
- [x] Implement `abbey research create --type observation` with run manifests, immutable raw output, and review-ready candidates.
- [ ] Exercise `abbey research create --type observation` with a real non-canonical research input and verify the resulting run workspace and candidate.
- [ ] Implement explicit review records and canonical artifact promotion.
- [ ] Add a separate interactive discovery-review command that consumes the generated scaffold and requires complete human decisions.
- [x] Design and evaluate a read-only `abbey research fact-lock review` experience before exposing approval.
- [x] Implement `abbey research fact-lock review-init` to create an empty, hash-bound review-manifest scaffold without pre-approval.
- [ ] Add evidence candidate generation with deterministic source identifier, date, quotation, score, and summary verification.
- [ ] Add hypothesis and validation candidate workflows that require promoted parent artifacts.
- [x] Build VAL-004 by deriving the exact holdout from REVIEW-004 and EVID-004 and evaluating the thresholds defined by HYP-004.
- [ ] Complete deterministic research Markdown normalization using universally safe operations.
- [ ] Add normalization safety tests proving semantic content is preserved.
- [ ] Orchestrate research generation, normalization, sanitization, and validation without coupling the workflow to Voice Analysis.
- [ ] Evaluate a configurable Abbey Research validation framework.

#### Provenance and Methodology

- [ ] Add research artifact provenance metadata for the model, prompt version, and corpus fingerprint.
- [x] Build and review the complete corpus candidate set for quoted language as a comic framing device and decide whether it warrants OBS-004.
- [ ] Test AI-generated observations against additional Voice Analysis research patterns.
- [ ] Refine the Voice Analysis methodology based on artifact validation results.

---

## Self-Documenting Platform

- [x] Generate toolkit command reference.
- [x] Generate project metrics.
- [ ] Generate documentation index.
- [x] Generate host inventory.
- [x] Generate Docker inventory.
- [x] Generate service inventory.
- [x] Generate Ansible inventory documentation.
- [ ] Generate Architecture Decision Record index.
- [ ] Eliminate manually maintained generated documentation.
- [ ] Expand metadata-driven documentation generation.
- [ ] Build metadata-driven documentation generation using planning schemas.
- [ ] Generate planning summaries from session updates.
- [x] Generate project-aware AI context from planning documents.
- [x] Build bounded deterministic `abbey docs generate` and `abbey docs check`
  orchestration for the CLI and command references.
- [ ] Isolate Ansible-derived document rendering and add deterministic freshness checks before expanding `abbey docs`.
- [ ] Make planning documents the primary interface for Abbey toolkit commands.
- [ ] Expand stable machine-readable planning document schemas.
- [ ] Build project metadata APIs.
- [ ] Define reusable content models for personal projects.
- [ ] Build source-to-publication transformation workflows.
- [ ] Validate structured working content before publication.

---

## Documentation

- [ ] Complete the onboarding guide series.
- [ ] Create `WORKFLOW.md`.
- [ ] Create `PHILOSOPHY.md`.
- [ ] Expand the lab architecture documentation.
- [ ] Create framework documentation index.
- [ ] Build document update workflow.
- [ ] Design automated document review workflow.
- [ ] Document the canonical `working/` workspace purpose and conventions.
- [ ] Document the principle: model information before building tools.
- [ ] Document the principle: humans record observations; automation manages state.
- [ ] Develop lightweight architecture diagrams for Abbey systems (network, publishing, AI, workflows, remote access) and establish a standard diagram style.

---

## Recurring Reviews

- [x] Define recurring review registry architecture.
- [x] Implement recurring review definition storage.
- [x] Implement recurring review discovery.
- [x] Define recurring review occurrence storage.
- [x] Surface due reviews during `abbey session`.
- [ ] Support AI news reviews.
- [x] Support documentation audits.
- [x] Support infrastructure reviews.
- [ ] Support dependency reviews.
- [ ] Support backup verification.
- [ ] Support security reviews.

---

## BradCooke.com

### Content

- [x] Flesh out the Contact page.
- [x] Create the Power Infrastructure project page.
- [ ] Add additional project pages.
- [ ] Begin writing technical articles.
- [x] Publish Abbey Root journal entries.
- [ ] Create JournalCard component.
- [ ] Create JournalHeader component.
- [x] Create date formatting helper.
- [x] Generate Doctor Robert as the first complete Orchid Rescue profile in the Abbey Root Astro site.
- [x] Generate Doctor Robert's story, current status, and selected photographs into the Abbey Root Astro site.
- [ ] Create reusable plant profile and timeline components.
- [x] Prototype the publishing path from `working/plants/` to Astro.
- [x] Validate the plant publishing workflow before creating additional profiles.
- [ ] Update the remaining orchids using the validated single-plant `abbey plant update` workflow.
- [ ] After Martha My Dear's bloom cycle, repot her and check for a hidden nursery plug.
- [x] Publish the next named Orchid Rescue profile.
- [x] Add Phal McCartney to the documented orchid collection.
- [ ] Create a separate future section for bromeliads.
- [ ] After the remaining plant profiles are published, review selected plant narratives, photograph order and placement, and the relationship between photographs and timeline text.

### Components

- [ ] Improve `ProjectHeader`.
- [ ] Refactor `ProjectHeader` to accept explicit props.
- [ ] Create Technology Badge component.
- [ ] Create Timeline component.
- [ ] Create Callout component.
- [ ] Create PlantProfile component.
- [ ] Create PlantStatus component.
- [ ] Create PlantTimeline component.
- [ ] Create PlantPhotoGallery component.

### Styling

- [x] Move CSS into `site/src/styles/`.
- [x] Create `global.css`.
- [x] Create `navigation.css`.
- [x] Create `layout.css`.
- [x] Create `project.css`.
- [ ] Improve mobile responsiveness.
- [ ] Add light/dark mode.
- [x] Create reusable presentation styles for Markdown-generated plant timeline images, including consistent sizing, containment, centering, spacing, aspect-ratio preservation, maximum height, and border radius.
- [ ] Extract the next repeated plant-profile or timeline style into a named reusable stylesheet or component.

### Publishing

- [ ] Establish BradCooke.com search-discovery foundations: configure the
  production site URL, generate a sitemap and robots file, emit canonical URLs,
  and define indexing behavior for draft and utility pages.
- [ ] Generate RSS feed.
- [ ] Add search.
- [ ] Define `docs/` vs `content/` publishing boundaries.
- [ ] Define `working/` vs published content boundaries.
- [ ] Remove remaining `build-website.sh` references.
- [ ] Create BradCooke.com publishing runbook.
- [ ] Publish the Abbey Root Operations Manual.
- [x] Configure production deployment of the Abbey Root Astro site to GitHub Pages.
- [x] Transfer or configure `bradcooke.com` for the Abbey Root Astro deployment.
- [x] Create dynamic journal detail pages.
- [ ] Group journal entries by year.
- [x] Add previous/next journal navigation.
- [x] Create a plant source-to-publication pipeline.
- [x] Generate stable public filenames for published plant images.
- [ ] Use meaningful filenames for published images where practical.
- [x] Preserve original plant photographs separately from published derivatives.

### Discovery and Quality

The completed
[`2026-08-01 Orchid Section Search and Navigation Audit`](../session-updates/2026-08-01-orchid-section-search-and-navigation-audit.md)
is the supporting evidence for the Orchid Rescue items below.

- [x] Remove GPS and other private location metadata from generated public plant
  images while preserving canonical originals and documented provenance.
- [ ] Improve Orchid Rescue index and profile titles and descriptions from
  canonical plant facts and rescue narratives.
- [ ] Generate unique photograph-specific alt text and semantic captions from
  canonical plant history without breaking stable public image URLs.
- [ ] Improve Orchid Rescue index-card context and add derived cross-profile
  navigation.
- [ ] Perform a site-wide technical SEO audit after the search-discovery
  foundation is implemented.
- [ ] Audit structured data and social-sharing metadata across representative
  BradCooke.com page types.
- [ ] Audit accessibility across shared templates and representative content
  pages.
- [ ] Audit image delivery, page performance, and Core Web Vitals.
- [ ] Configure and verify Google Search Console ownership, sitemap submission,
  and indexing after the discovery foundation is published.
- [ ] Review analytics filtering and measurement practices so owner update checks
  do not dominate traffic analysis.
- [ ] Audit content structure and internal linking across projects, journal
  entries, museum exhibits, Orchid Rescue profiles, and future practical
  articles.

---

## AI

### Platform

- [ ] Expand ai-worker01 into the AI experimentation platform.
- [ ] AI-assisted metadata generation.
- [ ] AI-assisted documentation generation.
- [ ] AI-generated summaries.
- [ ] AI-generated internal links.
- [ ] AI-assisted image alt text.
- [ ] AI-assisted publishing.
- [ ] AI-generated session summaries.
- [ ] AI-assisted project history.
- [x] Establish project-aware AI context and recommendations.
- [x] Implement AI-powered "What should I work on next?" recommendations through `abbey next`.
- [ ] AI documentation review.
- [ ] AI session recap generation.
- [x] Define AI knowledge sources.
- [x] Track AI knowledge freshness.
- [x] Build AI knowledge freshness validation.
- [x] Generate project-aware AI context.
- [x] Automate AI knowledge rebuilds.
- [ ] Complete the next scheduled AI technology review and capture its accepted findings.
- [ ] AI-assisted Plant Model validation.
- [ ] AI-assisted plant history consistency review.
- [ ] AI-assisted plant inventory summaries.
- [ ] AI-assisted selection of milestone photographs.
- [ ] AI-assisted assembly of draft plant pages from verified source material.

### Evaluation

- [ ] Create AI evaluation framework.
- [ ] Define evaluation prompt suite.
- [ ] Record expected concepts.
- [ ] Create `abbey ai test`.
- [ ] Score AI responses.
- [ ] Track evaluation history.
- [ ] Compare models.
- [ ] Generate evaluation reports.
- [ ] Evaluate new AI models using real Abbey workflows.
- [ ] Evaluate AI performance on structured content validation.
- [ ] Evaluate AI accuracy when summarizing plant histories from source files.

---

## Automation

- [x] Add path-scoped GitHub Actions build validation for BradCooke.com pull
  requests and `main` using `npm ci` and the deterministic Astro build.
- [ ] Add manually dispatched, environment-approved BradCooke.com production
  deployment with least-privilege cross-repository access and safeguards
  equivalent to `abbey site publish`.
- [x] Select staged GitHub-hosted Actions over self-hosted automation for
  BradCooke.com builds and deployment.
- [x] Automate plant workspace validation before publishing.
- [x] Automate plant image metadata checks, including rejection of GPS and other
  private location metadata in public outputs.
- [x] Automate creation of optimized, privacy-safe published image copies while
  preserving canonical originals.
- [x] Automate generation of plant profile pages from canonical source material.

---

## Communications

- [ ] Evaluate custom email hosting.
- [ ] Create `brad@bradcooke.com`.
- [ ] Create `contact@bradcooke.com`.
- [ ] Design AI-assisted email workflows.
- [ ] Generate weekly project summaries.
- [ ] Investigate automated status reports.
- [ ] Design end-of-session AI summary email.

---

## Abbey Doctor

- [x] Manage one reproducible Git identity, fast-forward pull policy, GitHub SSH
  transport, and existing Abbey repository remote configuration through
  Ansible-backed audit and synchronization commands.
- [x] Validate `abbey git audit` and `abbey git sync --check` from the Ansible
  control host against every managed server.
- [x] Add the Mac as a separately inventoried managed workstation and validate
  the Git workflow without exposing it to Linux-only playbooks.
- [x] Confirm or create a DHCP reservation for the Mac at `192.168.1.70`.
- [ ] Validate the unchanged Abbey Doctor path on a managed Linux host.
- [ ] Add verbose mode.
- [ ] Add quiet mode.
- [ ] Add metadata-driven required document list.
- [ ] Add documentation freshness checks.
- [ ] Add backup freshness checks.
- [ ] Add Proxmox VM status.
- [ ] Add Docker container checks.
- [ ] Add Homepage/NPM/Uptime Kuma HTTP checks.
- [x] Add DNS checks.
- [ ] Add Ansible Vault detection.
- [ ] Add role-aware checks.
- [ ] Add JSON output.
- [ ] Add restore-test tracking.
- [x] Check whether Git `user.name` is configured.
- [x] Check whether Git `user.email` is configured.
- [x] Report the effective Git configuration source.

---

## Request Intake Framework

- [ ] Adopt GitHub Issues as Abbey Root's initial request-tracking system.
- [ ] Create GitHub issue templates for Abbey Root requests.
- [ ] Define GitHub labels for request status, type, priority, and framework area.
- [ ] Document how requests link to Abbey session updates.
- [ ] Document how completed requests are referenced from commits and session updates.
- [ ] Evaluate the GitHub Issues workflow after it has been used for a defined trial period.
- [ ] Decide whether self-hosted issue tracking warrants further investigation after the GitHub Issues trial.

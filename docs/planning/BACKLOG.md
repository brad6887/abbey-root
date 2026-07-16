# Abbey Root Backlog

This document contains work that has been identified but is not necessarily scheduled.

Items are captured here until they are either promoted to the roadmap, completed during a development session, or determined to no longer be necessary.

The backlog is intentionally broad and serves as the project's working inventory of ideas, improvements, and future capabilities.

---

## High Priority

- [ ] Design `abbey init` project bootstrap command.
- [x] Create `abbey end` session workflow.
- [ ] Create `abbey-review` planning reconciliation workflow.
- [ ] Design `abbey infrastructure review` workflow.
- [ ] Continue eliminating manually maintained documentation.
- [ ] Design secure remote access to Abbey Root for working away from home.
- [ ] Document and photograph the completed data closet layout.
- [ ] Publish additional BradCooke.com content.
- [x] Publish Doctor Robert as the reference Plant Model profile.
- [x] Connect the Plant Model to BradCooke.com.

---

## Abbey Framework

- [ ] Design `abbey init`.
- [ ] Create shared CLI libraries.
- [ ] Standardize universal CLI commands.
- [ ] Create framework validation.
- [ ] Create framework adoption guide.
- [ ] Create project templates.
- [ ] Design framework versioning.
- [ ] Expand framework documentation.
- [ ] Standardize documentation across Abbey-style repositories.
- [ ] Create framework migration guide.

---

## Infrastructure

- [ ] Make `.bashrc` Ansible-managed.
- [ ] Configure hostname resolution between lab systems.
- [ ] Implement internal DNS.
- [ ] Enhance `abbey-status` with Docker health, disk usage, and service summaries.
- [ ] Create `abbey infrastructure review`.
- [ ] Manage infrastructure systemd units and automation scripts from the Abbey repository.
- [ ] Deploy infrastructure services through Ansible.
- [ ] Automate restore validation for backups.
- [ ] Implement infrastructure patch management workflow.
- [ ] Define recurring infrastructure maintenance windows.
- [ ] Expand infrastructure monitoring dashboards.
- [ ] Add infrastructure backup failure alerting.
- [ ] Investigate and document Nginx Proxy Manager configuration.
- [ ] Automate deployment of ai-worker01 shell environment through Ansible.
- [ ] Document apartment network wall jack locations.
- [ ] Label structured wiring cabinet.
- [ ] Create network diagram.
- [ ] Keep a spare USB Ethernet adapter for lab recovery.
- [ ] Evaluate VPN, Tailscale, and Cloudflare Tunnel for remote connectivity.
- [ ] Design and implement secure remote access to the lab.
- [ ] Expand `abbey lab` with additional infrastructure diagnostics.
- [ ] Review and refine Ansible playbook and role architecture.
  - Preserve `site.yml` as the full convergence entry point.
  - Add focused playbooks for routine service deployments.
  - Define a true universal host baseline.
  - Split the current `common` role into packages, Git configuration, and Abbey shell concerns.
  - Apply roles according to host purpose rather than targeting every host uniformly.
  - Review time synchronization policy for Debian appliances.
  - Validate check-mode behavior for package installation followed by service management.

---

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

- [ ] Expand `abbey-build` reporting and validation.
- [ ] Add repository consistency checks.
- [ ] Create `abbey-tree`.
- [ ] Standardize tool output formatting and colors.
- [ ] Standardize artifact-creation command output so commands report the path of every generated file.
- [ ] Add automated toolkit regression testing.
- [ ] Add regression tests for `abbey plant validate`.
- [ ] Expand `abbey site` commands.
- [ ] Add `abbey site preview`.
- [ ] Add `abbey site deploy-check`.
- [ ] Reduce noise in `abbey site publish` previews.
- [ ] Add live-site verification to `abbey site publish`.
- [ ] Add project metrics to `abbey-status`.
- [ ] Add documentation validation to `abbey-doctor`.
- [ ] Add network health checks to `abbey-doctor`.
- [ ] Add Git author identity checks to `abbey-doctor`.
- [ ] Verify bridge-ports references an existing interface.
- [ ] Report negotiated Ethernet link speed.
- [ ] Verify gateway connectivity.
- [ ] Verify Internet connectivity.
- [ ] Detect missing or replaced network interfaces.
- [ ] Evaluate shared validation helpers after additional model validators exist.
- [ ] Design `abbey review` to summarize staged changes, validate session completeness, suggest a commit message, and recommend the next workflow step.

### Plant Toolkit

- [x] Define the Plant Model.
- [x] Create a reusable plant workspace template.
- [ ] Review the Plant Model against the reusable template and Doctor Robert reference implementation.
- [x] Create `abbey plant validate`.
- [x] Publish Doctor Robert through the Plant Model as its first reference profile.
- [ ] Create `abbey plant new`.
- [ ] Create `abbey plant inventory`.
- [ ] Create plant photo import workflow.
- [ ] Create plant photo metadata workflow.
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
- [ ] Create `abbey-review`.
- [ ] Create `abbey session-update`.
- [ ] Associate journal entries with active Abbey sessions.

### AI Integration

- [ ] Detect stale AI knowledge before running `abbey ai`.
- [ ] Offer to rebuild AI knowledge automatically when project context changes.
- [ ] Add structured content consistency review.
- [ ] Add photo metadata validation assistance.
- [ ] Add inventory summarization assistance.
- [ ] Add draft publishing assembly from canonical source material.

---

## Self-Documenting Platform

- [x] Generate toolkit command reference.

- [ ] Generate project metrics.
- [ ] Generate documentation index.
- [ ] Generate host inventory.
- [ ] Generate Docker inventory.
- [ ] Generate service inventory.
- [ ] Generate Ansible inventory documentation.
- [ ] Generate Architecture Decision Record index.
- [ ] Eliminate manually maintained generated documentation.
- [ ] Expand metadata-driven documentation generation.
- [ ] Build metadata-driven documentation generation using planning schemas.
- [ ] Generate planning summaries from session updates.
- [ ] Generate AI context from planning documents.
- [ ] Build `abbey docs generate`.
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
- [ ] Expand architecture documentation.
- [ ] Create framework documentation index.
- [ ] Build document update workflow.
- [ ] Design automated document review workflow.
- [ ] Document the canonical `working/` workspace purpose and conventions.
- [ ] Document the principle: model information before building tools.
- [ ] Document the principle: humans record observations; automation manages state.
- [ ] Develop lightweight architecture diagrams for Abbey systems (network, publishing, AI, workflows, remote access) and establish a standard diagram style.

---

## Recurring Reviews

- [ ] Create recurring review registry.
- [ ] Surface due reviews during `abbey session`.
- [ ] Support AI news reviews.
- [ ] Support documentation audits.
- [ ] Support infrastructure reviews.
- [ ] Support dependency reviews.
- [ ] Support backup verification.
- [ ] Support security reviews.

---

## BradCooke.com

### Content

- [ ] Flesh out the Contact page.
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
- [ ] Continue adding Orchid Rescue profiles beyond Doctor Robert and Helter Skelter.
- [ ] Add Phal McCartney to the documented orchid collection.
- [ ] Create a separate future section for bromeliads.

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

- [ ] Move CSS into `site/src/styles/`.
- [ ] Create `global.css`.
- [ ] Create `navigation.css`.
- [ ] Create `layout.css`.
- [ ] Create `project.css`.
- [ ] Improve mobile responsiveness.
- [ ] Add light/dark mode.
- [ ] Create reusable styles for plant profiles and photo timelines.

### Publishing

- [ ] Generate sitemap.
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
- [ ] AI project awareness.
- [ ] AI-powered "What should I work on next?"
- [ ] AI documentation review.
- [ ] AI session recap generation.
- [ ] AI-aware Abbey toolkit integration.
- [ ] Define AI knowledge sources.
- [ ] Track AI knowledge freshness.
- [ ] Build AI knowledge freshness validation.
- [ ] Generate project-aware AI context.
- [ ] Automate AI knowledge rebuilds.
- [ ] Continue recurring AI technology reviews.
- [ ] AI-assisted Plant Model validation.
- [ ] AI-assisted plant history consistency review.
- [ ] AI-assisted plant inventory summaries.
- [ ] AI-assisted selection of milestone photographs.
- [ ] AI-assisted assembly of draft plant pages from verified source material.
- [ ] Keep human observations authoritative in AI-assisted workflows.

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

- [ ] Automate BradCooke.com builds.
- [ ] Automate deployment.
- [ ] Evaluate GitHub Actions vs self-hosted automation.
- [x] Automate plant workspace validation before publishing.
- [ ] Automate plant image metadata checks.
- [ ] Automate creation of optimized published image copies.
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

- [ ] Add verbose mode.
- [ ] Add quiet mode.
- [ ] Add metadata-driven required document list.
- [ ] Add documentation freshness checks.
- [ ] Add backup freshness checks.
- [ ] Add Proxmox VM status.
- [ ] Add Docker container checks.
- [ ] Add Homepage/NPM/Uptime Kuma HTTP checks.
- [ ] Add DNS checks.
- [ ] Add Ansible Vault detection.
- [ ] Add role-aware checks.
- [ ] Add JSON output.
- [ ] Add restore-test tracking.
- [ ] Check whether Git `user.name` is configured.
- [ ] Check whether Git `user.email` is configured.
- [ ] Report the effective Git configuration source.

---

## Request Intake Framework

Create a lightweight request tracking process for Abbey Root.

Initial approach:

- Use GitHub Issues.
- Create issue templates.
- Define labels for status, type, priority, and framework area.
- Link requests to session updates.
- Reference completed issues from commits and session updates.

Future evaluation:

- Evaluate self-hosted issue tracking.
- Evaluate Gitea.
- Avoid building a custom ticketing system until the workflow has been proven.

# Abbey Root Backlog

This document contains work that has been identified but is not necessarily scheduled.

Items are captured here until they are either promoted to the roadmap, completed during a development session, or determined to no longer be necessary.

The backlog is intentionally broad and serves as the project's working inventory of ideas, improvements, and future capabilities.

---

## High Priority

- [ ] Design `abbey init` project bootstrap command.
- [ ] Create `abbey-end` session workflow.
- [ ] Create `abbey-review` planning reconciliation workflow.
- [ ] Continue eliminating manually maintained documentation.
- [ ] Design secure remote access to Abbey Root for working away from home.
- [ ] Document and photograph the completed data closet layout.
- [ ] Publish additional BradCooke.com content.

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
- [ ] Enhance `abbey-status` with Docker health, disk usage, and service summaries.
- [ ] Automate deployment of ai-worker01 shell environment through Ansible.
- [ ] Document apartment network wall jack locations.
- [ ] Label structured wiring cabinet.
- [ ] Create network diagram.
- [ ] Keep a spare USB Ethernet adapter for lab recovery.
- [ ] Evaluate VPN, Tailscale, and Cloudflare Tunnel for remote connectivity.
- [ ] Design and implement secure remote access to the lab.

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

### Toolkit Evolution

- [ ] Expand `abbey-build` reporting and validation.
- [ ] Add repository consistency checks.
- [ ] Create `abbey-tree`.
- [ ] Standardize tool output formatting and colors.
- [ ] Add automated toolkit regression testing.
- [ ] Expand `abbey site` commands.
- [ ] Add `abbey site preview`.
- [ ] Add `abbey site deploy-check`.
- [ ] Add project metrics to `abbey-status`.
- [ ] Add documentation validation to `abbey-doctor`.
- [ ] Add network health checks to `abbey-doctor`.
- [ ] Verify bridge-ports references an existing interface.
- [ ] Report negotiated Ethernet link speed.
- [ ] Verify gateway connectivity.
- [ ] Verify Internet connectivity.
- [ ] Detect missing or replaced network interfaces.
- [ ] Design `abbey review` to summarize staged changes, validate session completeness, suggest a commit message, and recommend the next workflow step.

### Workflow

- [ ] Expand `abbey-session` with project-aware recommendations.
- [ ] Display planning summaries during `abbey session`.
- [ ] Create `abbey-end`.
- [ ] Design `abbey-end` to analyze Git changes and draft session updates.
- [ ] Create `abbey-review`.
- [ ] Create `abbey session-update`.
- [ ] Associate journal entries with active Abbey sessions.

### AI Integration

- [ ] Detect stale AI knowledge before running `abbey ai`.
- [ ] Offer to rebuild AI knowledge automatically when project context changes.

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

---

## Documentation

- [ ] Complete the onboarding guide series.
- [ ] Create `WORKFLOW.md`.
- [ ] Create `PHILOSOPHY.md`.
- [ ] Expand architecture documentation.
- [ ] Create framework documentation index.
- [ ] Build document update workflow.
- [ ] Design automated document review workflow.

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

### Components

- [ ] Improve `ProjectHeader`.
- [ ] Refactor `ProjectHeader` to accept explicit props.
- [ ] Create Technology Badge component.
- [ ] Create Timeline component.
- [ ] Create Callout component.

### Styling

- [ ] Move CSS into `site/src/styles/`.
- [ ] Create `global.css`.
- [ ] Create `navigation.css`.
- [ ] Create `layout.css`.
- [ ] Create `project.css`.
- [ ] Improve mobile responsiveness.
- [ ] Add light/dark mode.

### Publishing

- [ ] Generate sitemap.
- [ ] Generate RSS feed.
- [ ] Add search.
- [ ] Define `docs/` vs `content/` publishing boundaries.
- [ ] Remove remaining `build-website.sh` references.
- [ ] Create BradCooke.com publishing runbook.
- [ ] Publish the Abbey Root Operations Manual.
- [ ] Configure GitHub Pages deployment.
- [ ] Add custom domain configuration.
- [x] Create dynamic journal detail pages.
- [ ] Group journal entries by year.
- [x] Add previous/next journal navigation.

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

---

## Automation

- [ ] Automate BradCooke.com builds.
- [ ] Automate deployment.
- [ ] Evaluate GitHub Actions vs self-hosted automation.

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

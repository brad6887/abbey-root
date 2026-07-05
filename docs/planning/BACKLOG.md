# Abbey Root Backlog

This document contains tasks that have been identified but are not necessarily scheduled.
Items should be moved to the roadmap or completed as priorities change.

---

## Infrastructure

- [ ] Make `.bashrc` Ansible-managed.
- [ ] Configure hostname resolution between lab systems.
- [ ] Enhance `abbey-status` with Docker health, disk usage, and service summaries.
- [ ] Automate deployment of ai-worker01 shell environment through Ansible.
- [ ] Document and photograph the completed data closet layout.
- [ ] Document apartment network wall jack locations.
- [ ] Label structured wiring cabinet.
- [ ] Create network diagram.
- [ ] Keep a spare USB Ethernet adapter for lab recovery.

---

## Developer Toolkit

- [x] Generate `abbey-help` automatically from tool metadata.
- [x] Create `abbey-doctor` system health and dependency checker.
- [ ] Expand `abbey-build` reporting and validation.
- [ ] Add repository consistency checks.
- [ ] Create `abbey-tree` helper.
- [X] Create `abbey-journal` helper.
- [ ] Standardize tool output formatting and color usage.
- [ ] Add automated toolkit regression testing.
- [ ] Add `abbey-site-build`.
- [ ] Add `abbey-site-preview`.
- [ ] Add `abbey-site-deploy-check`.
- [ ] Add network health checks to abbey-doctor.
- [ ] Verify bridge-ports references an existing interface.
- [ ] Report negotiated Ethernet link speed.
- [ ] Verify gateway connectivity.
- [ ] Verify Internet connectivity.
- [ ] Detect probable replacement network adapters.

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
- [x] Create Date formatting helper.

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
- [ ] Add search capability.
- [ ] Define `docs/` vs `content/` publishing boundaries.
- [ ] Remove remaining legacy `build-website.sh` references.
- [ ] Create BradCooke.com publishing runbook.
- [ ] Configure GitHub Pages deployment.
- [ ] Add custom domain configuration.
- [x] Create dynamic journal detail pages.
- [ ] Group journal entries by year.
- [x] Add previous/next journal navigation.

---

## AI

- [ ] Expand ai-worker01 into the AI experimentation platform.
- [ ] AI-assisted metadata generation.
- [ ] AI-generated summaries.
- [ ] AI-generated internal links.
- [ ] AI-assisted image alt text.
- [ ] AI-assisted publishing workflow.
- [ ] AI-generated session summaries.
- [ ] AI-assisted project history.
- [ ] AI project context awareness.
- [ ] AI-powered "What should I work on next?"
- [ ] AI documentation review.
- [ ] AI session recap generation.
- [ ] AI-aware Abbey toolkit integration.

---

## Automation

- [ ] Automate BradCooke.com builds.
- [ ] Automate deployment.
- [ ] Evaluate GitHub Actions vs. self-hosted automation.

---

## Communications

- [ ] Evaluate custom email hosting for bradcooke.com.
- [ ] Create `brad@bradcooke.com`.
- [ ] Create `contact@bradcooke.com`.
- [ ] Design AI-assisted email workflows.
- [ ] Generate weekly Abbey Root project summaries via email.
- [ ] Investigate automated project status reports.
- [ ] Design end-of-session AI summary email.

---

## Abbey Doctor V2 Ideas

- Add verbose mode.
- Add quiet mode for scripting.
- Add metadata-driven required document list.
- Add documentation freshness checks.
- Add backup freshness checks that can run remotely against Proxmox.
- Add Proxmox VM status checks.
- Add Docker container checks for ubuntu-dev01 and ai-worker01.
- Add Homepage/NPM/Uptime Kuma HTTP checks.
- Add DNS checks for lab hostnames.
- Add Ansible Vault detection and optional vault password file support.
- Add check categories: local, remote, storage, docs, services.
- Add host role awareness so checks run based on host purpose instead of hostname.
- Add JSON output for future automation.
- Add restore-test status tracking.

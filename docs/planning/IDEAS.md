# Abbey Root Ideas

## BradCooke.com Plant Image Enhancements

Only if demonstrated need warrants them, evaluate optimized web image derivatives and file-size review, optional captions and lazy loading, and a reusable plant photo gallery.

## Generated Lab Health Documentation

Explore whether summarized lab-health information should be published as generated project documentation.

Other exploratory possibilities include health scoring, Uptime Kuma integration, historical health-trend collection, and automatic issue creation.

## Historical Session Review Enhancements

Explore generating reconciliation instructions directly from `abbey session review` and evaluating a dedicated historical-review mode.

## Museum of Dumb Ideas

An established section of BradCooke.com dedicated to humorous projects, questionable decisions, abandoned ideas, and stories that are too good not to tell.

The goal isn't to celebrate failure—it's to document the creative process and remind people that not every idea has to become a serious project. Some ideas are funny. Some are terrible. Occasionally one accidentally becomes something worthwhile.

The Museum has the feel of an actual museum, with exhibits, artifact descriptions, curator's notes, and a healthy dose of self-deprecating humor.

Possible future wings:

- Hall of Purchased Domains
- Half-Baked Projects
- Surprisingly Good Ideas
- Questionable Experiments
- Retired Exhibits

Current and potential exhibits:

### OmeletYouFinish.com

Purchased the domain after the idea of creating an omelet-themed travel blog. Fortunately, common sense returned before development began.

Current status:

- Completed as the Museum's first exhibit.
- Published at `https://bradcooke.com/museum/omelet-you-finish/`.
- `https://omeletyoufinish.com/` permanently redirects to the exhibit.

### Bread Pitt

Originally a joke name for a sourdough starter.

Unexpectedly evolved into an ongoing project documenting the starter's growth using Brad Pitt's filmography instead of days.

Candidate for graduating from the Museum into its own permanent section of BradCooke.com.

### The Jeep Incident

Locate the 1980s photograph of the Jeep buried in mud.

Potential museum exhibit documenting one of the earliest examples of confidence exceeding experience.

Possible museum plaque:

- Year: circa 1980s
- Original Plan: "This'll be fun."
- Actual Result: Required outside assistance.
- Lesson Learned: Confidence is not traction.

### Future Philosophy

The Museum should feel like walking through a collection of stories rather than reading a portfolio.

Visitors should leave thinking:
"This guy builds serious things... but he also doesn't take himself too seriously."

## Project Health Dashboard

### Summary

Teach Abbey to track the types of work performed over time so it can help guide future sessions rather than simply recording them.

The goal is **not** time tracking or enforcing quotas. The goal is helping prevent important areas of the project from being neglected while still encouraging exploration.

### Possible Areas

- Infrastructure
- Automation
- AI
- Workflow
- Web Development
- Documentation
- Backlog / Maintenance
- Ideas / Research

The list should be configurable rather than hard-coded.

### Possible Session Metadata

```yaml
primary: automation

secondary:
  - ai
  - workflow

session_type: standard
```

Possible future session types:

- standard
- sidequest
- maintenance
- research

### Future Reports

Examples:

- Activity by area
- Areas not touched recently
- Monthly trends
- Project health dashboard
- Suggested focus for next session

Example output:

- Infrastructure: Healthy
- Automation: Very Active
- Documentation: Needs Attention
- Ideas: Stale (28 days)

### Design Principles

- Encourage balance without enforcing quotas.
- Preserve the freedom to follow interesting side quests.
- Use history to suggest—not dictate—future work.
- Make side quests a first-class part of the engineering process.
- Keep metadata lightweight so session startup remains fast.

## Abbey Wallboard / Command Center

### Summary

Develop a lightweight web-based Abbey dashboard designed for an always-on display (old iPad, monitor, or TV) that provides a live view of the Abbey Root environment.

The initial goal is passive awareness rather than interaction. Over time, the dashboard could evolve into a secure operations console for common administrative tasks.

### Motivation

Provide a "mission control" view of the lab that makes the current state of Abbey visible at a glance without opening a terminal.

Potential display devices include:

- Old iPad mounted near the desk
- Secondary monitor
- Wall-mounted TV
- Browser on any workstation

### Phase 1 — Wallboard (Read Only)

- Rotating full-screen dashboard pages
- Current Abbey session
- Definition of Done
- Recommended next command
- Lab health
- Docker container status
- AI worker status
- Backup status
- Project progress
- Calendar / daily agenda
- Optional "fun" screen (orchids, Bread Pitt, weather, dad joke, etc.)

Display should rotate automatically every 15–30 seconds while allowing manual navigation.

### Phase 2 — Command Center

Add authenticated, touch-friendly operational controls for predefined Abbey actions.

Examples:

- Restart Uptime Kuma
- Restart Homepage
- Run `abbey doctor`
- Run `abbey lab check`
- Refresh dashboard data
- Start backup
- Publish website

Actions should execute predefined workflows rather than arbitrary shell commands.

### Architecture Ideas

- Lightweight web application
- Docker deployment
- Accessible at `abbey.home.arpa`
- Optimized for tablet displays
- Real-time updates via WebSockets or Server-Sent Events
- Multiple displays supported simultaneously

### Design Principles

- CLI remains the source of truth.
- Dashboard consumes the same data as Abbey commands.
- Prefer structured JSON output from Abbey commands over parsing terminal text.
- Keep the display read-only until operational workflows are mature.
- Every action should be logged and auditable.

### Future Possibilities

- Event-driven screen changes (show alerts when attention is needed)
- Notification center
- Historical graphs
- AI worker monitoring
- Deployment status
- Home lab map
- Power Infrastructure integration
- Mobile-friendly command center
- Voice interface using future Abbey AI capabilities

### Not Yet

Do not implement until the session workflow and review process have stabilized. This feature should build on the existing session metadata rather than complicating it prematurely.

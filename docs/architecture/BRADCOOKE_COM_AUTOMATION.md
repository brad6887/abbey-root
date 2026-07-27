# BradCooke.com Automation Architecture

## Purpose

Define how Abbey Root should automate BradCooke.com build validation and
production deployment without weakening the safeguards already provided by
`abbey site publish`.

## Status

Accepted for staged implementation.

## Current Architecture

BradCooke.com intentionally uses two repositories:

- Abbey Root contains the Astro source, content, and publishing tooling.
- `brad6887.github.io` contains only the generated static production site
  served by GitHub Pages.

The existing `abbey site publish` workflow:

1. Requires clean source and production repositories.
2. Verifies the production `CNAME`.
3. Builds the Astro site.
4. Previews the generated-file synchronization.
5. Requires confirmation before changing production files.
6. Validates and displays the production diff.
7. Requires confirmation before committing and pushing.
8. Identifies the Abbey Root source revision in the production commit.
9. Verifies the live site after the push.

Publishing is deliberately separate from building so changes can be reviewed
before they become public.

## Problem

The current workflow safely automates a local publication, but two gaps remain:

- Pull requests and changes on `main` do not receive hosted build validation.
- Production publication still depends on a prepared local checkout and manual
  execution.

These are separate concerns and should not be collapsed into automatic
publication on every push.

## Options Considered

### GitHub-hosted Actions

Advantages:

- Native pull-request and branch status checks.
- No runner maintenance.
- Repository and path filters can limit work to site-affecting changes.
- GitHub Environments can preserve an explicit production approval boundary.
- Workflow logs and source revisions provide durable deployment evidence.

Risks:

- Cross-repository deployment requires a narrowly scoped credential.
- A careless push trigger could publish unrelated changes.
- The current preview and confirmation safeguards must be translated rather
  than discarded.

### Self-hosted automation

Advantages:

- Can reuse local checkouts and the current command with fewer structural
  changes.
- Keeps publication inside the Abbey lab.

Risks:

- Adds runner patching, availability, monitoring, and recovery responsibility.
- Places repository credentials on a persistent lab host.
- Couples public publishing to home infrastructure availability.
- Provides no current capability that justifies the added operational burden.

### Keep the current workflow only

Advantages:

- Already implemented, tested, and safe.
- Requires no new credentials or hosted workflow.

Risks:

- Build failures are discovered late.
- Publication remains tied to one prepared workstation.
- Pull requests lack a required site-build signal.

## Decision

Use GitHub-hosted Actions in two stages.

### Stage 1: Build validation

Add a path-scoped workflow that runs for pull requests and pushes to `main`
when site source, site content, publishing inputs, or the workflow itself
changes.

The workflow must:

- use a pinned Node.js major version;
- install dependencies with `npm ci` from `site/package-lock.json`;
- run `npm run build` from `site`;
- require no production credential;
- expose one stable required-check name;
- avoid uploading or publishing production output.

This stage may be implemented independently and evaluated before production
automation.

### Stage 2: Production deployment

Add a separate workflow triggered only by `workflow_dispatch`.

The workflow must:

- accept only a source revision reachable from `main`;
- use a protected GitHub `production` Environment with explicit approval;
- build from the selected Abbey Root revision;
- authenticate to `brad6887.github.io` with a credential scoped only to that
  repository and only to required content writes;
- preserve and validate the production `CNAME`;
- preview and validate the generated diff before committing;
- make no commit when production is already current;
- include the full Abbey Root source revision in the production commit;
- fail immediately if the production push fails;
- verify `https://bradcooke.com/` with bounded retries after the push;
- retain logs that identify the source revision, production revision, and live
  verification result.

Automatic deployment on every push to `main` is explicitly rejected. Build
validation and public release remain separate boundaries.

## Credential Boundary

The deployment implementation must choose and document one least-privilege
cross-repository credential before production use. Acceptable candidates are:

- a GitHub App installation token restricted to `brad6887.github.io`; or
- a fine-grained token restricted to that repository and stored only in the
  protected production Environment.

A broad personal access token or persistent self-hosted runner credential is
not acceptable.

## Relationship to `abbey site publish`

`abbey site publish` remains the authoritative, supported publication workflow
until Stage 2 is implemented and live validation proves equivalent safeguards.

Stage 2 should reuse extracted deterministic publishing behavior where
practical. It should not maintain an unrelated second interpretation of CNAME
preservation, generated-file synchronization, revision reporting, or live-site
verification.

The local command remains a recovery and operator-controlled publication path
after hosted deployment is introduced.

## Rollback

Rollback uses the production repository history:

1. Select the last known-good production commit.
2. Revert the bad production commit without rewriting public history.
3. Push the revert.
4. Verify the live site.
5. Record the source and production revisions involved.

The deployment workflow must not force-push production.

## Implementation Order

1. Implement and evaluate Stage 1 build validation.
2. Extract or define reusable non-interactive publish primitives.
3. Configure the protected production Environment and scoped credential.
4. Implement Stage 2 as a manually dispatched workflow.
5. Validate a no-change deployment and one controlled production publication.
6. Reconcile planning state only after live production verification.

## Deferred Work

- Scheduled deployments.
- Deployment on every push.
- Preview environments.
- Self-hosted runners.
- Automated rollback.
- Broader website test suites beyond the deterministic Astro build.

## Related Documents

- `docs/session-updates/2026-07-11-site-publish-workflow.md`
- `docs/planning/BACKLOG.md`
- `docs/planning/PROJECT_STATUS.md`
- `tools/bin/abbey-site`

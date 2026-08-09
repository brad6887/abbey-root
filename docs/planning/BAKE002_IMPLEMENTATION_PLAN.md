# Bake002 Publishing Workflow Implementation Plan

## Purpose

Prepare the proven Bread Pitt publishing workflow for Bake002 by removing the
duplication and preventable manual work exposed during Bake001 without
prematurely generalizing Bread Pitt domain behavior into Abbey core.

This plan spans two repositories:

- Abbey Root owns reusable site lifecycle behavior and any shared validation
  primitives justified by the implementation.
- Bread Pitt owns the bake model, scaffold, content renderer, recipe
  relationships, visual rules, and project runbook.

The existing `abbey media publish` and `abbey site validate` contracts remain
the reusable publication foundation. Their canonical-working-media,
published-derivative, and manifest boundaries must be preserved.

## Objective

Make Bake002 creatable, authorable, validatable, and previewable without
manually duplicating intake metadata or narrative content.

## Definition of Done

The pre-Bake002 work is complete when:

- Canonical ownership is documented for every bake content and media artifact.
- `photos.yml` deterministically generates `media-intake.json`.
- `bake.yml` and `story.md` render a bake route through shared Astro code.
- A single Bread Pitt validation command checks the complete bake publication
  model and reports actionable errors.
- A safe scaffold creates only the canonical inputs and directories required
  for a new bake.
- `abbey site restart` reliably replaces the active project development server.
- The Bake001 procedure and the new Bake002 procedure are captured in a
  Bread Pitt runbook.
- Bake001 still builds and validates through the canonical renderer.
- A scaffolded Bake002 fixture passes validation without requiring publication.

## Scope Boundaries

### Included

- Canonical-source decisions.
- Deterministic intake generation.
- Shared Bread Pitt bake rendering.
- Bread Pitt bake scaffolding and validation.
- Explicit Abbey site restart behavior.
- Focused regression coverage and workflow documentation.

### Excluded

- A generic Abbey content-type framework.
- A core `abbey bake` command.
- One-command end-to-end publication.
- Automatic hero-image selection.
- Development-server freshness fingerprinting.
- Camera ingestion.
- Generalized visual-publication policy.
- Changes to the established media publication manifest contract unless a
  demonstrated incompatibility blocks Bake002.

## Authoritative Content Contract

Before implementation, record the following ownership model in Bread Pitt's
domain documentation:

- `bake.yml`: bake identity, dates, slug, hero photo identifier, recipe
  identifiers, and structured presentation metadata.
- `story.md`: canonical authored narrative.
- `photos.yml`: canonical photo selection, captions, roles, and source facts.
- `media-intake.json`: generated media-publication input; never hand-edited.
- Publication manifest: generated record produced by `abbey media publish`.
- Published derivatives: generated public assets described by the publication
  manifest.
- Astro route: generated at build time through a shared dynamic route and
  shared components; no per-bake narrative copy.
- Recipe backlinks and index cards: derived from canonical bake-to-recipe
  identifiers unless Bread Pitt documents a different single owner.

Stable identifiers should connect bake, photo, recipe, hero, and gallery data.
Filesystem paths should be resolved from configuration rather than copied
between authoring files.

## Implementation Sequence

### Phase 1 — Confirm the Bread Pitt Model

Repository: Bread Pitt

1. Inventory Bake001's canonical, generated, and manually duplicated files.
2. Compare the implemented fields with the documented Bread Pitt domain model.
3. Decide the authoritative owner for hero selection and recipe relationships.
4. Define required and optional fields and assign schema versions where the
   existing formats support them.
5. Record generated-file markers and the policy for committing generated
   manifests.

Validation:

- Every published Bake001 fact has exactly one authoritative source.
- No canonical field depends on parsing rendered Astro markup.
- The proposed model can represent Bake001 without losing content.

### Phase 2 — Generate the Intake Manifest

Repository: Bread Pitt first; Abbey Root only if a reusable input adapter is
demonstrably required.

1. Implement a deterministic transformation from `photos.yml` to the existing
   intake-manifest contract consumed by `abbey media publish`.
2. Preserve captions, prepared filenames, source paths, photo identifiers, and
   required provenance.
3. Write atomically and leave an unchanged manifest untouched.
4. Add a read-only freshness check comparing canonical input with generated
   output.
5. Reject invalid or ambiguous photo metadata before writing output.

Validation:

- Repeated generation is byte-for-byte deterministic.
- An unchanged rerun produces no file change.
- Edited `photos.yml` makes the freshness check fail until regeneration.
- Invalid paths, duplicate identifiers, duplicate destinations, and missing
  sources fail with actionable messages.
- The generated Bake001 manifest remains accepted by `abbey media publish`.

### Phase 3 — Render from Canonical Content

Repository: Bread Pitt

1. Create a shared bake loader that reads and validates `bake.yml`, `story.md`,
   canonical photo metadata, recipe metadata, and the publication manifest.
2. Replace the hand-written Bake001 route with a dynamic Astro route or an
   equivalent shared renderer.
3. Move repeated page structure into shared components while keeping the
   narrative in `story.md`.
4. Resolve hero, gallery, and recipe links by stable identifiers.
5. Derive recipe-index representative images from canonical relationships.

Validation:

- Bake001 renders at its existing public route.
- Its narrative is sourced only from `story.md`.
- Its hero, gallery, and recipe links resolve to published derivatives.
- The recipe index continues to show the intended finished-loaf image.
- The production build contains no per-bake hand-authored route requirement.

### Phase 4 — Add Bread Pitt Scaffold and Validation

Repository: Bread Pitt

Implement project-local commands before considering an Abbey extension
contract. Recommended interfaces are:

```text
./bin/bake new Bake002
./bin/bake validate Bake001
```

The scaffold should:

- Validate and normalize the requested bake identifier and slug.
- Refuse an existing destination.
- Create only canonical starter files and required source directories.
- Use explicit placeholders instead of invented bake facts.
- Report every created path.
- Leave generated manifests, derivatives, publication directories, and Astro
  pages to their owning generators.

The validator should check:

- Bake and photo schemas.
- Required canonical files.
- Unique bake slug and route.
- Photo identifiers and source-image existence.
- Hero selection.
- Recipe existence and linkage.
- Intake-manifest freshness.
- Publication-manifest validity and derivative existence when publication is
  expected.
- Representative recipe images.
- Absence of hand-maintained generated outputs.

Validation:

- Scaffold dry-run or preview output is reviewable if supported.
- Creation is idempotent by refusal rather than overwrite.
- A minimal Bake002 fixture passes canonical validation.
- Broken hero, recipe, photo, manifest, and derivative cases each produce a
  focused regression test and corrective error.

### Phase 5 — Add `abbey site restart`

Repository: Abbey Root

1. Review the existing `abbey site start`, stop, and status process model.
2. Implement restart as an explicit, project-aware stop followed by start.
3. Refuse to stop a process owned by another Abbey project.
4. Preserve existing options and forward applicable start options safely.
5. Report the resolved project and old and new process state.
6. Register the command in CLI metadata and regenerate CLI documentation.

Validation:

- Restart with no running server starts one cleanly.
- Restart replaces the active project's running server.
- Failure to stop prevents a second server from starting.
- Cross-project process isolation is covered.
- Help, invalid arguments, exit status, and generated documentation are
  validated.

Stale-server inference remains deferred. The explicit restart is the reliable
recovery operation for Bake002.

### Phase 6 — Integrate and Prove the Workflow

Repositories: Bread Pitt and Abbey Root

1. Migrate Bake001 to the canonical renderer and generated intake workflow.
2. Run scaffold creation against a temporary Bake002 fixture.
3. Run bake validation before media publication.
4. Run the existing media publication dry run and real fixture tests.
5. Build the Bread Pitt site and run `abbey site validate`.
6. Start and restart the development server and inspect Bake001 plus the recipe
   index.
7. Capture the exact operator procedure and recovery steps in a Bread Pitt
   runbook.

Validation evidence should include:

- Focused unit or shell regression suites.
- Generated-artifact freshness checks.
- Bread Pitt production build.
- `abbey site validate`.
- `abbey docs check` for Abbey CLI changes.
- `abbey backlog check` in Abbey Root.
- `git diff --check` and final working-tree review in both repositories.

## Recommended Session Breakdown

Keep each session coherent and independently reviewable:

1. Bread Pitt canonical content contract and Bake001 inventory.
2. Deterministic intake-manifest generation.
3. Canonical bake renderer and Bake001 migration.
4. Bread Pitt bake validator.
5. Bread Pitt bake scaffold.
6. Abbey Root `abbey site restart`.
7. End-to-end Bake002 readiness validation and runbook capture.

Do not combine the generic Abbey content abstraction or one-command publication
work with these sessions.

## Risks and Controls

- **Risk: Generated data becomes a second source of truth.** Control: generated
  markers, deterministic regeneration, and freshness validation.
- **Risk: Bake001 changes visually during renderer migration.** Control:
  compare the existing route, hero, gallery, recipe links, and index image
  before removing the old page.
- **Risk: Bread Pitt behavior leaks into Abbey core.** Control: keep bake
  commands local and promote only demonstrated reusable primitives.
- **Risk: Validation becomes one opaque command.** Control: compose focused
  checks and report every failure with the owning source and corrective action.
- **Risk: Restart affects another project.** Control: use Abbey's resolved
  project identity and stored process ownership before stopping anything.

## Post-Bake002 Review

After Bake002 is published, compare Bake001 and Bake002 for repeated manual
steps, configuration friction, validation gaps, and presentation rules. Use
that evidence to decide whether to schedule media workflow helpers, layered
Abbey media validation, a generic project command contract, stale-server
detection, or publication orchestration.

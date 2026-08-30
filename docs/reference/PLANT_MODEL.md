# Plant Model

This document defines the canonical content model for plants within Abbey Root.

New and migrated plant profiles follow the same directory structure and metadata conventions. Existing lightweight public profiles may remain until they are migrated to the canonical workspace model.

The goal is to maintain a single, machine-readable source of truth that can be consumed by websites, automation, AI workers, and future tooling.

Plant source material is stored under:

```text
working/plants/<slug>/
```

Example:

```text
working/plants/doctor-robert/
├── facts.yaml
├── story.md
├── history.md
├── inventory.md
├── photo-metadata.md
├── photos/
└── sources/
```

The remainder of this document defines the required files, metadata fields, and conventions used by every plant profile.

## Creating a Workspace

Create new workspaces through the Abbey toolkit:

```bash
abbey plant new <slug> --name "Plant Name" --type orchid
```

The command accepts `--status` and `--date` for initial state and repeatable
`--photo` arguments for initial photographs. It creates the canonical files and
directories without copying template-only instructions, initializes verified
facts, imports any adjacent matching XMP sidecar, assigns the first imported
photo to the hero and current roles, and runs Plant Model validation. It refuses
to overwrite an existing workspace.

An initialized workspace may pass validation with warnings. Template placeholder
warnings identify narrative, history, inventory, and photo-metadata documents
that still require plant-specific content before publication review.

Unknown botanical, care, source, and location facts remain `null` for later
review rather than being guessed.

---

# Directory Structure

Every plant directory should follow this layout.

```text
working/plants/<slug>/
├── facts.yaml
├── story.md
├── history.md
├── inventory.md
├── photo-metadata.md
├── photos/
└── sources/
```

## Directory Purpose

| Item | Purpose |
|------|---------|
| `facts.yaml` | Canonical machine-readable metadata |
| `story.md` | Public narrative |
| `history.md` | Detailed chronological journal |
| `inventory.md` | Current verified physical state |
| `photo-metadata.md` | Metadata tracking for recovered or edited photos |
| `photos/` | Original and recovered photographs |
| `sources/` | Supporting material such as exported chats, PDFs, notes, and research |

---

# facts.yaml

`facts.yaml` is the canonical metadata file for every plant.

It contains structured information only.

Narrative text belongs in `story.md` or `history.md`.

Example:

```yaml
name: Doctor Robert
slug: doctor-robert
description: The rescue and recovery story of Doctor Robert.

plant:
  type: orchid
  genus: Phalaenopsis
  species: null
  hybrid: true

rescue:
  date: 2026-03-01
  source: Lowe's clearance rack
  location:
    city: Naples
    state: Florida
    country: United States

status:
  current: recovering
  current_location:
    city: Fort Worth
    state: Texas
    country: United States
  updated: 2026-07-05

care:
  potting_medium: orchid bark
  container: clear orchid pot

photos:
  hero: photos/IMG_C52D2813-DCED-40FD-BBF7-605ACE5D9306.jpeg
  current: photos/Image (4).png
  metadata: photo-metadata.md

documents:
  story: story.md
  history: history.md

tags:
  - orchid
  - orchid-rescue
  - phalaenopsis
  - rescue-plant
```

---

# Field Definitions

## description

Optional public summary used in generated page metadata.

When omitted, the publisher generates a standard rescue-and-recovery summary.

## name

Human-readable plant name.

Example:

```yaml
name: Doctor Robert
```

---

## slug

Lowercase, URL-safe identifier.

Use hyphens instead of spaces.

Example:

```yaml
slug: doctor-robert
```

---

## plant

Basic botanical information.

```yaml
plant:
  type: orchid
  genus: Phalaenopsis
  species: null
  hybrid: true
```

### Rules

- Use accepted botanical names when known.
- Use `null` rather than guessing.
- `hybrid` is a boolean (`true` or `false`).

---

## rescue

Information about when and where the plant entered the collection.

```yaml
rescue:
  date: 2026-03-01
  source: Lowe's clearance rack
  location:
    city: Naples
    state: Florida
    country: United States
```

### Rules

- Dates use ISO format (`YYYY-MM-DD`).
- Record where the plant was acquired, not necessarily where it was originally grown.

---

## status

Current condition of the plant.

```yaml
status:
  current: recovering
  current_location:
    city: Fort Worth
    state: Texas
    country: United States
  updated: 2026-07-05
```

### Rules

Use simple machine-friendly values.

Examples:

- recovering
- thriving
- blooming
- dormant
- deceased

The `updated` field records when the status was last confirmed.

---

## care

Current growing conditions.

```yaml
care:
  potting_medium: orchid bark
  container: clear orchid pot
```

Examples of future additions:

- fertilizer
- watering_schedule
- light
- humidity

---

## photos

References to important photographs. Role selections belong here; websites
consume their generated metadata rather than inferring roles from filenames.

```yaml
photos:
  original: null
  hero: photos/example.jpg
  current: photos/current.jpg
  metadata: photo-metadata.md
```

### Rules

- Use relative paths.
- Optional `original` selects the earliest/first documented photograph. Keep it
  omitted or `null` until provenance establishes that selection; neither the
  filename nor the hero role establishes chronology. New workspaces leave it
  unset for review, even when the first import initializes hero/current.
- Hero is the curated best overall visual and may equal Original or Current.
- Current image reflects the most recent overall condition.
- Additional photos belong in `history.md`.
- `abbey plant publish` exports a populated `photos.original` as `originalImage`
  through the same sanitized derivative and provenance-manifest pipeline as
  hero/current. An absent role is omitted from generated frontmatter. Consumers
  should label missing Original/Current selections honestly; a Hero may fall
  back to Current, then Original, without changing canonical selections.

---

## Image Curation Review

Generate a private batch contact sheet from canonical role selections:

```bash
abbey plant image-review
abbey plant image-review --candidates
abbey plant image-review honey-pie rocky-raccoon --output .abbey/photo-review
```

The default output is `.abbey/plant-image-review/index.html`, accompanied by
`review.json` and metadata-stripped, auto-oriented thumbnails. Each plant shows
Original, Current, and Featured (the internal `hero` role), source paths,
missing selections, and explicit fallback behavior. `--candidates` adds
galleries of existing supported photographs, excluding sidecars and AppleDouble
files. The report is private working material, not website output; do not
publish it or serve the canonical workspace itself.

Review historical provenance before assigning Original. The report does not
infer chronology or change selections. Keep Current as the latest representative
view, and use `abbey plant hero <slug>` for a deliberate Featured selection.
Canonical `facts.yaml` remains the authority; do not edit generated imports.
Thumbnails show source framing, not proof of the exported derivative. Validate
the selected workspaces and regenerate local plant imports through the configured
publishing workflow, then verify the actual BradCooke.com build.

---

## documents

Canonical narrative documents.

```yaml
documents:
  story: story.md
  history: history.md
```

Future documents may be added here as the model evolves.

---

## tags

Machine-readable keywords.

```yaml
tags:
  - orchid
  - orchid-rescue
  - phalaenopsis
```

### Rules

- Lowercase
- Hyphen-separated
- Avoid duplicate meanings

---

# story.md

Purpose:

Provide a concise narrative suitable for publication.

This document answers:

> Why is this plant's story worth telling?

It should be readable in only a few minutes.

---

# history.md

Purpose:

Maintain the complete chronological history of the plant.

Typical sections include:

- What Happened
- Photos
- Observations
- Notes
- Lessons

This document is the authoritative historical record.

---

# inventory.md

Purpose:

Record the current verified physical state of the plant.

Use this document for present observations and inventory rather than chronological history or public narrative.

---

# photo-metadata.md

Purpose:

Track metadata for photographs, especially recovered images that required manual reconstruction.

Typical fields include:

- filename
- capture date
- description
- metadata status

This document exists primarily as a working reference.

---

# photos/

Contains original and recovered photographs.

Guidelines:

- Preserve original images whenever possible.
- Preserve camera metadata.
- If metadata must be reconstructed, document the source in `photo-metadata.md`.
- Avoid editing originals directly.

---

# sources/

Contains supporting material used during documentation.

Examples:

- Exported ChatGPT conversations
- PDFs
- Research
- Notes
- External references

These files are not intended for publication.

---

# Publishing Workflow

Plant workspaces under `working/plants/<slug>/` are the canonical source for plant metadata, narrative, history, inventory, photographs, and supporting material.

The publishing workflow is:

```text
working/plants/<slug>/
        ↓
abbey plant validate <slug>
        ↓
abbey plant publish <slug>
        ↓
../brad6887.github.io/content/plants/<slug>.md
../brad6887.github.io/site/public/images/plants/<slug>/
        ↓
BradCooke.com Astro website
```

Validation confirms that the canonical workspace satisfies the Plant Model before publication. Publishing derives the website-facing Markdown and selected public images from that workspace. Astro consumes those generated outputs to build the website.

Photo consistency validation covers supported `.jpg`, `.jpeg`, `.png`, and
`.webp` files directly under `photos/`. Canonical references include photo-role
paths in `facts.yaml`, history photo list or heading entries, Markdown image
links, and the first filename column in photo-metadata tables. Missing
referenced files fail validation. Supported photographs with no canonical
reference are reported as warnings because preserved source material may be
intentionally retained. XMP sidecars, AppleDouble files, and unsupported file
types are not treated as photographs.

Files under BradCooke.com's `content/plants/` and
`site/public/images/plants/` are generated outputs for migrated plant
profiles. Correct canonical source material or the publishing workflow rather
than editing generated output directly.

Public plant images are generated derivatives rather than direct copies. Publishing:

- applies the embedded orientation before metadata removal
- converts images to sRGB
- limits the longest edge to 2400 pixels
- removes embedded camera, location, thumbnail, and other metadata
- verifies the canonical source hash remains unchanged
- rejects a derivative if potentially private metadata remains
- records source and derivative hashes, plus source- and target-project
  identity, in BradCooke.com's
  `generated/plant-publication/<slug>.json`

The publication manifest is a machine-generated validation record. It supplements rather than replaces the human-maintained provenance in `photo-metadata.md`.

Working notes, source documents, metadata records, original photographs, and other workspace material remain canonical source material and are not automatically public.

Existing lightweight public profiles may remain under `content/plants/` until a canonical workspace is created and the profile is migrated through this workflow.

---

# Single-Plant Update Workflow

The normal one-photo workflow is interactive:

```bash
abbey plant update
```

The command scans `~/incoming/photos` for supported images with adjacent XMP
sidecars. It reads the plant display name from `XMP-dc:Description`, reads the
capture date from the image, and matches the resulting slug to an existing
canonical plant workspace. The operator selects a photo, confirms the match,
and supplies the status, update title, observation, and optional care note.

Before writing, Abbey shows the metadata-derived incoming rename and runs the
complete plant update as a dry-run preview. A separate confirmation applies
the rename, preserves the paired XMP sidecar in the incoming directory, copies
the photo into the canonical workspace, appends the titled history entry,
updates current-photo and status metadata, and validates the plant.

Use `--incoming DIR` when the intake directory is not the default:

```bash
abbey plant update --incoming /path/to/photos
```

Explicit options remain available for scripting and recovery:

```bash
abbey plant update <slug> \
  --photo /path/to/photo.jpg \
  --title "New Flower Spike" \
  --narrative "A new spike is visible." \
  --care "Watered." \
  --status thriving \
  --date YYYY-MM-DD \
  --dry-run
```

`--title` defaults to `Weekly Update`. An observation date may have only one
update regardless of its title.

---

# Batch Update Workflow

Renamed photo exports can be prepared as a reviewable, date-scoped worksheet:

```bash
abbey plant update-batch prepare ~/incoming/photos --date 2026-08-02
```

The prepare command matches filenames to plant workspace slugs, groups all
photos for each plant, and writes:

```text
working/plant-updates/2026-08-02.yml
```

Worksheets are local, ignored working artifacts because they record the
machine-specific incoming directory. The resulting plant workspace changes
remain the canonical, reviewable repository content.

Plants without matching photos receive a warning and are omitted from the
worksheet. This represents no update for that plant on that date; it is not a
validation failure and does not create an empty history entry.

Plants whose histories already contain an entry for the selected date also
receive a warning and are omitted, even when matching photos remain in the
incoming directory. This prevents an already completed observation from
blocking unrelated updates during apply.

Review the worksheet and provide a narrative for every included plant. A
single photo is automatically selected as current. When an update contains
multiple photos, select one explicitly in the worksheet's `current` field.
Optional care and status values may also be supplied.

Generated worksheets use visibly indented photo lists and a folded-block
placeholder for each required narrative. Replace the complete placeholder with
the observation prose while preserving its indentation. This permits ordinary
apostrophes and quotation marks without additional YAML escaping.

Validate the completed worksheet's YAML and structure independently of
canonical workspace state:

```bash
abbey plant update-batch validate working/plant-updates/2026-08-02.yml
```

Print its reviewed plant slugs for reuse by validation and publication loops:

```bash
abbey plant update-batch slugs working/plant-updates/2026-08-02.yml
```

Preview and apply the completed worksheet with:

```bash
abbey plant update-batch apply working/plant-updates/2026-08-02.yml --dry-run
abbey plant update-batch apply working/plant-updates/2026-08-02.yml
```

Apply validates the complete worksheet before changing any plant workspace.
For each included update it copies every listed photo, populates the dated
history entry's `Photos` section, records the observation and optional care,
and updates the current photo and status metadata. XMP sidecars remain in the
incoming directory and publish-time derivative sanitization remains a separate
workflow.

Apply is recovery-aware. An update whose canonical photos, dated history entry,
current-photo reference, and status date already agree is reported as already
applied and left unchanged. A partially applied or inconsistent update remains
a validation failure and must be reviewed before proceeding.

---

# Design Principles

## One Source of Truth

Each fact should have one canonical location.

Avoid duplicating metadata across multiple documents.

---

## Photo Metadata Philosophy

Photograph metadata is part of the historical record and should be treated with the same care as any written documentation.

### Preserve Original Metadata

Whenever possible, preserve the metadata recorded by the original camera or device.

Do not overwrite original metadata without a documented reason.

### Reconstruct Carefully

When original metadata is missing, metadata may be reconstructed using reliable sources such as:

- Original journals
- Apple Photos or similar photo libraries
- Supporting documents
- ChatGPT-assisted reconstruction based on documented evidence
- Personal recollection when no better source exists

### Never Invent Precision

Do not fabricate dates, locations, or descriptions.

If only an approximate date is known:

- Record the uncertainty in `photo-metadata.md`.
- Embed only the best-supported information.
- Document how the value was determined.

### Verify Changes

After modifying metadata:

1. Verify the embedded metadata using ExifTool.
2. Update `photo-metadata.md`.
3. Record any assumptions or limitations.

### Provenance Matters

Every photograph should remain traceable back to its source.

Whenever practical, preserve:

- Original image
- Original filename
- Original metadata
- Supporting documentation

The goal is to preserve an accurate historical record rather than create a perfect one.

## Separate Facts from Narrative

Structured metadata belongs in `facts.yaml`.

Stories belong in `story.md`.

Historical records belong in `history.md`.

---

## Preserve Original Material

Do not discard source photographs or supporting documents.

Prefer generating published content from preserved source material.

---

## Machine Readable First

The model should be easy to consume from:

- Astro
- Python
- AI Worker
- Future Abbey tooling

---

## Human Friendly

Although optimized for automation, every file should remain understandable and editable by a human.

---

## Validate Before Automating

Use real projects to refine the workflow before building automation around it.

Doctor Robert serves as the reference implementation for the Plant Model.

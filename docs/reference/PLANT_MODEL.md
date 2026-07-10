# Plant Model

This document defines the canonical content model for plants within Abbey Root.

Every plant in the collection follows the same directory structure and metadata conventions. The goal is to maintain a single, machine-readable source of truth that can be consumed by websites, automation, AI workers, and future tooling.

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
├── photo-metadata.md
├── photos/
└── sources/
```

The remainder of this document defines the required files, metadata fields, and conventions used by every plant profile.

---

# Directory Structure

Every plant directory should follow this layout.

```text
working/plants/<slug>/
├── facts.yaml
├── story.md
├── history.md
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

References to important photographs.

```yaml
photos:
  hero: photos/example.jpg
  current: photos/current.jpg
  metadata: photo-metadata.md
```

### Rules

- Use relative paths.
- Hero image represents the plant.
- Current image reflects the most recent overall condition.
- Additional photos belong in `history.md`.

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

# Design Principles

## One Source of Truth

Each fact should have one canonical location.

Avoid duplicating metadata across multiple documents.

---

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

# Plant Template

This directory is the starting point for new plant profiles.

Copy the template into a new slug-named directory, then replace the placeholder content with verified information.

Example:

```bash
cp -R working/plants/_template working/plants/new-plant
```

Then edit:

```text
working/plants/new-plant/
```

---

# Required Files

## facts.yaml

Canonical machine-readable metadata.

Update this file first.

Do not place narrative writing here.

---

## history.md

Chronological record of the plant.

Use this file for:

- Events
- Photos
- Observations
- Notes
- Lessons

Do not rewrite history unless correcting a factual error.

---

## story.md

Short public-facing narrative.

Use `history.md` as the factual source.

Write in Brad's natural voice.

---

## inventory.md

Current physical state of the plant.

Update this when the plant changes significantly.

---

## photo-metadata.md

Tracks photo dates, descriptions, provenance, and verification status.

Use this when metadata is missing, reconstructed, or corrected.

---

## photos/

Store original and recovered images here.

Preserve original metadata whenever possible.

Do not edit original camera files directly.

---

## sources/

Store supporting material here.

Examples:

- Exported conversations
- PDFs
- Research
- Notes
- Reference documents

These files are not intended for direct publication.

---

# Workflow

1. Copy the template.
2. Rename the directory using the plant slug.
3. Complete `facts.yaml`.
4. Add source material.
5. Add photographs.
6. Verify or restore photo metadata.
7. Build `history.md`.
8. Write `story.md`.
9. Update `inventory.md`.
10. Validate the plant against `docs/reference/PLANT_MODEL.md`.

---

# Rules

- Preserve source material.
- Use ISO dates (`YYYY-MM-DD`).
- Use `null` for unknown YAML values.
- Do not guess species, dates, or locations.
- Use relative file paths.
- Keep facts separate from narrative.
- Treat `facts.yaml` as the canonical metadata source.

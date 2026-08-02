# Plant Website Updates

## Purpose

Use this runbook to update existing plant profiles on BradCooke.com. It covers
individual observations, multi-plant batches, manual fact or history
corrections, validation, publishing, and session completion.

Canonical plant material lives under `working/plants/<slug>/`. Files under
`content/plants/`, `generated/plant-publication/`, and
`site/public/images/plants/` are derived by `abbey plant publish`; do not edit
those generated outputs directly.

---

## Start the Session

From the Abbey Root repository:

```bash
git pull
abbey session
git status
```

Begin from a clean working tree. Keep one observation date or one coherent
correction as the session objective.

---

## Individual Plant Update

Use the individual workflow for one plant observation with one photograph:

```bash
abbey plant update <slug> \
  --photo /path/to/photo.jpg \
  --narrative "Current condition and visible changes." \
  --care "Watered." \
  --status thriving \
  --date YYYY-MM-DD \
  --dry-run
```

`--care` and `--status` are optional. Review the preview, then repeat the
command without `--dry-run`.

The command copies the photograph into the plant workspace, appends the dated
history entry, selects the new current photograph, and updates structured
status metadata. It rejects an existing observation for the same date.

Validate and publish the plant as described under **Publish and Verify**.

---

## Multi-Plant or Multi-Photo Update

### 1. Caption and Export

Caption each photo in Apple Photos with the plant name. Export the original
images with IPTC metadata as adjacent XMP sidecars into the incoming directory.

Keep every image and its XMP file together:

```text
IMG_9875.JPG
IMG_9875.xmp
```

### 2. Preview and Rename

```bash
abbey plant rename-exports ~/incoming/photos --dry-run
```

The command validates the complete directory before renaming anything. Missing
sidecars, captions, capture dates, or destination collisions are blocking.
macOS AppleDouble `._*` files are ignored.

After reviewing the proposed names:

```bash
abbey plant rename-exports ~/incoming/photos
```

Multiple photos for one plant and date receive deterministic sequence suffixes:

```text
revolution-2026-08-02-01.jpg
revolution-2026-08-02-01.xmp
revolution-2026-08-02-02.jpg
revolution-2026-08-02-02.xmp
```

### 3. Prepare the Worksheet

Specify the observation date explicitly:

```bash
abbey plant update-batch prepare \
  ~/incoming/photos \
  --date YYYY-MM-DD
```

The worksheet is written to:

```text
working/plant-updates/YYYY-MM-DD.yml
```

Preparation reports:

- `OK` when photos were grouped for a plant
- `WARN ... no photos ... skipped` when that plant has no update that day
- `WARN ... history already has an update ... skipped` when the observation is
  already complete
- `FAIL` when a photo slug does not match a plant workspace, because that can
  indicate a caption error or a missing workspace

Unknown plant photos should be moved aside or given a plant workspace; do not
delete source material merely to make preparation pass.

Preparation never overwrites an existing worksheet. Continue using the
existing worksheet, or move it to a backup filename before regenerating it.

### 4. Complete the Worksheet

For each included plant:

- write a non-empty `narrative`
- add `care` when applicable
- set `status` only when it changed
- select `current` when more than one photo is listed

A single listed photo is selected automatically. Sequence numbers indicate
capture order, not which image is best, so multi-photo current selection must
remain explicit.

Example:

```yaml
- plant: revolution
  photos:
    - revolution-2026-08-02-01.jpg
    - revolution-2026-08-02-02.jpg
  current: revolution-2026-08-02-01.jpg
  narrative: "Steady recovery. The new leaf continues to grow."
  care: "Watered."
  status: null
```

### 5. Preview and Apply

```bash
abbey plant update-batch apply \
  working/plant-updates/YYYY-MM-DD.yml \
  --dry-run
```

Do not continue until every included update reports `OK`. Apply the reviewed
worksheet by removing `--dry-run`:

```bash
abbey plant update-batch apply \
  working/plant-updates/YYYY-MM-DD.yml
```

The command validates the complete batch before writing, copies images into
their plant workspaces, populates each history photo section, and updates
current-photo and status metadata. XMP sidecars remain in incoming.

Do not remove incoming files until the canonical copies, history entries, and
published pages have been verified. Preserve or archive original exports when
they are the authoritative source photographs.

---

## Manual Updates and Corrections

Use manual edits when correcting canonical facts or existing prose rather than
recording a new observation.

### Change Structured Plant Metadata

Edit:

```text
working/plants/<slug>/facts.yaml
```

Examples include:

```yaml
plant:
  genus: Phalaenopsis
  species: amabilis
```

```yaml
rescue:
  date: 2026-03-01
```

Preserve the existing YAML structure and use `null` when a fact is unknown. Do
not duplicate the correction in generated website content.

### Correct History Text

Edit the canonical file directly:

```text
working/plants/<slug>/history.md
```

Use this for spelling, wording, care-note, or observation corrections. Keep the
existing dated-entry structure and photo filenames intact unless the correction
specifically concerns them.

### Correct an Observation Date

An observation-date correction can affect several canonical references. Review
and update all applicable items together:

1. Rename the affected image files in `working/plants/<slug>/photos/` when the
   date is part of their filenames.
2. Change the dated heading in `history.md`.
3. Change the photo filenames listed in that history entry.
4. Update `photos.current` in `facts.yaml` if it references a renamed image.
5. Update `status.updated` only when the corrected observation is still the
   plant's latest status date.

Search for stale references before publishing:

```bash
rg 'old-date|old-photo-name' working/plants/<slug>
```

Do not create a new weekly update merely to correct an existing date.
Historical backfill and revision remain deliberate manual operations until
dedicated Abbey commands exist.

---

## Validate Plant Workspaces

Validate one plant:

```bash
abbey plant validate <slug>
```

Validate several plants and stop on the first failure:

```bash
for plant in plant-one plant-two plant-three
do
  abbey plant validate "$plant" || break
done
```

Optional species or rescue-date warnings are informational. Resolve every
`FAIL` before publishing.

---

## Publish and Verify

Publish one plant:

```bash
abbey plant publish <slug>
```

Publish several plants:

```bash
for plant in plant-one plant-two plant-three
do
  abbey plant publish "$plant" || break
done
```

Publishing validates the workspace, generates website content and publication
manifests, creates sanitized public image derivatives, and removes private
camera and location metadata from those public derivatives. Canonical source
images remain unchanged.

Build the complete site:

```bash
abbey site build
```

Then review:

```bash
git status
git diff
git diff --check
```

Visually inspect the affected plant pages, especially current images,
multi-photo history entries, and any public image whose extension changed.

---

## Capture and Commit the Session

Capture the completed work:

```bash
abbey session capture --title "Descriptive Plant Update Title"
```

Complete the generated session update and journal entry. Include the plants and
observation date, validation and publication results, site build result, and
any warnings or workflow lessons.

Commit canonical plant sources and their generated website outputs together.
Run the normal Abbey review and end-of-session checks before pushing.

---

## Recovery Rules

- A failed rename or batch dry run changes nothing.
- A failed batch apply validation changes nothing.
- An existing worksheet is never overwritten automatically.
- Never edit generated plant Markdown, publication manifests, or public image
  derivatives to correct canonical content.
- If a publish result is wrong, correct the plant workspace, validate again,
  and republish.
- Do not discard incoming originals until successful canonical import and
  publication have been verified.

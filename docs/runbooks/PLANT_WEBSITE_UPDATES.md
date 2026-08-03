# Plant Website Updates

## Purpose

Use this runbook to create and update plant profiles on BradCooke.com. It
covers new-plant onboarding, individual observations, multi-plant batches,
manual fact or history corrections, validation, publishing, and session
completion.

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

## New Plant Onboarding

Use this workflow when a plant does not yet have a canonical workspace under
`working/plants/`. It was validated end to end through Rocky Raccoon's first
real onboarding and publication.

### 1. Prepare and Verify the Initial Photo

Caption the photo with the plant's final display name and export the original
image with an adjacent XMP sidecar into the incoming directory:

```text
IMG_9896.JPG
IMG_9896.xmp
```

Preview the metadata-derived rename before changing anything:

```bash
abbey plant rename-exports ~/incoming/photos --dry-run
```

The proposed slug must match the intended plant slug. If the caption is wrong,
correct the XMP description and repeat the dry run:

```bash
exiftool \
  -XMP-dc:Description="Plant Name" \
  ~/incoming/photos/IMG_9896.xmp

abbey plant rename-exports ~/incoming/photos --dry-run
```

ExifTool retains a recoverable `_original` backup unless explicitly told not
to. Apply the rename only after the preview is correct:

```bash
abbey plant rename-exports ~/incoming/photos
```

### 2. Create the Canonical Workspace

Create the workspace with verified identity and initial-state facts:

```bash
abbey plant new <slug> \
  --name "Plant Name" \
  --type orchid \
  --status recovering \
  --date YYYY-MM-DD \
  --photo ~/incoming/photos/<slug>-YYYY-MM-DD.jpg
```

The command:

- refuses to overwrite an existing workspace
- copies the initial photograph into `working/plants/<slug>/photos/`
- copies an adjacent matching XMP sidecar when present
- assigns the first photo to the hero and current roles
- creates the canonical Plant Model documents and required directories
- validates the created workspace immediately

Confirm that the command reports the expected photo and XMP import counts.

### 3. Complete Verified Facts

Edit:

```text
working/plants/<slug>/facts.yaml
```

Record known botanical identity, acquisition source and location, current
location, care, container, and tags. Use full location names such as `Texas`
and `United States`. Preserve `null` for facts the tag or direct observation
does not establish; do not guess a species or hybrid status merely because the
plant is a retail Phalaenopsis.

Typical rescue tags are:

```yaml
tags:
  - orchid
  - orchid-rescue
  - phalaenopsis
  - rescue-plant
```

### 4. Replace Scaffold Content

Replace every template section with verified plant-specific content:

- `inventory.md` — current leaves, roots, flowers, potting, concerns, and
  monitored conditions
- `history.md` — dated acquisition event, initial photo, observations, care
  already performed, and next steps
- `story.md` — concise public narrative grounded in the history
- `photo-metadata.md` — filename, capture date, description, metadata sources,
  correction history, and ExifTool verification

When later information changes an initial observation, update all affected
canonical documents together. For example, a newly confirmed yellowing leaf
belongs in both current inventory and the dated rescue history.

### 5. Validate Readiness

Run validation after each coherent group of edits:

```bash
abbey plant validate <slug>
```

Template-placeholder warnings are actionable and should be resolved before
publication. An optional-field warning may be an honest final state; for
example, `plant.species: null` is correct when the retail tag did not designate
a species.

Search directly for stale scaffold markers before publishing:

```bash
if rg -n 'TODO|Entry Template|example\.jpg|Describe the event' \
  working/plants/<slug>
then
  echo "FAIL placeholder content remains"
else
  echo "PASS no placeholder content remains"
fi
```

Continue with **Publish and Verify**, then **Capture and Commit the Session**.
Do not remove or overwrite the incoming originals until canonical source
preservation and public derivative sanitization have both been verified.

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

Inspect the generated page and publication manifest:

```bash
slug="<slug>"
sed -n '1,160p' "content/plants/$slug.md"
python3 -m json.tool "generated/plant-publication/$slug.json"
```

For a new import, compare the canonical photograph and XMP sidecar with their
reviewed incoming sources:

```bash
photo="<photo>"
cmp -s \
  "$HOME/incoming/photos/$photo.jpg" \
  "working/plants/$slug/photos/$photo.jpg" \
  && echo "PASS canonical photo preserved"

cmp -s \
  "$HOME/incoming/photos/$photo.xmp" \
  "working/plants/$slug/photos/$photo.xmp" \
  && echo "PASS canonical XMP preserved"
```

The publication manifest must report `canonical_original_preserved: true`,
`source_hash_unchanged: true`, and `private_metadata_detected: false` for every
derivative. Confirm directly that each public image exposes no private fields:

```bash
for image in "site/public/images/plants/$slug"/*.{jpg,jpeg,png,webp}
do
  [[ -e "$image" ]] || continue
  metadata="$(
    exiftool -s3 \
      -GPSLatitude -GPSLongitude -GPSPosition \
      -SerialNumber -InternalSerialNumber \
      "$image"
  )"
  if [[ -n "$metadata" ]]; then
    echo "FAIL private metadata found: $image"
    printf '%s\n' "$metadata"
  else
    echo "PASS no private metadata: $image"
  fi
done
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

---
title: "Original Plant Image Role for BradCooke.com Session 3"
description: "Added optional explicit Original-photo validation and export support, with four evidence-backed selections exported and validated locally."
date: 2026-08-30
status: pending
reviewed: false
session: original-plant-image-role-for-bradcooke-com-session-3
tags:
  - Abbey Root
  - plants
  - metadata
---

# Original Plant Image Role for BradCooke.com Session 3

## Objective

Support the shared BradCooke.com orchid template with explicit Original-photo
metadata while retaining canonical plant ownership in Abbey Root.

## Definition of Done

- Add optional `photos.original` validation and sanitized `originalImage` export.
- Keep absent selections compatible and do not infer image roles from filenames.
- Establish only selections supported by existing photographic provenance.
- Test the extension and capture the ownership/approval boundary.
- Do not commit, push, or deploy either website.

## Summary

Added the optional Original role to Abbey's existing plant model, template,
validator, exporter, and regression suite. Four verified selections in canonical
facts were exported after explicit user approval of local generated-file writes.
BradCooke.com now has the four Original fields, provenance records, and sanitized
derivatives. No commit, push, website publication, or deployment occurred.

The full Session 3 implementation, evidence table, browser validation, data gaps,
and deferred cleanup are recorded in the owning BradCooke.com repository:
`/home/bcooke/git/brad6887.github.io/docs/session-updates/2026-08-30-bradcooke-com-redesign-session-3-orchid-page-template.md`.
This linked record avoids duplicating that session report.

## Accomplishments

- `docs/reference/PLANT_MODEL.md` defines Original as the earliest/first
  documented photograph, Current as the latest representative view, and Hero
  as the curated visual, which may share an image with another role.
- The workspace template leaves Original null for explicit review. Existing
  onboarding and update behavior is unchanged; first-import order does not
  establish historical chronology.
- Validation accepts absent Original and rejects missing or out-of-workspace
  references. Existing Hero/Current/Index behavior remains compatible.
- The exporter uses its existing sanitized-image/provenance pipeline and
  records the `photos.original` role in the publication manifest. It emits
  `originalImage` only when a canonical selection exists.
- Added one facts field each for Lady Madonna, Rocky Raccoon, Revolution, and
  Honey Pie, based on their existing photo-metadata records. No narratives,
  original photographs, sidecars, Current selections, or Hero selections changed.

## Impact

BradCooke.com can present three explicit visual roles without a second
canonical data store or filename heuristics. The site remains independently
buildable from its exported imports.

## Validation

- Confirmed a clean starting `main` and expected remote on ubuntu-dev01.
  Reviewed repository instructions, planning, Plant Model, and provenance.
- Ran `abbey session` and `abbey review`. Existing dependency and infrastructure
  recurring reviews remain outside this bounded session.
- `bash tests/test-abbey-plant.sh`: 135 passed, zero failed, including absent,
  missing, unsafe, and valid Original references and sanitized export provenance.
  Test exports used disposable fixture projects only.
- `abbey plant validate` passed for each of the four real changed workspaces.
  Existing unknown-species warnings and Lady Madonna's unknown rescue date
  remain; no facts were invented to suppress them.
- Reviewed tracked/untracked diffs, whitespace, and session metadata. Abbey
  review reports the deliberately omitted journal entry, consistent with the
  supported capture override recorded below.
- Auto-review initially rejected the local `abbey plant publish-batch` action
  under the no-publication instruction. No alternate export path was used.
  On 2026-08-30 the user explicitly approved local export of Lady Madonna,
  Rocky Raccoon, Revolution, and Honey Pie with no commit, push, or deployment.
  The same Abbey command then successfully exported those four plants.
- Verified Original source/derivative hashes, versioned URLs, preserved source
  flags, and absence of private metadata. Each existing manifest record and
  generated image remains unchanged; the four generated Markdown imports gained
  only `originalImage`, with every source body preserved.
- BradCooke.com rebuilt successfully and passed route, chronology, desktop/mobile,
  and populated-image checks. All four exported plants display Original, Current,
  and Hero. Seven others retain a missing-Original fallback pending review.
- No staging, commit, push, website build/publication from Abbey Root, or
  infrastructure deployment occurred. BradCooke.com's own build and browser
  validation are recorded in its Session 3 update.

## Lessons Learned

Original and Hero describe different responsibilities. Even a curated bloom
photograph may be months or years newer than the first documented image.
Optional explicit metadata preserves that distinction without inventing facts.

## Next Steps

- Review the seven remaining Original selections from canonical evidence.
- Keep individual narrative and approximate-date cleanup for a later session.

## Notes

This is the canonical-tooling part of one BradCooke.com redesign session.
Captured through Abbey with `--no-journal`, its supported per-session override,
so the linked session records remain the only new narrative documentation.
Abbey Root's project-wide required journal policy was not changed. No public
journal entry, commit, push, or deployment was requested or performed. Capture
status remains `pending` and `reviewed: false` for later planning review; the
implementation and approved local export are complete.

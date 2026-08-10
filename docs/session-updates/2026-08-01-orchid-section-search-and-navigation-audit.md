---
title: "Orchid Section Search and Navigation Audit"
description: "Audit Orchid Rescue search metadata, indexing, images, and internal navigation before planning fixes."
date: 2026-08-01
status: completed
reviewed: true
session: orchid-section-search-and-navigation-audit
tags:
  - Abbey Root
---

# Orchid Section Search and Navigation Audit

## Objective

Audit the Orchid Rescue index and every orchid profile for page titles, meta
descriptions, sitemap and indexing behavior, image metadata, and internal links.
Record evidence and prioritize follow-up work without broadly changing the site.

## Definition of Done

- Every orchid source entry and generated public profile is included in the audit.
- Page titles and meta descriptions are checked in source and built HTML.
- Sitemap, robots/indexing configuration, and generated output are verified.
- Image filenames, alt text, captions, and available file metadata are assessed.
- Internal links are inventoried and the built site is checked for broken links.
- Findings are recorded with affected files, evidence, priority, and focused next
  sessions.

## Summary

Audited the Orchid Rescue index, shared profile route, Coming Soon page, all 10
published orchid sources, all 216 public orchid images, and the generated HTML.
The section builds cleanly and has complete image references and valid internal
links, but it lacks basic search-discovery output, exposes GPS-bearing EXIF in
44 public images, and provides limited descriptive and cross-profile context.

## Prioritized Findings

### P0 — Public images retain GPS EXIF

- A recursive metadata check found `GPS-Data` in 44 files under
  `site/public/images/plants/`.
- Affected profiles: Doctor Robert (3), Honey Pie (7), Lady Madonna (5), Martha
  My Dear (10), Mother Nature's Son (4), Phal McCartney (4), Revolution (5),
  and Something (6).
- The public assets are copied from canonical plant workspaces, while
  `docs/reference/PLANT_MODEL.md` currently emphasizes preservation of original
  camera metadata. That is appropriate for canonical originals but unsafe as a
  default public-asset policy.
- Recommendation: make public-image privacy a focused session. Preserve
  originals and provenance in `working/plants/`, strip GPS and other private
  fields only from generated public copies, add deterministic validation, and
  republish affected assets.

### P1 — No sitemap or robots output

- `site/astro.config.mjs` contains only `defineConfig({})`; no production `site`
  URL or sitemap integration is configured.
- The production build emits none of `sitemap.xml`, `sitemap-index.xml`,
  `sitemap-0.xml`, or `robots.txt`.
- `docs/planning/BACKLOG.md` already contains the open item “Generate sitemap”
  at line 406.
- Recommendation: configure the canonical site URL, Astro sitemap generation,
  and a minimal robots file; verify all 10 published orchid URLs occur exactly
  once and draft/utility routes follow an explicit policy.

### P1 — Missing canonical URLs and incomplete indexing policy

- `site/src/layouts/Layout.astro` renders title and optional description only;
  generated pages have no `rel="canonical"` and no robots meta directive.
- `site/src/pages/orchid-rescue/coming-soon.astro` builds as a normal indexable
  page even though it is a shared placeholder. It is currently not linked by
  any orchid card because all 10 orchids are published, but it remains a public
  route.
- Recommendation: add canonical URL support in the shared layout and decide
  whether Coming Soon should be `noindex,follow`, omitted, or retained as an
  indexable utility page. Apply the same decision to future draft cards.

### P1 — Search snippets do not yet explain most individual rescues

- `site/src/pages/orchid-rescue/index.astro` supplies no description, so the
  built index has no meta description.
- All 10 profile pages do have descriptions. Eight use the near-identical
  template “rescue and recovery story ... rescued from neglect”; only Martha
  My Dear and Something identify a distinctive source or condition.
- Profile titles are consistently generated as
  `<Beatles name> | Orchid Rescue | Brad Cooke`. They identify the collection
  but omit species, condition, or rescue angle; the Beatles names alone do not
  express likely search intent.
- Canonical description changes belong in each
  `working/plants/<slug>/facts.yaml`, not directly in generated
  `content/plants/*.md`. Title strategy belongs in the shared route and may
  require a new canonical override only if the reusable title cannot be derived
  from existing species and story data.
- Recommendation: run one focused metadata-writing session covering the index
  and 10 profiles, keeping names prominent while adding accurate species,
  source, problem, or recovery context.

### P2 — Image discovery and accessibility context are structurally complete but weak

- All 216 public orchid images are referenced, and all 216 references resolve.
  This includes 192 timeline images, 10 hero images, 10 current images, and 4
  dedicated index images.
- Every generated `<img>` has non-empty alt text. However, 48 timeline image
  instances reuse alt text within the same page because multiple photographs
  share the plant/date/event label. Bungalow Bill alone has seven images named
  “Clearance Rescue,” and Mother Nature's Son has seven named “Root Cleanup and
  Repot.”
- The build emits zero `<figcaption>` elements. Timeline headings and following
  observations provide useful surrounding text, but the photograph-specific
  captions in canonical history do not become semantic captions.
- Every public filename is generic: 192 `photo-N` names plus `hero`, `current`,
  and `index`. Stable names are operationally useful, but they provide little
  standalone image-search context.
- Recommendation: preserve stable URLs, but extend the plant publisher to emit
  unique photograph-specific alt text and semantic captions from canonical
  history. Consider descriptive aliases or a documented stable-name tradeoff
  instead of mass-renaming existing URLs.

### P2 — Internal linking is valid but shallow

- A generated-site check found zero broken internal links on the Orchid Rescue
  index and profile pages.
- The index links to all 10 published profiles. Each profile links back to the
  index, and the global navigation also links to the index.
- No orchid source contains a contextual link to another orchid or supporting
  article. Profiles have no previous/next, related-rescue, species, problem, or
  timeline-topic links. Index cards expose only each Beatles name and image,
  with no species, status, or rescue summary as link context.
- Recommendation: first improve index-card context from existing metadata,
  then add a derived previous/next or related-profile component. Defer
  editorial cross-links until practical orchid articles exist.

## Accomplishments

- Reviewed `docs/planning/PROJECT_STATUS.md`, `docs/planning/NEXT.md`, the current
  Abbey session state, repository instructions, and site-specific instructions.
- Defined this audit before inspecting implementation details.
- Inventoried source and generated metadata for the index, Coming Soon page,
  and all 10 published orchid profiles.
- Checked all 216 public orchid images for references, filenames, alt text,
  captions, and embedded metadata indicators.
- Built the Astro site and inspected generated HTML, discovery files, internal
  links, and image targets.
- Reconciled the confirmed findings and broader follow-up audits into
  `docs/planning/BACKLOG.md`, refining existing discovery and image-automation
  entries instead of creating duplicate sources of truth.

## Impact

The project now has an evidence-backed sequence for improving Orchid Rescue
discovery without mixing privacy, infrastructure, metadata writing, and
navigation into one broad change. The GPS finding should be addressed before
traffic promotion because it is a publication-safety issue rather than an SEO
enhancement.

## Validation

- `bash tools/bin/abbey-session` — reviewed repository and session state.
- Astro production build — passed; 142 pages built, including the Orchid Rescue
  index, Coming Soon, and all 10 published profiles.
- Generated HTML audit — 12 Orchid Rescue routes checked; all expected titles
  rendered, all 10 profiles rendered descriptions, index description absent,
  canonical and robots directives absent.
- Internal-link check — zero broken links across Orchid Rescue generated pages.
- Image-reference check — 216 referenced, 216 present, zero missing, zero
  unreferenced public orchid assets; every generated image has non-empty alt.
- Embedded-metadata check — 44 public images reported GPS EXIF.
- Discovery-output check — sitemap and robots files absent from `site/dist/`.
- Environment note — bundled tooling did not provide `npm`; the validation build
  used Astro 7.1.6 allowed by `package.json` rather than the 7.0.3 version in
  `package-lock.json`. Findings were verified directly against source and built
  output, but the locked build should be rerun in the normal Abbey environment
  during the first implementation session.

## Lessons Learned

Canonical image metadata and public image metadata need different preservation
policies. The Plant Model correctly values provenance, but publishing originals
unchanged can disclose private location data. Public derivatives should retain
the visual and historical value without carrying every private camera field.

The shared Astro routes make most search improvements reusable. Sitemap,
canonical URLs, index description, card context, and related navigation can be
implemented once rather than hand-maintained per orchid. Narrative descriptions
and photograph-specific text should continue to originate in canonical plant
workspaces.

## Next Steps

Recommended focused sessions, in order:

1. **Public image privacy pipeline:** strip GPS from generated public copies,
   validate the rule, regenerate all affected assets, and verify canonical
   originals remain unchanged.
2. **Site discovery foundation:** configure production site URL, canonical URLs,
   sitemap, robots output, and the Coming Soon indexing policy.
3. **Orchid metadata writing:** add the index description and rewrite the 10
   search titles/descriptions from canonical facts and real rescue narratives.
4. **Image semantics:** derive unique alt text and semantic captions from
   canonical history without breaking stable image URLs.
5. **Orchid navigation:** enrich index cards and add derived previous/next or
   related-profile links; later connect practical articles to real profiles.

## Notes

This was intentionally an audit and planning session. No production site,
canonical plant content, generated plant content, or public images were
changed. Tracked changes are limited to this session update and the reconciled
backlog entries.

---
title: "Plant Index Image Selection"
description: "Plant index thumbnails can now be selected independently from hero and current-condition photographs."
date: 2026-07-31
draft: false
tags:
  - Abbey Root
  - Abbey Framework
  - Developer Toolkit
  - Plant Model
  - BradCooke.com
---

# Plant Index Image Selection

Until today, the photograph shown on the Orchid Rescue index was not really an
index photograph.

The index used the plant's current image when one was available and fell back to
the hero image otherwise. That worked, but it meant a photograph chosen to
document the plant's current condition also had to work as a small 4:3
thumbnail.

Those are not always the same job.

A current photograph should accurately show how the plant looks now. An index
photograph should look good when cropped into a small card on the Orchid Rescue
page.

The Plant Model now treats them as separate roles.

The new command is:

    abbey plant index <slug>

It uses the same numbered image-selection workflow as:

    abbey plant hero <slug>

The selected image is stored in the plant's canonical `facts.yaml` file as:

    photos:
      index: photos/example.jpg

Publishing copies that source photograph to a stable public path:

    /images/plants/<slug>/index.jpg

The generated plant content records it as `indexImage`, and the Orchid Rescue
page now checks image roles in this order:

    indexImage
    currentImage
    heroImage

That fallback order means existing plants keep working even when no dedicated
index photograph has been selected.

As part of the change, `photos.index: null` was added to the plant template and
all existing plant workspaces. This establishes the field without forcing every
plant to choose an index image immediately.

Martha My Dear was the first real end-to-end test.

I selected photo 5 with:

    abbey plant index martha-my-dear

Her canonical image roles now include:

    hero: photos/Martha - 1.JPG
    current: photos/Martha - 5.JPG
    index: "photos/Martha - 5.JPG"

In this case, the current and index roles happen to use the same photograph.
That briefly made the distinction confusing because the website looked the
same.

The important difference is where the photographs are used.

The current image appears on Martha's individual plant page as her latest
documented condition.

The index image appears on the main Orchid Rescue page as Martha's thumbnail.

They may currently point to the same source file, but either role can now be
changed without changing the other.

Publishing Martha created:

    /images/plants/martha-my-dear/index.jpg

The source photograph and published index image had the same SHA-256 hash:

    8fe1f86e832ba49d91d7218d8b3773aaba572755a8a91262f195ceb5f5468568

The generated frontmatter contained:

    indexImage: /images/plants/martha-my-dear/index.jpg

The final built Orchid Rescue page also referenced that exact index path rather
than falling back to the current image.

Regression coverage was expanded along with the feature.

The image-selection suite now confirms that selecting an index photograph:

- updates `photos.index`
- leaves `photos.hero` unchanged
- leaves `photos.current` unchanged
- works through the Plant Model wrapper in an external Abbey project

The Plant Model suite now confirms that:

- an unset index image remains valid
- a configured index image must exist
- publishing creates the stable public index file
- the published file matches the configured source
- generated frontmatter contains `indexImage`

Final validation included:

- 54 image-selection assertions passed
- 67 Plant Model assertions passed
- 29 external-project portability assertions passed
- deterministic CLI documentation passed
- `git diff --check` passed
- the Astro production build completed with 140 pages
- the local preview server restarted successfully

This was a good example of the generic image-role framework paying off almost
immediately.

The image-selection logic did not need to be rebuilt. The new feature was
mostly a matter of defining another role and carrying it through validation,
publishing, generated metadata, and the website.

The Orchid Rescue index can now use the photograph that works best as a
thumbnail without changing the visual record of the plant's current condition.

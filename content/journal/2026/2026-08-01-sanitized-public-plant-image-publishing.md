---
title: "Keeping the Orchids, Removing the Coordinates"
description: "Abbey now creates smaller, privacy-safe public plant images while preserving the original photographs and their metadata."
date: 2026-08-01
tags:
  - abbey
  - plants
  - publishing
  - privacy
  - images
---

# Keeping the Orchids, Removing the Coordinates

Today I discovered that the plant photos being published to the website were
still carrying all the metadata from the original files.

That included useful historical information, but it also included things that
definitely did not belong on a public website: precise GPS coordinates, phone
details, capture timestamps, Apple metadata, embedded thumbnails, and device
identifiers.

The originals should keep all of that information. They are the canonical
historical record, and I do not want the publishing process modifying them.

The public copies are a different story.

I started with one new photo of Martha My Dear and worked through the process
manually. The original was hashed, inspected, and left untouched. A separate
public version was created that:

- applied the correct orientation
- converted the image to sRGB
- resized it to a maximum of 2400 pixels
- removed all embedded metadata
- reduced the file from about 3.8 MB to about 603 KB

The result looked slightly less vibrant than the original Display P3 image, but
it still looked good enough for the website.

Once the manual process worked, I turned it into a reusable Abbey image helper
and added it to `abbey plant publish`.

Plant publishing now creates sanitized derivatives instead of copying original
photos directly into the public website. It verifies that the original file did
not change and rejects the public copy if potentially private metadata remains.

Each publish run also creates a non-public manifest under
`generated/plant-publication/`. The manifest records the source and derivative
hashes, dimensions, transformation settings, tool versions, and publication
role without copying the private metadata itself.

After the new workflow was working, I audited the existing public plant image
collection.

The audit inspected 216 images and found 154 older public copies containing
camera or private metadata across nine plant profiles:

- Bungalow Bill
- Doctor Robert
- Helter Skelter
- Honey Pie
- Lady Madonna
- Mother Nature's Son
- Phal McCartney
- Revolution
- Something

All nine profiles were republished through the new workflow. Martha My Dear had
already been handled during the proof of concept.

Before republishing, I recorded hashes for every canonical source photograph.
Every original passed the post-publication integrity check.

The final audit confirmed:

- all 216 public plant images were inspected
- no audited private metadata remained
- no public image exceeded 2400 pixels
- every publication manifest matched its source and derivative files
- all canonical originals remained unchanged

The new public-image helper passed eight regression tests. The plant workflow
passed all 72 tests, and the Astro production build completed successfully with
142 pages.

The plant photos on the website are now smaller, correctly oriented, and safe
to publish while the complete originals remain preserved in the canonical
plant workspaces.

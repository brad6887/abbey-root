---
title: "Plant Batch Template Filtering"
description: "Removed the reusable plant template from batch update warnings after the first real worksheet run."
date: 2026-08-02
draft: false
tags:
  - Abbey Root
---

# Plant Batch Template Filtering

## Summary

The first real batch worksheet successfully found nine plant updates and
exposed one small discovery issue: Abbey treated `_template` as though it were
a plant without photos. Template directories are now excluded.

## Accomplishments

- Ignored underscore-prefixed plant template directories during batch discovery.
- Preserved blocking validation for photos that name an unknown plant.
- Added focused regression coverage.

## Lessons Learned

- Workspace discovery should encode repository conventions rather than treating
  every directory as an active domain record.

## Next Steps

- Continue with worksheet review and dry-run apply of the real August 2 batch.

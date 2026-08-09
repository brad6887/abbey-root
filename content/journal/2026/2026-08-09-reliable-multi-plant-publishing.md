---
title: "Reliable Multi-Plant Publishing"
description: "Abbey's weekly orchid publisher became serialized, transactional, deterministic, and cache-aware."
date: 2026-08-09
draft: false
tags:
  - Abbey Root
  - BradCooke.com
  - Orchid Rescue
---

# Reliable Multi-Plant Publishing

## Summary

The August 9 orchid update succeeded, but it exposed several weak boundaries in the publishing workflow: a shell loop was difficult to observe safely, concurrent work could overlap, republishing deleted an unrelated proof image, non-interactive builds could not find NVM's npm, and stable image URLs allowed browsers to keep showing the prior week's photograph.

This session turned those observations into platform improvements. `abbey plant publish-batch` now publishes an explicit list of plants serially and stops on the first failure. Each plant is generated in an isolated staging directory and committed as one unit. Cleanup removes only files owned by the previous publication manifest, and a per-plant lock rejects overlapping work on the same orchid.

Published image URLs now carry a short derivative hash, so a changed current photograph has a changed browser URL. PNG generation was also made deterministic by excluding generated date and time chunks; unchanged images now keep the same hash across repeated publication.

Abbey site commands can discover npm in a standard NVM installation even in a non-interactive SSH session. The repaired workflow republished all eleven August 9 orchids and built the complete 170-page site successfully.

## Accomplishments

- Added a supported serialized multi-plant publication command.
- Made plant publication staged, atomic, and manifest-owned.
- Preserved unrelated public proof artifacts during republishing.
- Prevented overlapping publication of the same plant.
- Added deterministic content-versioned public image URLs.
- Added automatic NVM npm discovery for site commands.
- Expanded regression coverage and updated the operator runbook.

## Lessons Learned

- Unique temporary directories solve collision risk, but final output still needs an explicit owner; the plant lock provides it.
- Cache hashes require deterministic derivative bytes, not merely visually identical images.
- A recurring multi-item workflow deserves a first-class Abbey command with observable progress and completion.

## Next Steps

- Review the final change set with `abbey review`.
- Commit and push the completed workflow repair.

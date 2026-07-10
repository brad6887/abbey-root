



⸻

title: “Doctor Robert Plant Publishing Workflow”
description: “Completed the first end-to-end Plant Model publishing workflow by generating and publishing Doctor Robert from a canonical workspace.”
date: 2026-07-10
draft: false
tags:

* Abbey Root
* BradCooke.com
* Plant Model
* Orchid Rescue

⸻

Doctor Robert Plant Publishing Workflow

Summary

Completed the first end-to-end publishing workflow for the Abbey Root Plant Model using Doctor Robert as the reference implementation.

The new workflow generates Astro content from the canonical plant workspace under working/plants/, copies only selected public photographs into the website, and leaves working notes, source documents, metadata sidecars, and unselected images outside the published site.

Doctor Robert is now published on BradCooke.com using the Plant Model as the single source of truth.

Accomplishments

* Added abbey plant publish <slug> to the Abbey developer toolkit.
* Preserved abbey plant validate <slug> as a required pre-publishing check.
* Generated content/plants/doctor-robert.md from:
    * facts.yaml
    * story.md
    * history.md
* Generated Astro front matter from canonical plant metadata.
* Removed duplicate top-level headings while assembling the published Markdown.
* Published only the configured hero and current-condition photographs.
* Renamed published assets to stable filenames:
    * hero.jpeg
    * current.png
* Kept inventory files, source PDFs, XMP sidecars, photo metadata, and unselected photographs private.
* Added heroImage and currentImage fields to the Astro plant content schema.
* Updated the plant detail page to display:
    * Hero image
    * Plant status
    * Species
    * Acquisition date
    * Story and recovery history
    * Current-condition image
    * Last updated date
* Successfully built all Astro pages with abbey site build.
* Verified that the generated Doctor Robert page contains the published history and both selected images.
* Visually reviewed the page through the Abbey development server.

Lessons Learned

* The existing Astro plant collection and dynamic route were flexible enough to support the Plant Model without replacing the website architecture.
* Publishing should remain an explicit step separate from abbey site build.
* Source filenames should not determine public website filenames.
* The working plant directory can contain much more material than the published page without exposing private or unnecessary files.
* Markdown source documents should remain readable on their own, while the publisher handles small transformations such as removing duplicate page titles.
* Building a real plant profile exposed useful publishing requirements without requiring major changes to the Plant Model.

Next Steps

* Capture this implementation in a session update.
* Review the generated changes before committing.
* Update the Doctor Robert inventory checklist to reflect completed work during the next documentation update.
* Fix the duplicate BradCooke.com priority in docs/planning/NEXT.md during the next documentation update.
* Use the proven workflow for the next plant profile before expanding the Plant Model or publishing automation further.

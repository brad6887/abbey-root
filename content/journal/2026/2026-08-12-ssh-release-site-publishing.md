---
title: "Publishing Without Crossing the Streams"
description: "Abbey gained a project-owned SSH release publishing workflow, and Bread Pitt became the first site to prove it against sites01."
date: 2026-08-12
tags:
  - abbey
  - publishing
  - sites01
  - bread-pitt
  - infrastructure
---

# Publishing Without Crossing the Streams

Today I finally fixed a problem that had been bothering me since Bread Pitt
started becoming a real project of its own.

`abbey site publish` knew how to publish a website, but it still carried too much
knowledge about the site it had originally been built around. Running it from
Bread Pitt could lead toward the BradCooke.com publishing path, which is exactly
the kind of hidden assumption Abbey is supposed to eliminate.

The answer was to make the project the source of truth.

Bread Pitt now declares its own publishing configuration:

- publishing method: `ssh-release`
- target: `abbey-deploy@sites01:/srv/www/breadpitt.net`
- domain: `breadpitt.net`

Abbey reads that configuration and performs the deployment without needing any
Bread Pitt-specific publishing logic.

The more important part is how the deployment works.

A publish does not copy files directly over the active website. Abbey builds the
site locally, runs the normal site validation, checks the remote destination,
creates a timestamped release directory, uploads the generated artifact, and
compares the uploaded copy against what was validated locally.

Only after all of that succeeds does Abbey change the `current` symlink.

That distinction matters because I had already managed to demonstrate the bad
version of this workflow during the earlier sites01 staging work. A failed
release preparation and a separate activation step allowed `current` to point
at an empty release. Nothing catastrophic happened, but it exposed exactly the
failure mode the real workflow needed to prevent.

Now preparation and activation have a hard boundary between them.

For the first real test, Bread Pitt built successfully, passed its Abbey site
validation, uploaded about 25 MB to a new release on sites01, matched the local
artifact during checksum validation, and then atomically changed:

`/srv/www/breadpitt.net/current`

from:

`/srv/www/breadpitt.net/releases/bootstrap`

to:

`/srv/www/breadpitt.net/releases/20260812T121353Z`

Abbey then asked nginx for `breadpitt.net` locally on sites01 and got a successful
response. I followed that with checks of the home page, recipes, starter, bakes,
and Bake001 routes. Every one returned HTTP 200.

The public Bread Pitt site is still on GitHub Pages, so none of this required a
DNS cutover. That was useful because it let me prove the entire new deployment
workflow without turning the infrastructure work into a production migration.

This is the kind of Abbey improvement I want more of.

Bread Pitt needed a way to publish to sites01, but the result is not a Bread
Pitt deployment script. It is a reusable Abbey publishing method that another
project can adopt simply by declaring its own target.

The project owns the intent.

Abbey owns the workflow.

And `current` does not move until the release has earned it.

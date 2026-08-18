---
title: "Bringing an Existing Project Into the Abbey"
description: "Artificial Ignorance became the first real test of migrating an established repository into the Abbey Framework."
date: 2026-08-18
tags:
  - abbey
  - framework
  - migration
  - artificial-ignorance
---

# Bringing an Existing Project Into the Abbey

Artificial Ignorance started as an experiment.

It had already grown into a real repository with an API, tests, knowledge
pipelines, a README, Git history, and enough personality problems to require
126 regression tests before I ever officially made it an Abbey project.

That made it a useful test case.

Abbey already knew how to create a new project with `abbey init`, and the
framework adoption guide described what an Abbey project should look like. What
I had never actually done was take an established repository and bring it into
the framework without treating it like a brand-new project.

Artificial Ignorance became the first one.

The first rule turned out to be simple: preserve what already works.

Before changing anything, I pushed the existing Artificial Ignorance history to
GitHub and kept commit `a175210` as the clean pre-migration baseline.

Then I used `abbey init` in a temporary directory.

That was surprisingly useful. It gave me a current example of the minimum Abbey
project structure without touching the real repository. I could look at the
generated `.abbey/project.yml`, session guidance, planning documents, journal
structure, and ignore rules and decide what actually belonged in Artificial
Ignorance.

The answer was a fairly small layer.

Artificial Ignorance kept its existing source tree, tests, scripts, data,
README, and runtime model. Abbey added the project metadata, planning structure,
session workflow, and validation contract around it.

Its project configuration explicitly disables toolkit defaults,
infrastructure, and internal DNS. There is no site or publishing configuration
because Artificial Ignorance does not own those things.

Its existing test workflow became its Abbey validation workflow.

After the migration, Abbey correctly resolved:

    Active project: Artificial Ignorance
    Project root:   /home/bcooke/git/artificial-ignorance
    Toolkit root:   /home/bcooke/git/abbey-root

Project discovery also worked from inside `src/`, `abbey doctor` stayed out of
Abbey Root infrastructure checks, all 126 tests still passed, and the generated
Abbey runtime directories stayed ignored inside the Artificial Ignorance
repository.

That was enough evidence to turn the experience into a real framework
migration guide.

`docs/guide/FRAMEWORK_MIGRATION.md` now describes the process for established
repositories: start from a clean baseline, preserve history, generate a
temporary initializer reference, decide what the project actually owns, add
the minimum Abbey contract, reuse existing validation, verify capability
isolation, exercise the session workflow, and certify the result before
committing it.

It also draws an important line between three things that were starting to blur
together:

    abbey init
        creates a new project

    framework adoption
        defines what an Abbey project owns

    framework migration
        brings an existing project into that state safely

I considered whether this meant Abbey should now have an `abbey adopt` command.

I don't think it does yet.

The file creation is easy to automate. The interesting parts of a migration are
still decisions: which documents already own project knowledge, what validation
should run, what capabilities belong to the project, what should stay untouched,
and what planning state accurately describes work that may have existed for
months before Abbey arrived.

One real migration is enough to write down the workflow.

I want another one before I decide how much of it deserves a command.

The migration also found two small Abbey rough edges.

`abbey init help` currently tries to initialize a project named `Help`, which is
a fairly confident interpretation of the request.

`abbey review` also suggested a commit called `Update Abbey Root session work`
while Artificial Ignorance was the active project.

Both are now backlog items for another day.

The useful result from this session is bigger than either bug.

Abbey now has a tested way to meet an existing project where it already lives,
add the framework around it, and leave the project's working parts alone.

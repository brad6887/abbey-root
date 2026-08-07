---
title: "Surface due recurring reviews during abbey session"
description: "Added recurring review due-state calculation and exposed due reviews during Abbey session startup."
date: 2026-08-07
draft: false
tags:
  - Abbey Root
---

# Surface due recurring reviews during abbey session

Abbey session startup now checks recurring review status.

The recurring review implementation was extended to calculate due dates using each active review's frequency and latest completed occurrence.

Supported frequencies currently include daily, weekly, monthly, quarterly, and yearly reviews.

Calendar-aware calculations are used for monthly, quarterly, and yearly frequencies.

The recurring review command now supports a concise due-review mode and can evaluate reviews from an explicitly supplied Abbey project root.

`abbey session` uses that same implementation and displays a Recurring Reviews section during startup.

During validation, the Documentation Audit review was correctly reported as not due. Its latest occurrence was completed on 2026-08-06 and its frequency is monthly.

This completes the framework path from recurring review definitions and completed occurrences through due-state evaluation and session awareness.

The next work can focus on implementing the actual recurring review types.

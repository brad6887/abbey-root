---
title: "Support infrastructure reviews"
description: "Implemented and validated a recurring Infrastructure Review based on Abbey Doctor."
date: 2026-08-07
draft: false
tags:
  - Abbey Root
---

# Support infrastructure reviews

Abbey now has an executable recurring Infrastructure Review.

The review can be run with:

`abbey review recurring run infrastructure-review`

The implementation reuses `abbey doctor` as the primary source of infrastructure health information.

Doctor continues to report its complete operational view, including warnings that may be expected for the current host or development state.

The Infrastructure Review interprets those results and separates actionable infrastructure findings from expected warnings.

During validation, Doctor reported three warnings: an uncommitted working tree and two backup checks that are intentionally skipped on `ubuntu-dev01`.

The review correctly ignored those warnings for recurring infrastructure review purposes and completed with zero actionable findings.

This provides a reusable pattern for future recurring reviews: rely on existing Abbey commands for authoritative checks, then add review-specific interpretation only where needed.

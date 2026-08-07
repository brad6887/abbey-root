---
title: "Support documentation audits"
description: "Implemented and validated the first executable recurring review type."
date: 2026-08-07
draft: false
tags:
  - Abbey Root
---

# Support documentation audits

Abbey now has its first executable recurring review type.

The Documentation Audit can be run with:

`abbey review recurring run documentation-audit`

The review reuses the existing deterministic documentation checks and also inspects architecture documentation, required planning documents, and unreviewed session updates.

The first real run found a stale generated CLI reference. After regenerating the deterministic documentation, the audit was run again and completed with zero findings.

The public Abbey review dispatcher was also updated so recurring review arguments are forwarded correctly.

CLI metadata now documents recurring review discovery, due-state reporting, and Documentation Audit execution.

This completes the first end-to-end recurring review implementation and provides a working model for the remaining review types.

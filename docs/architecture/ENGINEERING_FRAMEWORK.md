# Abbey Root Engineering Framework

Abbey Root is the research and development environment for reusable engineering frameworks.

The project began as a Linux lab, but it is evolving into a self-documenting, project-aware development platform where documentation, automation, workflows, reporting, and AI share a common source of truth.

## Purpose

The Engineering Framework defines reusable patterns that can be designed, tested, and refined in Abbey Root before being adopted by production engineering projects such as Power Infrastructure.

## Core Frameworks

- Documentation Framework
- Planning Framework
- Session Framework
- CLI Framework
- Workflow Engine
- Workflow Contract
- Reporting Framework
- Knowledge Framework
- Website Publishing Framework

## Design Principle

Build it in Abbey Root.

Prove it in Abbey Root.

Promote it to Power Infrastructure only after the pattern is stable.

## Framework Model

Abbey Root separates framework concerns from project-specific implementation.

The framework provides:

- structure
- orchestration
- validation
- reporting
- documentation patterns
- command-line user experience

Project-specific workflows provide:

- business logic
- environment-specific checks
- operational procedures
- platform-specific implementation

## Relationship to Power Infrastructure

Abbey Root is the engineering laboratory.

Power Infrastructure is the production engineering implementation.

Both projects should remain structurally similar where practical, but each project must retain its own mission and project-specific content.

## Current Focus Areas

- Align Abbey and Power Infrastructure documentation structures.
- Standardize planning document responsibilities.
- Evolve `abbey` and `pwr` as sister CLIs.
- Define the generic Workflow Engine.
- Define the standard Workflow Contract.
- Design reusable report rendering and delivery.
- Use email delivery as the first report delivery test case.

## Initial Framework Stack

```text
Request
    ↓
Session Framework
    ↓
Workflow Engine
    ↓
Workflow Contract
    ↓
Workflow Implementation
    ↓
Reporting Framework
    ↓
Documentation / Archive
```

## Notes

This document should guide future Abbey Root architecture sessions.

When a recurring workflow, reporting pattern, CLI pattern, or documentation structure is discovered, evaluate whether it belongs in the Engineering Framework before implementing it as a one-off feature.

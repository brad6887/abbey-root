# Voice Analysis Project Architecture

## Purpose

The Voice Analysis project exists to develop an evidence-based, reproducible methodology for understanding an author's writing voice.

The primary product of this project is **the methodology itself**, not a profile of any particular author.

Brad Cooke serves as **Case Study #1** for validating and refining the methodology because a large corpus of writing spanning many years is available.

Once validated, the methodology should be applicable to any author's body of work.

---

# Design Principles

## 1. Separate Framework from Research Data

The Abbey Root repository contains the framework used to perform research.

It does **not** contain personal research datasets.

### Framework

- Research methodology
- Documentation
- Analysis tools
- Corpus import tools
- Classification tools
- Validation tools
- Voice modeling tools

### Research Data

Research datasets remain outside the repository.

Examples include:

- Facebook exports
- Email archives
- Personal journals
- Blog archives
- Books
- Interview transcripts
- Future case study material

This separation keeps the framework reusable while protecting personal source material.

---

## 2. Preserve the Chain of Evidence

Every conclusion should be traceable back to the original source material.

Nothing should skip a level.

```text
Raw Data
    ↓
Corpus
    ↓
Evidence
    ↓
Hypotheses
    ↓
Validated Voice Model
    ↓
Derived Outputs
```

For example:

- A Style Guide should be derived from the validated Voice Model.
- The Voice Model should be derived from validated hypotheses.
- Hypotheses should be supported by documented evidence.
- Evidence should reference the corpus.
- The corpus should be reproducible from the original source material.

Every statement should ultimately answer:

> "Why do we believe this?"

---

## 3. Build the Pipeline, Not the Artifact

Whenever possible, automate the process rather than manually producing the result.

Examples:

Instead of creating:

- a cleaned corpus

create:

- a corpus importer

Instead of creating:

- a voice profile

create:

- the methodology that produces a voice profile

Instead of creating:

- an AI prompt

create:

- research that can generate AI prompts

The methodology should generate results rather than depend on manually maintained artifacts.

---

# Repository Responsibilities

Abbey Root contains:

- Research methodology
- Documentation
- Corpus processing tools
- Classification tools
- Validation tools
- Voice analysis tooling
- Evidence management
- Reporting tools

Abbey Root does **not** contain:

- Raw Facebook exports
- Personal email archives
- Generated corpus files
- Temporary research artifacts
- Other private datasets

---

# Research Workspace

Personal datasets are stored outside the repository.

Example:

```text
~/research/

    facebook/
        facebook-2009-2026.zip
        facebook-2025-2026.zip

    voice-analysis/
        working/
        corpus/
        reports/
```

The exact organization may evolve, but research data remains external to Abbey Root.

---

# Processing Pipeline

The project follows a reproducible processing pipeline.

```text
Raw Source Material
        │
        ▼
Corpus Import
        │
        ▼
Corpus Cleaning
        │
        ▼
Corpus Classification
        │
        ▼
Evidence Collection
        │
        ▼
Hypothesis Development
        │
        ▼
Voice Model
        │
        ▼
Derived Outputs
```

Derived outputs may include:

- Voice Profile
- Writing Manual
- Style Guide
- AI Prompting Guide
- Research Reports

Each stage should be reproducible from the previous stage.

---

# Repository Layout

```text
docs/
└── research/
    └── voice-analysis/
        ├── ARCHITECTURE.md
        ├── methodology/
        │   └── METHODOLOGY.md
        ├── case-study-brad/
        │   └── CASE-STUDY.md
        ├── hypotheses/
        │   └── HYPOTHESES.md
        ├── evidence/
        └── validation/
```

Future case studies may be added as additional directories.

Example:

```text
case-study-brad/
case-study-002/
case-study-003/
```

---

# Future Tooling

Long-term, the methodology should be executable through Abbey commands.

Examples:

```bash
abbey voice import facebook

abbey voice classify

abbey voice evidence

abbey voice validate

abbey voice report
```

These commands represent the desired workflow rather than the initial implementation.

---

# Philosophy

The methodology should remain useful even without AI.

AI is a consumer of the research—not the source of truth.

The authoritative chain is:

```text
Raw Data
    ↓
Corpus
    ↓
Evidence
    ↓
Hypotheses
    ↓
Validated Voice Model
    ↓
Derived Outputs
```

If the methodology can be executed by a careful human researcher using only the source material and the documented process, then it is sufficiently well-defined to support automation and AI-assisted analysis.

---

# Read Next

1. ARCHITECTURE.md (this document)
2. methodology/METHODOLOGY.md
3. case-study-brad/CASE-STUDY.md
4. hypotheses/HYPOTHESES.md

These documents progressively move from project architecture, to research methodology, to practical application, and finally to evidence-backed hypothesis development.

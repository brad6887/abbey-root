# Research Review Manifest

## Purpose

A review manifest preserves human decisions in a machine-readable form and binds every reviewed citation to the exact frozen-corpus text.

Markdown evidence artifacts remain the readable research record. The JSON manifest is the deterministic validation record.

## Schema

```json
{
  "schema_version": 1,
  "review_id": "REVIEW-001",
  "evidence_artifact": "EVID-001",
  "review_scope": "canonical_evidence_selection",
  "corpus": {
    "artifact_id": "CORPUS-001",
    "path": "/path/to/clean_corpus.csv",
    "sha256": "..."
  },
  "method": {
    "model": "gpt-oss:20b",
    "prompt": "docs/research/voice-analysis/prompts/example.md",
    "reviewer": "Brad Cooke",
    "review_date": "2026-07-23"
  },
  "items": [
    {
      "review_item_id": "ITEM-001",
      "evidence_role": "supporting",
      "decision": "retain",
      "note": "Concise human-review rationale.",
      "citations": [
        {
          "source_id": "FB-000001",
          "text": "Complete exact corpus text."
        }
      ]
    }
  ]
}
```

## Required Rules

- `schema_version` is `1`.
- `review_id`, `evidence_artifact`, and every `review_item_id` are non-empty.
- `review_scope` is `canonical_evidence_selection` or `complete_candidate_review`.
- Review-item identifiers are unique within the manifest.
- `decision` is `retain`, `provisional`, or `reject`.
- `evidence_role` is `supporting`, `contradictory`, or `comparison`.
- Every item has a human-review note and at least one citation.
- Citation identifiers use `FB-000000`.
- Citation identifiers must resolve in the supplied corpus.
- Citation text must exactly equal the complete corpus text.
- Duplicate citations within one review item are invalid.
- The recorded corpus SHA-256 must match the supplied corpus file.

## Validation

```text
abbey research validate-review \
  --manifest working/research/voice-analysis/REVIEW.json \
  --corpus /home/bcooke/research/facebook/output/clean_corpus.csv
```

Validation is deterministic and does not call an AI model.

## Evidence Units

An item may contain one citation for a single-post observation or multiple citations for a recurring cluster.

Multiple citations within an item assert that the review decision applies to the relationship among those sources.

## Scope

`canonical_evidence_selection` records the reviewed examples used by a canonical evidence artifact.

`complete_candidate_review` asserts that every candidate in the defined candidate set has a recorded decision.

The manifest does not imply complete candidate coverage unless its scope is `complete_candidate_review`.

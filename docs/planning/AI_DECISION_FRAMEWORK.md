Abbey AI Decision Framework

Purpose

The Abbey AI Decision Framework defines how Abbey Root uses artificial intelligence to support repeatable, evidence-based engineering decisions.

The framework treats AI reasoning as an engineering artifact rather than an ephemeral conversation.

A decision should have:

* A defined purpose.
* Authoritative inputs.
* Explicit model and inference settings.
* Structured output.
* Validation.
* Execution metadata.
* Persistent history.
* Support for comparison across models.

The goal is not to place AI everywhere. The goal is to use AI where structured reasoning can improve a recurring engineering decision.

⸻

Vision

Abbey Root should provide a reproducible platform for learning how different AI models perform against real engineering work.

Models should be treated as interchangeable inference engines operating against stable decision definitions.

The framework should make it possible to answer questions such as:

* Which model is most useful for project planning?
* Which model produces the most stable recommendations?
* Which model best follows structured output requirements?
* How much additional value does a larger model provide?
* Which models agree when given the same evidence?
* How do model runtime and resource requirements compare?
* Which decisions benefit from model consensus?
* Which dissenting recommendations deserve human review?

The final decision always remains with the human operator.

⸻

Design Principles

Decisions Are Defined

Each decision is represented by version-controlled configuration, a prompt, and an output schema.

The decision engine should not contain domain-specific knowledge about individual decisions.

Inputs Are Authoritative

Decision definitions explicitly identify the documents used as evidence.

Models must base their conclusions on those supplied documents and identify assumptions separately.

Models Are Interchangeable

A decision may define a default model, but operators can run the same decision against other installed models.

Model selection should not change the decision definition or its evidence.

Outputs Are Structured

Decision results must conform to a defined JSON schema.

Structured output enables:

* Validation.
* History.
* Comparison.
* Reporting.
* Future automation.

History Is Preserved

Every successful decision run produces a JSON artifact containing:

* Decision identifier.
* Model.
* Documents.
* Inference options.
* Execution time.
* Token counts.
* Completion status.
* Structured result.

Generated history is runtime data and is not committed to the repository by default.

Comparison Is Deterministic

Comparing saved decision artifacts should not require another AI request.

Abbey should compare recorded data directly whenever practical.

Consensus and Synthesis Are Separate

Model agreement can be calculated from structured data.

An AI-generated synthesis or jury report is a separate optional workflow and should not replace deterministic comparison.

Humans Remain Authoritative

AI recommendations are evidence for human decisions.

AI must not silently modify authoritative planning documents, execute recommendations, or represent assumptions as confirmed facts.

⸻

Architecture

Decision Definition
        |
        v
Decision Engine
        |
        v
Model Inference
        |
        v
Schema Validation
        |
        v
Decision Artifact
        |
        +------------------+
        |                  |
        v                  v
History Viewer       Model Comparison
                           |
                           v
                    Optional Jury Review

⸻

Decision Definition

Each decision lives under:

config/ai/decisions/<decision>/

A decision currently contains:

decision.json
prompt.md
schema.json

decision.json

Defines execution metadata such as:

* Name.
* Description.
* Default model.
* Input documents.
* Temperature.
* Context size.
* Other inference options.

prompt.md

Defines the question, evaluation criteria, and decision instructions.

schema.json

Defines the required structured response.

Adding a new decision should normally require only a new decision directory and its definition files.

⸻

Decision Engine

The decision engine is exposed through:

abbey ai decide <decision>

A model override may be supplied without modifying the definition:

abbey ai decide --model qwen3:8b time-saver

Model-selection precedence is:

1. Explicit --model override.
2. Model configured by the decision definition.
3. Abbey AI default decision model.

The engine:

1. Loads the decision definition.
2. Resolves the model and inference options.
3. Loads the prompt and schema.
4. Reads the declared source documents.
5. Sends the request to the inference service.
6. Validates the structured response.
7. Displays a human-readable report.
8. Writes the complete JSON history artifact.

⸻

Decision History

Decision history is stored under:

.abbey/ai/history/

History artifacts are organized by date and identify the decision and model in the filename.

Example:

.abbey/ai/history/2026/07/20260716-063507-time-saver-qwen3-8b.json

History can be inspected with:

abbey ai history

The raw JSON artifact is the authoritative record of the AI execution.

Terminal output is a presentation of that artifact.

⸻

Comparison

The comparison layer reads existing history artifacts without invoking a model.

Initial comparison should report:

* Decision.
* Model.
* Recommendation.
* Confidence.
* Runtime.
* Prompt tokens.
* Output tokens.
* Context size.
* Generation time.
* History artifact path.

A future normalized recommendation identifier may support automatic consensus calculation.

Until normalization exists, semantically similar recommendations should not be treated as identical based only on string comparison.

⸻

Evaluation

A future evaluation workflow may run one decision against multiple configured models:

abbey ai evaluate time-saver

Evaluation should:

1. Discover available models from the inference service.
2. Run the same decision definition against each selected model.
3. Preserve an artifact for every successful run.
4. Report failures without discarding successful results.
5. Compare execution metrics and structured recommendations.
6. Avoid AI-generated interpretation during the deterministic evaluation stage.

⸻

Jury

A future jury workflow may ask a selected model to synthesize multiple saved decision artifacts:

abbey ai jury time-saver

The jury should receive structured model results rather than the original planning documents unless the decision definition explicitly requires otherwise.

A jury report may identify:

* Areas of agreement.
* Meaningful disagreement.
* Strong dissenting recommendations.
* Unsupported assumptions.
* Evidence that one model overlooked.
* A possible consensus recommendation.

The jury remains advisory.

⸻

Command Model

Current and planned commands include:

abbey ai ask
abbey ai models
abbey ai decide
abbey ai history
abbey ai compare
abbey ai evaluate
abbey ai jury
abbey ai benchmark

Ask

Free-form project-aware conversation.

Decide

Run one structured decision against one model.

History

Inspect saved decision artifacts.

Compare

Compare existing saved results without invoking AI.

Evaluate

Run a decision against multiple models.

Jury

Use AI to synthesize multiple structured decision results.

Benchmark

Measure model performance against a repeatable suite of Abbey workflows.

⸻

Initial Reference Decision

The first decision is:

abbey ai decide time-saver

It asks which documented Abbey Root improvement is most likely to save Brad the most recurring time.

Initial testing produced agreement between:

* gpt-oss:20b
* qwen3:8b

Both recommended completing abbey-review.

The models differed in runtime, tokenization, response length, confidence, and wording while arriving at the same underlying recommendation.

This result demonstrates the value of preserving structured history and comparing models against identical project evidence.

⸻

Near-Term Work

* Add abbey ai compare <decision>.
* Add a stable normalized recommendation identifier to decision schemas.
* Add model throughput reporting.
* Improve schema validation.
* Record relevant model metadata with decision artifacts.
* Add decision discovery and descriptive listing.
* Evaluate more installed models against time-saver.
* Design abbey ai evaluate.
* Define when AI jury synthesis provides value.

⸻

Future Direction

The Abbey AI Decision Framework should become reusable across Abbey-style repositories.

Potential decision areas include:

Planning

* What should be worked on next?
* What will save the most time?
* Which backlog item should be promoted?
* Which planned work is no longer aligned?

Engineering

* Is a recurring task ready to become an Abbey command?
* Is a subsystem ready for refactoring?
* Which implementation provides the best maintainability?

Documentation

* Which documents appear stale?
* Which sources disagree?
* What should be updated after a session?

Infrastructure

* Which operational risk deserves attention first?
* Which recurring validation should be automated?
* Which host or service needs review?

Publishing

* Which content should be published next?
* Is a page ready for publication?
* Which manual publishing step should be automated?

Structured Personal Projects

* Which plant workspace requires review?
* Which history is incomplete?
* Which source material is ready for publication?

⸻

Guiding Principle

AI should produce reproducible engineering evidence, not invisible authority.

Abbey should use AI to improve human decisions while preserving the source documents, execution settings, structured results, and history required to understand how each recommendation was produced.

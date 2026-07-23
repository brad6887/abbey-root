# Deadpan Prevalence Annotation

Annotate every supplied sample post independently.

Premise labels:

- `absurd_humorous`: the text contains a discernible authored absurd, impossible, fictional, contradictory, or strongly exaggerated humorous premise.
- `other_humor`: humor is discernible, but the premise is not absurd or impossible.
- `non_humor`: no discernible humorous premise.
- `unclear`: missing context prevents a reliable premise decision.

Delivery labels for `absurd_humorous` only:

- `deadpan`: ordinary, literal, practical, procedural, or emotionally restrained wording carries the absurd premise.
- `overt_or_explanatory`: emphasis, explicit explanation, emotional narration, or escalating punctuation carries the absurd premise.
- `mixed`: both modes materially contribute.
- `unclear`: delivery cannot be determined from supplied text.

For every other premise label, delivery must be `not_applicable`.

Do not infer missing images, links, intent, or surrounding conversation. A short post is not automatically deadpan. A funny post is not automatically absurd.

Return one CSV row for every input row, preserving input order:

    source_id,premise,delivery,confidence,note

Confidence is `high`, `medium`, or `low`. Note is one short sentence without commas. Return only the CSV header and rows.

# Quoted-Language Classification Prompt

Classify every supplied quoted-language candidate for a targeted Voice
Analysis review.

The research question is whether quotation marks recur as a deliberate comic
framing device, especially by distancing the writer from a literal label,
renaming something, or setting up a reversal.

Return only one compact raw JSON object. Do not use Markdown fences, notes, or
explanations:

{
  "schema_version": 1,
  "review_type": "quoted_language_classification",
  "items": {
    "FB-000000": "SD-S"
  }
}

Classify every supplied source exactly once and preserve its source identifier.

Use one category code:

- `SD` - quotation marks question, weaken, or create distance
  from the literal term.
- `IR` - quotation marks frame a newly invented,
  altered, or deliberately comic name.
- `DQ` - a quotation attributed to a public figure, song,
  film, publication, or other external source.
- `RS` - speech reported from an interaction or
  overheard exchange.
- `TP` - an ordinary title, product, work, band, badge, quiz,
  or proper name.
- `PC` - platform-generated text, copied prompt,
  survey, badge, or long repost.
- `MN` - the detector matched punctuation that is not
  functioning as quotation.
- `OT` - a quote function not covered above.

Append one relevance code after a hyphen:

- `S` - the quotation itself materially creates comic framing,
  distancing, renaming, or reversal.
- `C` - authored writing, but the quotation performs an ordinary
  function useful as a counterexample.
- `X` - copied, platform-generated, or otherwise unsuitable for voice
  inference.
- `R` - genuinely ambiguous and requiring human judgment.

Examples: `SD-S`, `TP-C`, `PC-X`, `OT-R`.

Use only visible text. Do not infer intent, personality, private facts, or
audience reaction. Do not promote an observation or make prevalence claims.

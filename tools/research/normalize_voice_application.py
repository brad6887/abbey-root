#!/usr/bin/env python3
"""Normalize a fact-locked voice response into standalone JSON."""
import argparse, json, re
from pathlib import Path

def main():
    p=argparse.ArgumentParser(); p.add_argument("--input",type=Path,required=True); p.add_argument("--model",required=True); args=p.parse_args()
    text=args.input.read_text(encoding="utf-8").strip()
    fenced=re.fullmatch(r"```(?:json)?\s*\n(.*)\n```",text,flags=re.DOTALL)
    if fenced: text=fenced.group(1).strip()
    try: value=json.loads(text)
    except json.JSONDecodeError as exc: raise SystemExit(f"Voice application normalization failed: invalid JSON: {exc}")
    if not isinstance(value,dict): raise SystemExit("Voice application normalization failed: JSON root must be an object.")
    for item in value.get("items", []):
        if isinstance(item, dict) and isinstance(item.get("response"), str):
            item["response"] = item["response"].replace('\\"', '"')
    value["model"]=args.model
    args.input.write_text(json.dumps(value,indent=2,ensure_ascii=False)+"\n",encoding="utf-8")
if __name__ == "__main__": main()

from __future__ import annotations
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"

REF_RE = re.compile(r"res://[^\s\"']+")

def real_case_path(root: Path, rel: Path) -> Path | None:
    """
    Returns the real path with real casing by walking each path segment.
    Works on Windows too (case-insensitive but case-preserving).
    """
    cur = root
    for part in rel.parts:
        if not cur.is_dir():
            return None
        matches = [p for p in cur.iterdir() if p.name == part]
        if matches:
            cur = matches[0]
            continue
        # try case-insensitive match to detect case mismatch
        ci = [p for p in cur.iterdir() if p.name.lower() == part.lower()]
        if not ci:
            return None
        # choose the real on-disk name (case mismatch)
        cur = ci[0]
    return cur

def main() -> int:
    if not GAME.exists():
        print("ERROR: 'game' folder not found next to tools/")
        return 2

    files_to_scan = list(GAME.rglob("*.tscn")) + list(GAME.rglob("*.tres")) + [GAME / "project.godot"]
    missing = []
    mismatched = []

    for f in files_to_scan:
        if not f.exists():
            continue
        text = f.read_text(encoding="utf-8", errors="ignore")
        for m in REF_RE.finditer(text):
            ref = m.group(0)
            rel = Path(ref.replace("res://", ""))
            resolved = real_case_path(GAME, rel)

            if resolved is None or not resolved.exists():
                missing.append((f, ref))
                continue

            # Compare path strings (case-sensitive) against the "real" on-disk casing
            real_rel = resolved.relative_to(GAME).as_posix()
            if real_rel != rel.as_posix():
                mismatched.append((f, ref, f"res://{real_rel}"))

    if missing:
        print("\nMISSING REFERENCES (path doesn't exist):")
        for f, ref in missing:
            print(f"  {f.relative_to(ROOT)} -> {ref}")

    if mismatched:
        print("\nCASE MISMATCHES (reference case != actual file case):")
        for f, ref, fix in mismatched:
            print(f"  {f.relative_to(ROOT)}")
            print(f"    has: {ref}")
            print(f"    fix: {fix}")

    if not missing and not mismatched:
        print("OK: No missing refs or case mismatches found. ✅")
        return 0

    return 1

if __name__ == "__main__":
    raise SystemExit(main())

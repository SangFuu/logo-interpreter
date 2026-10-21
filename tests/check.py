"""Compilation et tests des versions executables, sans dependance Python externe."""
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
checks = 0

def execute(folder, source):
    result = subprocess.run([str(folder / "repl_logo")], input=source, text=True,
                            capture_output=True, timeout=5, cwd=folder)
    assert result.returncode == 0, result.stdout + result.stderr
    return result.stdout

folders = sorted(p.parent for p in ROOT.rglob("Makefile")
                 if (p.parent / "logo_lexer.mll").exists()
                 and (p.parent / "logo_parser.mly").exists())
assert len(folders) == 6, folders
for folder in folders:
    subprocess.run(["make", "clean"], cwd=folder, check=True)
    subprocess.run(["make"], cwd=folder, check=True)
    for source in ("", "Avance 10 .\n", "Avance 10\n"):
        output = execute(folder, source)
        assert "Erreur" not in output, output
        checks += 1
    for example in sorted(folder.glob("*.logo")):
        output = execute(folder, example.read_text(encoding="utf-8"))
        assert "Erreur" not in output and "analysé" in output, output
        checks += 1
    output = execute(folder, "@ .\n")
    assert "Lexème non reconnu" in output, output
    checks += 1
    print("OK", folder.relative_to(ROOT), flush=True)

final = ROOT / "Exo03/q4"
for source, expected in (
    ("Def x (1 + 2).\n", "x = 3"),
    ("Def x 0; Repete 3 [Def x (:x + 1)].\n", "x = 3"),
    ("Si (3 > 2) Alors Def x 7 Sinon Def x 8 FinSi.\n", "x = 7"),
    ("Si (3 < 2) Alors Def x 7 Sinon Def x 8 FinSi.\n", "x = 8"),
    ("Def x (1 / 0).\nDef x 7.\n", "x = 7"),
    ("Avance :inconnue.\nDef x 7.\n", "x = 7"),
):
    output = execute(final, source)
    assert expected in output, output
    checks += 1
print(f"{len(folders)} versions compilees, {checks} scenarios reussis.")

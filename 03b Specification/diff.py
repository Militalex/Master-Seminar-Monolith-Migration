import argparse
import os
import subprocess
import sys
from pathlib import Path

def find_typdiff(script_dir):
    candidates = [
        Path("./typdiff.exe"),
        script_dir / "typdiff.exe",
        script_dir / "../typdiff.exe",
        script_dir / "../00 assets/typdiff.exe",
    ]
    for candidate in candidates:
        if candidate.exists():
            return str(candidate.resolve())
    return "typdiff"

def get_last_commit(filename):
    try:
        res = subprocess.run(
            ["git", "log", "-n", "1", "--skip=1", "--pretty=format:%H", "--", filename],
            capture_output=True, check=True
        )
        commit = res.stdout.decode("utf-8", errors="ignore").strip()
        if commit:
            return commit
    except Exception:
        pass
    return "HEAD~1"

def main():
    # Skript-Ordner ermitteln und als Arbeitsverzeichnis setzen
    script_dir = Path(__file__).parent.resolve()
    os.chdir(script_dir)

    parser = argparse.ArgumentParser(description="Vergleicht Typst-Dateien mit Git-Commits.")
    parser.add_argument("file", nargs="?", default="main.typ", help="Datei (Standard: main.typ)")
    parser.add_argument("commit", nargs="?", default=None, help="Commit Hash/Ref (Standard: automatisch)")
    args = parser.parse_args()

    file_path = Path(args.file)
    if not file_path.exists():
        print(f"[!] Fehler: Datei '{file_path}' wurde nicht gefunden.")
        sys.exit(1)

    commit = args.commit or get_last_commit(file_path.name)
    typdiff_exe = find_typdiff(script_dir)
    output_pdf = file_path.stem + "-diff.pdf"

    print(f"[Info] Verwende typdiff unter: {typdiff_exe}")
    print(f"[1/3] Vergleiche aktuellen Stand von {file_path.name} mit Commit {commit}...")

    pid = os.getpid()
    tmp_old = file_path.parent / f"._tmp_old_{pid}.typ"
    tmp_diff = file_path.parent / f"._tmp_diff_{pid}.typ"

    try:
        # 1. Git Commit Stand unverändert als Byte-Stream schreiben (1:1 wie in diff.bat)
        with open(tmp_old, "wb") as f_out:
            git_res = subprocess.run(
                ["git", "show", f"{commit}:./{file_path.name}"],
                stdout=f_out, stderr=subprocess.PIPE
            )
            if git_res.returncode != 0:
                print(f"\n[!] Git konnte die Datei aus Commit {commit} nicht laden.")
                sys.exit(1)

        # 2. typdiff ausführen und Ausgabe als Byte-Stream schreiben
        print("[2/3] Berechne Unterschiede...")
        with open(tmp_diff, "wb") as f_out:
            diff_res = subprocess.run(
                [typdiff_exe, str(tmp_old.name), str(file_path.name)],
                stdout=f_out, stderr=subprocess.PIPE, cwd=file_path.parent
            )
            if diff_res.returncode != 0:
                print("\n[!] Fehler bei der Ausführung von typdiff.")
                sys.exit(1)

        # 3. typst mit Sandbox-Wurzel kompilieren
        print("[3/3] Kompiliere PDF mit Typst...")
        typst_res = subprocess.run(
            ["typst", "compile", "--root", "..", str(tmp_diff.name), str(output_pdf)],
            cwd=file_path.parent
        )
        if typst_res.returncode != 0:
            print("\n[!] Fehler beim Kompilieren mit Typst.")
            sys.exit(1)

        print(f"\nErfolgreich! PDF erzeugt: {output_pdf}")

    finally:
        # Automatisches Aufräumen der Temp-Dateien
        if tmp_old.exists():
            tmp_old.unlink()
        if tmp_diff.exists():
            tmp_diff.unlink()

if __name__ == "__main__":
    main()
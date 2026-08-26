import argparse
import io
import os
import subprocess
import sys
import tempfile
import zipfile
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


def get_statusupdate_commits():
    """Liest alle Commit-Hashes aus, deren Message mit '[REPORT-STATUSUPDATE]' beginnt."""
    try:
        res = subprocess.run(
            ["git", "log", "--grep=^[REPORT-STATUSUPDATE]", "--pretty=format:%H"],
            capture_output=True,
            text=True,
            check=True,
        )
        return [c.strip() for c in res.stdout.splitlines() if c.strip()]
    except Exception as e:
        print(f"[!] Fehler beim Abrufen der Git-Historie: {e}")
        sys.exit(1)


def extract_commit(commit_hash, target_dir):
    """Entpackt den vollständigen Projektstand eines Commits in ein temporäres Verzeichnis."""
    try:
        res = subprocess.run(
            ["git", "archive", "--format=zip", commit_hash],
            capture_output=True,
            check=True,
        )
        with zipfile.ZipFile(io.BytesIO(res.stdout)) as z:
            z.extractall(target_dir)
    except Exception as e:
        print(
            f"[!] Fehler beim Entpacken von Commit {commit_hash[:7]}: {e}"
        )
        sys.exit(1)


def main():
    script_dir = Path(__file__).parent.resolve()
    os.chdir(script_dir)

    parser = argparse.ArgumentParser(
        description="Vergleicht STATUSUPDATE-Commits in Typst-Projekten."
    )
    parser.add_argument(
        "file", nargs="?", default="main.typ", help="Hauptdatei (Standard: main.typ)"
    )
    parser.add_argument(
        "commit",
        nargs="?",
        default=None,
        help="Ziel-Commit (Hash/Ref mit 'STATUSUPDATE'). Standard: Aktuellstes STATUSUPDATE",
    )
    args = parser.parse_args()

    file_name = Path(args.file).name
    typdiff_exe = find_typdiff(script_dir)
    output_pdf = Path(args.file).stem + "-diff.pdf"

    # 1. STATUSUPDATE-Commits filtern
    status_commits = get_statusupdate_commits()
    if not status_commits:
        print("[!] Keine Commits gefunden, die mit 'STATUSUPDATE' beginnen.")
        sys.exit(1)

    # 2. Ziel-Commit & vorherigen STATUSUPDATE-Commit ermitteln
    if args.commit:
        try:
            res = subprocess.run(
                ["git", "rev-parse", args.commit],
                capture_output=True,
                text=True,
                check=True,
            )
            target_commit = res.stdout.strip()
        except Exception:
            print(f"[!] Commit '{args.commit}' wurde nicht gefunden.")
            sys.exit(1)

        if target_commit in status_commits:
            idx = status_commits.index(target_commit)
        else:
            print(
                f"[!] Angegebener Commit {target_commit[:7]} beginnt nicht mit 'STATUSUPDATE'."
            )
            sys.exit(1)
    else:
        target_commit = status_commits[0]
        idx = 0

    if idx + 1 >= len(status_commits):
        print(
            "[!] Kein vorheriger STATUSUPDATE-Commit für den Vergleich vorhanden."
        )
        sys.exit(1)

    prev_commit = status_commits[idx + 1]

    print(f"[Info] Verwende typdiff unter: {typdiff_exe}")
    print(
        f"[1/3] Vergleiche Commit {target_commit[:7]} (Neu) mit vorherigem {prev_commit[:7]} (Alt)..."
    )

    pid = os.getpid()
    tmp_diff = Path(f"._tmp_diff_{pid}.typ")

    # 3. Beide Commits vollständig entpacken, um Ordnerstrukturen & Unterdateien zu erhalten
    with (
        tempfile.TemporaryDirectory() as dir_old,
        tempfile.TemporaryDirectory() as dir_new,
    ):
        path_old = Path(dir_old)
        path_new = Path(dir_new)

        print("[2/3] Entpacke Dateistrukturen der Commits...")
        extract_commit(prev_commit, path_old)
        extract_commit(target_commit, path_new)

        file_old = path_old / file_name
        file_new = path_new / file_name

        if not file_old.exists() or not file_new.exists():
            print(
                f"[!] '{file_name}' wurde nicht in beiden Commits am Root-Verzeichnis gefunden."
            )
            sys.exit(1)

        print("[3/3] Berechne Unterschiede mit typdiff...")
        with open(tmp_diff, "wb") as f_out:
            diff_res = subprocess.run(
                [typdiff_exe, str(file_old), str(file_new)],
                stdout=f_out,
                stderr=subprocess.PIPE,
            )
            if diff_res.returncode != 0:
                print(
                    f"\n[!] Fehler bei typdiff:\n{diff_res.stderr.decode('utf-8', errors='ignore')}"
                )
                sys.exit(1)

        try:
            print("Kompiliere Diff-PDF mit Typst...")
            typst_res = subprocess.run(
                [
                    "typst",
                    "compile",
                    "--root",
                    str(path_new),
                    str(tmp_diff),
                    str(output_pdf.resolve()),
                ],
                capture_output=True,
            )
            if typst_res.returncode != 0:
                print(
                    f"\n[!] Fehler beim Kompilieren:\n{typst_res.stderr.decode('utf-8', errors='ignore')}"
                )
                sys.exit(1)

            print(f"\nErfolgreich! PDF erzeugt: {output_pdf}")

        finally:
            if tmp_diff.exists():
                tmp_diff.unlink()


if __name__ == "__main__":
    main()
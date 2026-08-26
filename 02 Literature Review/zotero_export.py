import os
import sys
import re
import shutil
import sqlite3
import subprocess
import tempfile
from pathlib import Path
import pypandoc

# Automatische Pandoc-Prüfung und Installation nach Benutzerbestätigung
try:
    pypandoc.get_pandoc_version()
except OSError:
    print("Pandoc wurde auf deinem System nicht gefunden.")
    user_input = input("Möchtest du Pandoc jetzt automatisch herunterladen und installieren? (j/n): ").strip().lower()
    
    if user_input in ["j", "ja", "y", "yes"]:
        print("Lade Pandoc automatisch herunter...")
        pypandoc.download_pandoc()
        print("Pandoc erfolgreich installiert!")
    else:
        print("Export abgebrochen, da Pandoc erforderlich ist.")
        sys.exit(0)

# --- KONFIGURATION ---
TARGET_COLLECTION = "Master Seminar"
USE_CUSTOM_THEME = True

# Demo-/Template-Notizen ohne eigenen Inhalt filtern (True = aktivieren, False = deaktivieren)
FILTER_DEMO_FILES = True

# Steuerung, was exportiert werden soll:
# Mögliche Werte: "Annotated Bibs", "Notes", "Publications", "PDFs"
EXPORT_OPTIONS = ["Annotated Bibs", "PDFs"]

ZOTERO_DIR = Path.home() / "Zotero"
EXPORT_DIR = Path(__file__).parent.resolve()

VSCODE_MARKDOWN_THEME = """
#set page(
  paper: "a4",
  margin: (x: 2cm, y: 2.5cm),
  fill: rgb("#ffffff"),
)
#set text(
  font: ("Segoe UI", "Arial"),
  size: 10.5pt,
  fill: rgb("#24292f"),
)
#set par(justify: false, leading: 0.65em)
#set list(spacing: 0.65em, tight: true)
#set enum(spacing: 0.65em, tight: true)

#show raw: set text(font: ("Consolas", "Courier New"))
#show heading.where(level: 2): it => block(
  below: 0.8em,
  inset: (bottom: 0.3em),
  stroke: (bottom: 1pt + rgb("#d8dee4")),
  width: 100%,
  text(fill: rgb("#1f2328"), weight: "bold", it.body)
)
#show raw.where(block: true): it => block(
  fill: rgb("#f6f8fa"),
  inset: 8pt,
  radius: 4pt,
  width: 100%,
  it
)
"""


def html_to_typst(html_str: str) -> str:
    """Konvertiert HTML-String mittels Pandoc direkt in sauber strukturierten Typst-Code."""
    if not html_str or not html_str.strip():
        return ""

    try:
        typst_output = pypandoc.convert_text(
            html_str, 
            to="typst", 
            format="html",
            extra_args=["--strip-comments"]
        )
    except Exception as e:
        print(f"Pandoc-Fehler: {e}")
        text = html_str
        text = re.sub(r"<h1>(.*?)</h1>", r"= \1\n", text, flags=re.IGNORECASE)
        text = re.sub(r"<h2>(.*?)</h2>", r"== \1\n", text, flags=re.IGNORECASE)
        text = re.sub(r"<h3>(.*?)</h3>", r"=== \1\n", text, flags=re.IGNORECASE)
        text = re.sub(r"<li>(.*?)</li>", r"- \1\n", text, flags=re.IGNORECASE | re.DOTALL)
        text = re.sub(r"<[^>]+>", "", text)
        typst_output = text

    # --- SÄUBERUNG DES TYPST-OUTPUTS ---
    typst_output = re.sub(r"^\s*<[a-zA-Z0-9_-]+>\s*$", "", typst_output, flags=re.MULTILINE)

    typst_output = typst_output.replace(r"\[ \]", "[ ]").replace(
        r"\[x\]", "[x]"
    ).replace(r"\[ ~\]", "[~]").replace(r"\(-)", "(-)").replace(r"\(+)", "(+)")

    lines = typst_output.splitlines()
    cleaned_lines = []
    in_list = False
    n = len(lines)

    for i in range(n):
        line = lines[i]
        nextLine = lines[i+1] if i + 1 < n else ""

        stripped = line.strip()
        is_empty = not stripped

        is_list_item = re.match(r"^\s*([-+*]|\d+\.)\s+", line) is not None

        if is_list_item:
            in_list = True
            cleaned_lines.append(line)
        elif is_empty:
            if not in_list or nextLine.startswith("="):
                cleaned_lines.append(line)
        else:
            if stripped.startswith("="):
                in_list = False
            cleaned_lines.append(line)

    typst_output = "\n".join(cleaned_lines)
    typst_output = re.sub(r"\n{3,}", "\n\n", typst_output)

    return typst_output.strip()


def prepare_path(path: Path) -> Path:
    """Umgeht das Windows MAX_PATH Limit durch das Extended-Path Präfix."""
    abs_path = path.resolve()
    if os.name == "nt":
        str_path = str(abs_path)
        if not str_path.startswith("\\\\?\\"):
            if str_path.startswith("\\\\"):
                return Path("\\\\?\\UNC\\" + str_path[2:])
            return Path("\\\\?\\" + str_path)
    return abs_path


def clean_name(name):
    if not name:
        return ""
    cleaned = re.sub(r'[\x00-\x1F\x7F/\\:*?"<>|$%]', "_", name).strip()
    return re.sub(r"\s+", " ", cleaned)


def clean_export_directory(export_dir, current_script):
    protected = {
        current_script.name.lower(),
        ".git",
        ".gitignore",
        ".venv",
        "__pycache__",
        ".vscode",
    }
    for item in export_dir.iterdir():
        if item.name.lower() in protected:
            continue
        try:
            long_item = prepare_path(item)
            if item.is_dir():
                shutil.rmtree(long_item)
            else:
                long_item.unlink()
        except Exception as e:
            print(f"Warnung: '{item.name}' konnte nicht gelöscht werden ({e})")


def compile_typst_file(typ_path: Path, pdf_path: Path):
    try:
        wrapper_path = None
        if USE_CUSTOM_THEME:
            wrapper_path = typ_path.parent / f"_temp_{typ_path.stem}.typ"
            rel_include_path = typ_path.name
            wrapper_content = f'{VSCODE_MARKDOWN_THEME}\n#include "{rel_include_path}"'
            prepare_path(wrapper_path).write_text(wrapper_content, encoding="utf-8")
            target_to_compile = wrapper_path
        else:
            target_to_compile = typ_path

        res = subprocess.run(
            ["typst", "compile", str(target_to_compile), str(pdf_path)],
            capture_output=True,
            text=True,
            check=False,
        )

        if wrapper_path and prepare_path(wrapper_path).exists():
            prepare_path(wrapper_path).unlink()

        if res.returncode != 0:
            print(f"Typst-Kompilierfehler bei '{typ_path.name}': {res.stderr.strip()}")
    except FileNotFoundError:
        pass
    except Exception as e:
        print(f"Fehler beim Kompilieren von '{typ_path.name}': {e}")


def get_item_full_metadata(cursor, item_id):
    cursor.execute(
        """
        SELECT t.typeName
        FROM items i
        JOIN itemTypes t ON i.itemTypeID = t.itemTypeID
        WHERE i.itemID = ?
    """,
        (item_id,),
    )
    row_type = cursor.fetchone()
    item_type = row_type[0] if row_type else ""

    cursor.execute(
        """
        SELECT v.value 
        FROM itemData d
        JOIN fields f ON d.fieldID = f.fieldID
        JOIN itemDataValues v ON d.valueID = v.valueID
        WHERE d.itemID = ? AND f.fieldName = 'title'
    """,
        (item_id,),
    )
    row = cursor.fetchone()
    title = row[0] if row else ""

    cursor.execute(
        """
        SELECT f.fieldName, v.value 
        FROM itemData d
        JOIN fields f ON d.fieldID = f.fieldID
        JOIN itemDataValues v ON d.valueID = v.valueID
        WHERE d.itemID = ? AND f.fieldName IN ('publicationTitle', 'proceedingsTitle', 'bookTitle', 'publisher', 'university', 'date', 'url')
    """,
        (item_id,),
    )
    fields = {r[0]: r[1] for r in cursor.fetchall()}

    venue = (
        fields.get("publicationTitle")
        or fields.get("proceedingsTitle")
        or fields.get("bookTitle")
        or fields.get("publisher")
        or fields.get("university")
        or ""
    )
    date_val = fields.get("date", "")
    url_val = fields.get("url", "")

    year_match = re.search(r"\b(19|20)\d{2}\b", date_val)
    year = year_match.group(0) if year_match else ""

    cursor.execute(
        """
        SELECT c.firstName, c.lastName
        FROM itemCreators ic
        JOIN creators c ON ic.creatorID = c.creatorID
        WHERE ic.itemID = ?
        ORDER BY ic.orderIndex
    """,
        (item_id,),
    )
    creators = cursor.fetchall()

    last_names = [c[1] for c in creators if c[1]]
    if len(last_names) == 1:
        author_short = last_names[0]
    elif len(last_names) == 2:
        author_short = f"{last_names[0]} & {last_names[1]}"
    elif len(last_names) > 2:
        author_short = f"{last_names[0]} et al."
    else:
        author_short = ""

    return item_type, title, creators, venue, year, url_val, clean_name(author_short)


def format_ieee_citation(creators, title, venue, year, url):
    formatted_authors = []
    for first, last in creators:
        if not last:
            continue
        if first:
            parts = re.split(r"[\s.-]+", first)
            initials = ". ".join([p[0].upper() for p in parts if p]) + "."
            formatted_authors.append(f"{initials} {last}")
        else:
            formatted_authors.append(last)

    if len(formatted_authors) == 1:
        authors_str = formatted_authors[0]
    elif len(formatted_authors) == 2:
        authors_str = f"{formatted_authors[0]} and {formatted_authors[1]}"
    elif len(formatted_authors) > 2:
        authors_str = f"{formatted_authors[0]} _et al._"
    else:
        authors_str = ""

    parts = []
    if authors_str:
        parts.append(authors_str)
    if title:
        clean_t = title.strip().rstrip(".")
        parts.append(f'"{clean_t},"')
    if venue:
        parts.append(f"_{venue.strip()}_,")
    if year:
        parts.append(f"{year}.")
    if url:
        parts.append(f'[Online]. Available: #link("{url.strip()}")')

    return " ".join(parts)


def generate_note_tag(typ_text, note_index, total_notes_in_category, is_annotated_bib):
    h2_match = re.search(r"^(?:==|=)\s+(.+)$", typ_text, re.MULTILINE)
    raw_heading = h2_match.group(1).strip() if h2_match else ""
    clean_h = clean_name(raw_heading)

    tag_parts = []
    if is_annotated_bib:
        if len(clean_h) > 35:
            clean_h = clean_h[:35].rstrip()
        tag_parts.append(clean_h if clean_h else "Annotated Bib")
    else:
        tag_parts.append("NOTE")
        if clean_h:
            if len(clean_h) > 30:
                clean_h = clean_h[:30].rstrip()
            tag_parts.append(clean_h)

    if total_notes_in_category > 1:
        tag_parts.append(str(note_index))

    return f"[{' '.join(tag_parts)}]"


def build_filename(author, year, title, tag=None):
    if title and len(title) > 50:
        title = title[:50].rstrip()

    meta_parts = []
    if author:
        meta_parts.append(author)
    if year:
        meta_parts.append(year)

    prefix = " - ".join(meta_parts)

    parts = []
    if prefix:
        parts.append(prefix)
    if tag:
        parts.append(tag)
    if title:
        parts.append(title)

    if not parts:
        return ""

    full_stem = " - ".join(parts)
    return clean_name(full_stem)


def is_empty_demo_note(typ_text: str) -> bool:
    """Prüft, ob eine Notiz nur aus Standard-Überschriften und Typst-Layout besteht."""
    # 1. Überschriften entfernen (z. B. == Annotated Bibliography)
    text = re.sub(r"^(?:==|=)\s+.*$", "", typ_text, flags=re.MULTILINE)
    
    # 2. Typst-Syntax & Standard-Labels entfernen
    text = re.sub(r"#block|\btext\b|\bsize\b|\bfill\b|\binset\b|\bradius\b|\bwidth\b|\bSource\b", "", text)
    
    # 3. Prüfen, ob noch alphanumerische Zeichen (A-Z, 0-9) übrig sind
    has_content = bool(re.search(r"[a-zA-Z0-9]", text))
    
    return not has_content


def export_zotero():
    db_path = ZOTERO_DIR / "zotero.sqlite"
    if not db_path.exists():
        print(f"Fehler: zotero.sqlite unter {db_path} nicht gefunden!")
        return

    clean_export_directory(EXPORT_DIR, Path(__file__))

    has_typst = shutil.which("typst") is not None

    with tempfile.TemporaryDirectory() as tmpdir:
        tmp_db = Path(tmpdir) / "zotero.sqlite"
        shutil.copy2(db_path, tmp_db)

        conn = sqlite3.connect(tmp_db)
        try:
            cursor = conn.cursor()

            cursor.execute(
                "SELECT collectionID, collectionName, parentCollectionID FROM collections"
            )
            all_colls = {
                row[0]: {"name": clean_name(row[1]), "parent": row[2]}
                for row in cursor.fetchall()
            }

            target_coll_id = None
            for cid, info in all_colls.items():
                if info["name"].lower() == TARGET_COLLECTION.lower():
                    target_coll_id = cid
                    break

            if target_coll_id is None:
                print(
                    f"Fehler: Die Sammlung '{TARGET_COLLECTION}' wurde in Zotero nicht gefunden!"
                )
                return

            def is_descendant_of_target(cid):
                curr = cid
                while curr in all_colls:
                    if curr == target_coll_id:
                        return True
                    curr = all_colls[curr]["parent"]
                return False

            def get_relative_path(cid):
                parts = []
                curr = cid
                while curr in all_colls and curr != target_coll_id:
                    parts.insert(0, all_colls[curr]["name"])
                    curr = all_colls[curr]["parent"]
                return Path(*parts) if parts else Path(".")

            cursor.execute("SELECT collectionID, itemID FROM collectionItems")
            items = cursor.fetchall()

            for coll_id, item_id in items:
                if not is_descendant_of_target(coll_id):
                    continue

                target_folder = EXPORT_DIR / get_relative_path(coll_id)
                prepare_path(target_folder).mkdir(parents=True, exist_ok=True)

                item_type, title, creators, venue, year, url, author_short = (
                    get_item_full_metadata(cursor, item_id)
                )

                publication_types = (
                    "journalArticle",
                    "conferencePaper",
                    "preprint",
                    "report",
                    "thesis",
                    "book",
                    "bookSection",
                )
                is_publication = item_type in publication_types

                should_export_pdf = (is_publication and "Publications" in EXPORT_OPTIONS) or (
                    not is_publication and "PDFs" in EXPORT_OPTIONS
                )

                # 1. PDFs kopieren
                if should_export_pdf:
                    cursor.execute(
                        """
                        SELECT itemAttachments.path, items.key
                        FROM itemAttachments
                        JOIN items ON items.itemID = itemAttachments.itemID
                        WHERE (itemAttachments.parentItemID = ? OR itemAttachments.itemID = ?) 
                          AND itemAttachments.contentType = 'application/pdf'
                    """,
                        (item_id, item_id),
                    )
                    attachments = cursor.fetchall()

                    for att_path, key in attachments:
                        raw_filename = (
                            att_path.replace("storage:", "") if att_path else ""
                        )
                        storage_folder = ZOTERO_DIR / "storage" / key

                        src_pdf = (
                            storage_folder / raw_filename
                            if raw_filename
                            else None
                        )
                        if not (src_pdf and src_pdf.exists()):
                            if storage_folder.exists():
                                pdfs_in_dir = list(storage_folder.glob("*.pdf"))
                                if pdfs_in_dir:
                                    src_pdf = pdfs_in_dir[0]

                        if src_pdf and src_pdf.exists():
                            pdf_stem = build_filename(author_short, year, title)
                            if not pdf_stem:
                                pdf_stem = clean_name(src_pdf.stem[:50])

                            dst_pdf = target_folder / f"{pdf_stem}.pdf"

                            counter = 1
                            while prepare_path(dst_pdf).exists():
                                dst_pdf = (
                                    target_folder / f"{pdf_stem}_{counter}.pdf"
                                )
                                counter += 1

                            try:
                                shutil.copy2(
                                    prepare_path(src_pdf), prepare_path(dst_pdf)
                                )
                            except Exception as e:
                                print(
                                    f"Fehler beim Kopieren von PDF '{src_pdf.name}': {e}"
                                )

                # 2. Notizen auslesen, kategorisieren und filtern
                cursor.execute(
                    """
                    SELECT note FROM itemNotes 
                    WHERE parentItemID = ? OR itemID = ?
                """,
                    (item_id, item_id),
                )
                raw_notes = cursor.fetchall()

                annotated_bibs = []
                other_notes = []

                for n in raw_notes:
                    if not (n[0] and n[0].strip()):
                        continue
                    typ_text = html_to_typst(n[0])

                    # Demo-Dateien filtern, sofern die Option eingeschaltet ist
                    if FILTER_DEMO_FILES and is_empty_demo_note(typ_text):
                        continue

                    h_match = re.search(r"^(?:==|=)\s+(.+)$", typ_text, re.MULTILINE)
                    h_text = h_match.group(1) if h_match else ""

                    if "annotated bib" in h_text.lower():
                        annotated_bibs.append(typ_text)
                    else:
                        other_notes.append(typ_text)

                notes_to_process = []

                if "Annotated Bibs" in EXPORT_OPTIONS:
                    total_bibs = len(annotated_bibs)
                    for idx, typ_text in enumerate(annotated_bibs, 1):
                        tag = generate_note_tag(
                            typ_text, idx, total_bibs, is_annotated_bib=True
                        )
                        notes_to_process.append((typ_text, tag))

                if "Notes" in EXPORT_OPTIONS:
                    total_others = len(other_notes)
                    for idx, typ_text in enumerate(other_notes, 1):
                        tag = generate_note_tag(
                            typ_text, idx, total_others, is_annotated_bib=False
                        )
                        notes_to_process.append((typ_text, tag))

                # 3. Notizen schreiben und kompilieren
                for typ_text, tag in notes_to_process:
                    note_stem = build_filename(
                        author_short, year, title, tag=tag
                    )
                    if not note_stem:
                        note_stem = clean_name(tag)

                    ieee_citation = format_ieee_citation(
                        creators, title, venue, year, url
                    )
                    ieee_block = f'#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[\n  #text(size: 0.9em)[*Source:* {ieee_citation}]\n]'

                    header_line = f"== {title if title else 'Annotated Bibliography'}\n\n{ieee_block}"

                    if re.search(r"^(?:==|=)\s+", typ_text, re.MULTILINE):
                        typ_text = re.sub(
                            r"^(?:==|=)\s+.*$",
                            header_line,
                            typ_text,
                            count=1,
                            flags=re.MULTILINE,
                        )
                    else:
                        typ_text = f"{header_line}\n\n{typ_text}"

                    note_typ_file = target_folder / f"{note_stem}.typ"

                    counter = 1
                    while prepare_path(note_typ_file).exists():
                        note_typ_file = (
                            target_folder / f"{note_stem}_{counter}.typ"
                        )
                        counter += 1

                    try:
                        prepare_path(note_typ_file).write_text(
                            typ_text, encoding="utf-8"
                        )

                        if has_typst:
                            note_pdf_file = note_typ_file.with_suffix(".pdf")
                            compile_typst_file(
                                prepare_path(note_typ_file),
                                prepare_path(note_pdf_file),
                            )
                    except Exception as e:
                        print(
                            f"Fehler beim Schreiben/Kompilieren der Notiz {note_typ_file}: {e}"
                        )

        finally:
            conn.close()

    print(f"Export von '{TARGET_COLLECTION}' erfolgreich abgeschlossen!")


if __name__ == "__main__":
    export_zotero()
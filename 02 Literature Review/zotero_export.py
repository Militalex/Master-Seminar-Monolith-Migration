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

# Demo-/Template-Notizen ohne eigenen Inhalt filtern
FILTER_DEMO_FILES = True

# Steuerung, was exportiert werden soll:
# Mögliche Werte: "Annotated Bibs", "Notes", "Publications", "PDFs", "Publication Infos"
EXPORT_OPTIONS = ["Annotated Bibs", "PDFs", "Publication Infos"]

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

# --- HELPER FUNKTIONEN ---

def escape_typst_text(text: str) -> str:
    """Escaped Sonderzeichen für Typst (z.B. #, /, _, *, [, ], @)."""
    if not text:
        return ""
    return re.sub(r'([#/*_\[\]@])', r'\\\1', text)


def clean_name(name: str) -> str:
    """Bereinigt Dateinamen von unzulässigen Zeichen."""
    if not name:
        return ""
    cleaned = re.sub(r'[\x00-\x1F\x7F/\\:*?"<>|$%]', "_", name).strip()
    return re.sub(r"\s+", " ", cleaned)


def prepare_path(path: Path) -> Path:
    """Erstellt kompatible Windows Long Paths (hilft gegen 260-Zeichen-Limits)."""
    abs_path = path.resolve()
    if os.name == "nt":
        str_path = str(abs_path)
        if not str_path.startswith("\\\\?\\"):
            if str_path.startswith("\\\\"):
                return Path("\\\\?\\UNC\\" + str_path[2:])
            return Path("\\\\?\\" + str_path)
    return abs_path


def build_filename(author, year, title, tag=None):
    """Baut den standardisierten Dateinamen aus Autor, Jahr, Tag und Titel auf."""
    if title and len(title) > 50:
        title = title[:50].rstrip()

    prefix = " - ".join(filter(None, [author, year]))
    full_stem = " - ".join(filter(None, [prefix, tag, title]))
    return clean_name(full_stem)


def is_empty_demo_note(typ_text: str) -> bool:
    """Filtert Vorlagen heraus, die außer Layout/Quellenangabe keinen Text enthalten."""
    text = re.sub(r"^(?:==|=)\s+.*$", "", typ_text, flags=re.MULTILINE)
    text = re.sub(
        r"#block|\btext\b|\bsize\b|\bfill\b|\binset\b|\bradius\b|\bwidth\b|\bSource\b|\bPaper Information\b|\bRating\b|\bOwn Keywords\b|\bReading Progress\b",
        "",
        text,
        flags=re.IGNORECASE,
    )
    return not bool(re.search(r"[a-zA-Z0-9]", text))


def html_to_typst(html_str: str) -> str:
    """Konvertiert HTML-String mittels Pandoc direkt in sauber strukturierten Typst-Code."""
    if not html_str or not html_str.strip():
        return ""

    try:
        typst_output = pypandoc.convert_text(
            html_str, to="typst", format="html", extra_args=["--strip-comments"]
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

    # Typst-spezifische Ausgaben bereinigen
    typst_output = re.sub(r"^\s*<[a-zA-Z0-9_-]+>\s*$", "", typst_output, flags=re.MULTILINE)
    typst_output = typst_output.replace(r"\[ \]", "[ ]").replace(r"\[x\]", "[x]")

    # Leerzeilen in Listen optimieren
    lines = typst_output.splitlines()
    cleaned_lines = []
    in_list = False
    n = len(lines)

    for i in range(n):
        line = lines[i]
        nextLine = lines[i + 1] if i + 1 < n else ""
        is_list_item = re.match(r"^\s*([-+*]|\d+\.)\s+", line) is not None

        if is_list_item:
            in_list = True
            cleaned_lines.append(line)
        elif not line.strip():
            if not in_list or nextLine.startswith("="):
                cleaned_lines.append(line)
        else:
            if line.strip().startswith("="):
                in_list = False
            cleaned_lines.append(line)

    return re.sub(r"\n{3,}", "\n\n", "\n".join(cleaned_lines)).strip()


# --- PARSING & METADATA ---

def parse_ethereal_tags(tags, extra_text=""):
    """Liest Ratings, Lesenfortschritte und Tags aus Zotero aus."""
    ratings, reading_progress, paper_progress, tiered_tags = [], [], [], []

    # A) Extra-Feld auf Ethereal Ratings prüfen
    if extra_text:
        # Findet 'rate: X' oder 'rating: X' an beliebiger Stelle im gesamten Text
        for m in re.finditer(r"\b(?:rate|rating):\s*(\d+)\b", extra_text, re.IGNORECASE):
            num = int(m.group(1))
            num_clamped = max(1, min(5, num))
            ratings.append(escape_typst_text(f"{'⭐' * num_clamped} ({num_clamped}/5)"))

        # Prüft auf vorgefertigte Sternen-Symbole zeilenweise
        for line in extra_text.splitlines():
            line_str = line.strip()
            if any(char in line_str for char in ["⭐", "★"]):
                ratings.append(escape_typst_text(line_str))

    # B) Tags verarbeiten
    for tag in tags:
        tag_str = tag.strip()
        if not tag_str:
            continue

        if any(char in tag_str for char in ["⭐", "★"]):
            ratings.append(escape_typst_text(tag_str))
        elif (tag_m := re.search(r"(?:rate|rating)[:/]\s*(\d+)", tag_str, re.IGNORECASE)):
            num = int(tag_m.group(1))
            num_clamped = max(1, min(5, num))
            ratings.append(escape_typst_text(f"{'⭐' * num_clamped} ({num_clamped}/5)"))
        elif (tag_m := re.match(r"^(?:#)?(\d+)\s*(?:stars?|sterne)$", tag_str, re.IGNORECASE)):
            num = int(tag_m.group(1))
            num_clamped = max(1, min(5, num))
            ratings.append(escape_typst_text(f"{'⭐' * num_clamped} ({num_clamped}/5)"))
        elif (read_match := re.match(r"^#?read/(.+)$", tag_str, re.IGNORECASE)):
            progress_parts = [escape_typst_text(p.strip()) for p in read_match.group(1).split("/") if p.strip()]
            reading_progress.append(" > ".join(progress_parts))
        elif (paper_match := re.match(r"^#?paper/(.+)$", tag_str, re.IGNORECASE)):
            paper_parts = [escape_typst_text(p.strip()) for p in paper_match.group(1).split("/") if p.strip()]
            paper_progress.append(" > ".join(paper_parts))
        else:
            clean_tag = re.sub(r"^#+", "", tag_str).strip()
            parts = [p.strip() for p in clean_tag.split("/") if p.strip()]
            for depth, p in enumerate(parts):
                esc_part = escape_typst_text(p)
                if not any(text == esc_part for _, text in tiered_tags):
                    tiered_tags.append((depth, esc_part))

    tiered_tags.sort(key=lambda item: item[0])
    category_tags = [text for _, text in tiered_tags]

    # Duplikate entfernen bei gleichbleibender Reihenfolge
    return (
        list(dict.fromkeys(ratings)),
        list(dict.fromkeys(reading_progress)),
        list(dict.fromkeys(paper_progress)),
        category_tags,
    )


def build_metadata_blocks(ieee_citation, ratings, reading_progress, paper_progress, category_tags):
    """Baut die strukturieren Typst-Metadatenblöcke auf."""
    blocks = []
    
    def add_block(label, content):
        if content:
            blocks.append(
                f'#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[\n'
                f'  #text(size: 0.9em)[*{label}:* {content}]\n]'
            )

    add_block("Source", ieee_citation)
    add_block("Paper Information", ", ".join(paper_progress))
    add_block("Rating", ", ".join(ratings))
    add_block("Own Keywords", ", ".join(category_tags))
    add_block("Reading Progress", ", ".join(reading_progress))

    return "\n\n".join(blocks)


def format_ieee_citation(creators, title, venue, year, url):
    """Erstellt eine formatierte Quellenangabe im IEEE-Stil."""
    formatted_authors = []
    for first, last in creators:
        if not last:
            continue
        if first:
            initials = ". ".join([p[0].upper() for p in re.split(r"[\s.-]+", first) if p]) + "."
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
        parts.append(f'"{title.strip().rstrip(".")},"')
    if venue:
        parts.append(f"_{venue.strip()}_,")
    if year:
        parts.append(f"{year}.")
    if url:
        parts.append(f'[Online]. Available: #link("{url.strip()}")')

    return " ".join(parts)


def generate_note_tag(typ_text, note_index, total_notes_in_category, is_annotated_bib):
    """Generiert den Datei-Tag (z.B. [NOTE Headline] oder [ANNOTATED BIB])."""
    h2_match = re.search(r"^(?:==|=)\s+(.+)$", typ_text, re.MULTILINE)
    raw_heading = h2_match.group(1).strip() if h2_match else ""
    clean_h = clean_name(raw_heading)

    tag_parts = []
    if is_annotated_bib:
        if not clean_h or clean_h.lower() == "annotated bib":
            clean_h = "ANNOTATED BIB"
        elif len(clean_h) > 35:
            clean_h = clean_h[:35].rstrip()
        tag_parts.append(clean_h)
    else:
        tag_parts.append("NOTE")
        if clean_h:
            if len(clean_h) > 30:
                clean_h = clean_h[:30].rstrip()
            tag_parts.append(clean_h)

    if total_notes_in_category > 1:
        tag_parts.append(str(note_index))

    return f"[{' '.join(tag_parts)}]"


# --- ZOTERO METADATEN FETCHING ---

def get_item_full_metadata(cursor, item_id):
    """Holt alle relevanten Metadaten eines Eintrags aus der Zotero-Datenbank."""
    cursor.execute(
        "SELECT t.typeName FROM items i JOIN itemTypes t ON i.itemTypeID = t.itemTypeID WHERE i.itemID = ?",
        (item_id,),
    )
    row_type = cursor.fetchone()
    item_type = row_type[0] if row_type else ""

    cursor.execute(
        """
        SELECT f.fieldName, v.value 
        FROM itemData d
        JOIN fields f ON d.fieldID = f.fieldID
        JOIN itemDataValues v ON d.valueID = v.valueID
        WHERE d.itemID = ?
    """,
        (item_id,),
    )
    fields = dict(cursor.fetchall())

    title = fields.get("title", "")
    venue = (
        fields.get("publicationTitle")
        or fields.get("proceedingsTitle")
        or fields.get("bookTitle")
        or fields.get("publisher")
        or fields.get("university")
        or ""
    )
    date_val = fields.get("date", "")
    year_match = re.search(r"\b(19|20)\d{2}\b", date_val)
    year = year_match.group(0) if year_match else ""

    # Zotero Ersteller zusammen mit ihrem Rolle-Typ abfragen
    cursor.execute(
        """
        SELECT c.firstName, c.lastName, ct.creatorType
        FROM itemCreators ic
        JOIN creators c ON ic.creatorID = c.creatorID
        JOIN creatorTypes ct ON ic.creatorTypeID = ct.creatorTypeID
        WHERE ic.itemID = ?
        ORDER BY ic.orderIndex
    """,
        (item_id,),
    )
    all_creators = cursor.fetchall()

    # Nur primäre Autoren/Ersteller (z. B. 'author', 'inventor') herausfiltern
    primary_types = {"author", "inventor", "programmer", "presenter", "artist", "director", "podcaster"}
    primary_creators = [c for c in all_creators if c[2] in primary_types]

    # Falls Autoren vorhanden sind, diese nutzen. Andernfalls Fallback auf alle Ersteller (z. B. Herausgeberbände)
    selected_creators = primary_creators if primary_creators else all_creators
    creators = [(c[0], c[1]) for c in selected_creators]

    last_names = [c[1] for c in creators if c[1]]
    if len(last_names) == 1:
        author_short = last_names[0]
    elif len(last_names) == 2:
        author_short = f"{last_names[0]} & {last_names[1]}"
    elif len(last_names) > 2:
        author_short = f"{last_names[0]} et al."
    else:
        author_short = ""

    cursor.execute(
        """
        SELECT t.name
        FROM itemTags it
        JOIN tags t ON it.tagID = t.tagID
        WHERE it.itemID = ?
        ORDER BY t.name
    """,
        (item_id,),
    )
    tags = [r[0] for r in cursor.fetchall()]

    return (
        item_type,
        title,
        creators,
        venue,
        year,
        fields.get("url", ""),
        clean_name(author_short),
        tags,
        fields.get("extra", ""),
    )


# --- TYPST COMPILATION & EXPORT ---

def compile_typst_file(typ_path: Path, pdf_path: Path):
    """Kompiliert eine Typst-Datei mit optionalem Custom-Theme als PDF."""
    try:
        wrapper_path = None
        if USE_CUSTOM_THEME:
            wrapper_path = typ_path.parent / f"_temp_{typ_path.stem}.typ"
            wrapper_content = f'{VSCODE_MARKDOWN_THEME}\n#include "{typ_path.name}"'
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


def clean_export_directory(export_dir, current_script):
    """Löscht alte Exportdateien, ohne Entwicklungsordner/Skripte zu antasten."""
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


def export_zotero():
    """Hauptfunktion für den Exporter."""
    db_path = ZOTERO_DIR / "zotero.sqlite"
    if not db_path.exists():
        print(f"Fehler: zotero.sqlite unter {db_path} nicht gefunden!")
        return

    clean_export_directory(EXPORT_DIR, Path(__file__))
    has_typst = shutil.which("typst") is not None

    # Zotero SQLite temporär kopieren, um Schreib-Sperren der Zotero-App zu umgehen
    with tempfile.TemporaryDirectory() as tmpdir:
        tmp_db = Path(tmpdir) / "zotero.sqlite"
        shutil.copy2(db_path, tmp_db)

        conn = sqlite3.connect(tmp_db)
        try:
            cursor = conn.cursor()

            # Collections aufbauen
            cursor.execute("SELECT collectionID, collectionName, parentCollectionID FROM collections")
            all_colls = {row[0]: {"name": clean_name(row[1]), "parent": row[2]} for row in cursor.fetchall()}

            target_coll_id = next(
                (cid for cid, info in all_colls.items() if info["name"].lower() == TARGET_COLLECTION.lower()),
                None,
            )

            if target_coll_id is None:
                print(f"Fehler: Die Sammlung '{TARGET_COLLECTION}' wurde in Zotero nicht gefunden!")
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

                item_type, title, creators, venue, year, url, author_short, tags, extra_val = (
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

                # --- 1. DATEIEN IN-MEMORY SAMMELN, UM LOGIK ZU PRÜFEN ---
                staged_pdfs = []
                staged_info_content = None
                staged_notes = []

                # Source PDFs suchen
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
                        raw_filename = att_path.replace("storage:", "") if att_path else ""
                        storage_folder = ZOTERO_DIR / "storage" / key

                        src_pdf = storage_folder / raw_filename if raw_filename else None
                        if not (src_pdf and src_pdf.exists()) and storage_folder.exists():
                            pdfs_in_dir = list(storage_folder.glob("*.pdf"))
                            if pdfs_in_dir:
                                src_pdf = pdfs_in_dir[0]

                        if src_pdf and src_pdf.exists():
                            staged_pdfs.append(src_pdf)

                # Notizen auslesen & kategorisieren
                cursor.execute(
                    "SELECT note FROM itemNotes WHERE parentItemID = ? OR itemID = ?",
                    (item_id, item_id),
                )
                raw_notes = cursor.fetchall()

                annotated_bibs, other_notes = [], []

                for n in raw_notes:
                    if not (n[0] and n[0].strip()):
                        continue
                    typ_text = html_to_typst(n[0])

                    if FILTER_DEMO_FILES and is_empty_demo_note(typ_text):
                        continue

                    h_match = re.search(r"^(?:==|=)\s+(.+)$", typ_text, re.MULTILINE)
                    h_text = h_match.group(1) if h_match else ""

                    if "annotated bib" in h_text.lower():
                        annotated_bibs.append(typ_text)
                    else:
                        other_notes.append(typ_text)

                # Metadaten aufbereiten
                ieee_citation = format_ieee_citation(creators, title, venue, year, url)
                ratings, reading_progress, paper_progress, category_tags = parse_ethereal_tags(tags, extra_val)
                metadata_blocks_str = build_metadata_blocks(
                    ieee_citation, ratings, reading_progress, paper_progress, category_tags
                )
                has_valid_metadata = bool(title.strip() or ieee_citation.strip())

                # Publication Info-Dateien ([INFO])
                has_annotated_bibs = len(annotated_bibs) > 0 and "Annotated Bibs" in EXPORT_OPTIONS

                if "Publication Infos" in EXPORT_OPTIONS and has_valid_metadata and not has_annotated_bibs:
                    info_content = f"== {title if title else 'Publication Metadata'}\n\n{metadata_blocks_str}"
                    if not (FILTER_DEMO_FILES and is_empty_demo_note(info_content)):
                        staged_info_content = info_content

                # Notizen sammeln
                if "Annotated Bibs" in EXPORT_OPTIONS:
                    total_bibs = len(annotated_bibs)
                    for idx, typ_text in enumerate(annotated_bibs, 1):
                        tag = generate_note_tag(typ_text, idx, total_bibs, is_annotated_bib=True)
                        staged_notes.append((typ_text, tag, True, idx, total_bibs))

                if "Notes" in EXPORT_OPTIONS:
                    total_others = len(other_notes)
                    for idx, typ_text in enumerate(other_notes, 1):
                        tag = generate_note_tag(typ_text, idx, total_others, is_annotated_bib=False)
                        staged_notes.append((typ_text, tag, False, idx, total_others))

                # --- 2. UNTERORDNER-LOGIK ---
                has_generated_files = len(staged_notes) > 0 or (staged_info_content is not None)
                use_subfolder = has_generated_files or (len(staged_pdfs) > 1)

                base_paper_stem = build_filename(author_short, year, title) or clean_name(title[:50]) or "Paper"

                if use_subfolder:
                    item_folder = target_folder / base_paper_stem
                    prepare_path(item_folder).mkdir(parents=True, exist_ok=True)
                else:
                    item_folder = target_folder

                # --- 3. SPEICHERN & EXPORTIEREN ---

                # A) PDFs kopieren
                for pdf_idx, src_pdf in enumerate(staged_pdfs, 1):
                    source_tag = "[SOURCE]" if len(staged_pdfs) == 1 else f"[SOURCE_{pdf_idx}]"
                    
                    if use_subfolder:
                        pdf_stem = source_tag
                    else:
                        pdf_stem = build_filename(author_short, year, title, tag=source_tag) or clean_name(f"{source_tag} - {src_pdf.stem[:50]}")

                    dst_pdf = item_folder / f"{pdf_stem}.pdf"
                    counter = 1
                    while prepare_path(dst_pdf).exists():
                        dst_pdf = item_folder / f"{pdf_stem}_{counter}.pdf"
                        counter += 1

                    try:
                        shutil.copy2(prepare_path(src_pdf), prepare_path(dst_pdf))
                    except Exception as e:
                        print(f"Fehler beim Kopieren von PDF '{src_pdf.name}': {e}")

                # B) Info-Datei schreiben & kompilieren
                if staged_info_content:
                    if use_subfolder:
                        info_stem = "[INFO]"
                    else:
                        info_stem = build_filename(author_short, year, title, tag="[INFO]") or clean_name(f"[INFO] - {title[:50]}")

                    info_typ_file = item_folder / f"{info_stem}.typ"
                    info_pdf_file = item_folder / f"{info_stem}.pdf"

                    try:
                        prepare_path(info_typ_file).write_text(staged_info_content, encoding="utf-8")
                        if has_typst:
                            compile_typst_file(prepare_path(info_typ_file), prepare_path(info_pdf_file))
                    except Exception as e:
                        print(f"Fehler beim Generieren der Info-Datei für '{title}': {e}")

                # C) Notizen schreiben & kompilieren
                for typ_text, tag, is_bib, note_idx, total_notes_in_cat in staged_notes:
                    if use_subfolder:
                        if is_bib:
                            note_stem = "[ANNOTATED BIB]" if total_notes_in_cat == 1 else f"[ANNOTATED BIB {note_idx}]"
                        else:
                            note_stem = tag
                    else:
                        note_stem = build_filename(author_short, year, title, tag=tag) or clean_name(tag)

                    if is_bib:
                        header_line = f"== {title if title else 'Annotated Bibliography'}\n\n{metadata_blocks_str}"
                    else:
                        ieee_block = (
                            f'#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[\n  #text(size: 0.9em)[*Source:* {ieee_citation}]\n]'
                            if ieee_citation
                            else ""
                        )
                        header_line = f"== {title if title else 'Note'}\n\n{ieee_block}"

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

                    note_typ_file = item_folder / f"{note_stem}.typ"
                    counter = 1
                    while prepare_path(note_typ_file).exists():
                        note_typ_file = item_folder / f"{note_stem}_{counter}.typ"
                        counter += 1

                    try:
                        prepare_path(note_typ_file).write_text(typ_text, encoding="utf-8")

                        if has_typst:
                            note_pdf_file = note_typ_file.with_suffix(".pdf")
                            compile_typst_file(
                                prepare_path(note_typ_file),
                                prepare_path(note_pdf_file),
                            )
                    except Exception as e:
                        print(f"Fehler beim Schreiben/Kompilieren der Notiz {note_typ_file}: {e}")

        finally:
            conn.close()

    print(f"Export von '{TARGET_COLLECTION}' erfolgreich abgeschlossen!")


if __name__ == "__main__":
    export_zotero()
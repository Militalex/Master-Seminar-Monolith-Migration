"""Zotero-Exporter: Exportiert eine Zotero-Sammlung nach Typst/PDF."""

import os
import re
import shutil
import sqlite3
import subprocess
import sys
import tempfile
from collections import Counter
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

import pypandoc


# ---------------------------------------------------------------------------
# KONFIGURATION
# ---------------------------------------------------------------------------

TARGET_COLLECTION = "Master Seminar"
USE_CUSTOM_THEME = True

# Demo-/Template-Notizen ohne eigenen Inhalt filtern
FILTER_DEMO_FILES = True

# Mögliche Werte: "Annotated Bibs", "Notes", "Publications", "PDFs", "Publication Infos"
EXPORT_OPTIONS = ["Annotated Bibs", "PDFs", "Publication Infos"]
# Number of Typst compilations run concurrently
TYPST_COMPILE_WORKERS = 4

ZOTERO_DIR = Path.home() / "Zotero"
EXPORT_DIR = Path(__file__).parent.resolve()

PUBLICATION_TYPES = frozenset({
    "journalArticle", "conferencePaper", "preprint", "report",
    "thesis", "book", "bookSection",
})

PRIMARY_CREATOR_TYPES = frozenset({
    "author", "inventor", "programmer", "presenter",
    "artist", "director", "podcaster",
})

# Längenobergrenzen für Dateinamen-Bestandteile
MAX_AUTHOR_LEN = 25
MAX_TITLE_LEN = 35
MAX_FILENAME_LEN = 65
MAX_BIB_HEADING_LEN = 25
MAX_NOTE_HEADING_LEN = 20


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


# ---------------------------------------------------------------------------
# ALLGEMEINE HILFSFUNKTIONEN
# ---------------------------------------------------------------------------

def escape_typst_text(text: str) -> str:
    """Escaped Sonderzeichen für Typst (z.B. #, /, _, *, [, ], @, \\)."""
    if not text:
        return ""
    return re.sub(r'([#/*_\[\]@\\])', r'\\\1', text)


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


def build_filename(author: str, year: str, title: str, tag: Optional[str] = None) -> str:
    """Baut den standardisierten Dateinamen/Ordnernamen auf und kürzt ihn."""
    if author and len(author) > MAX_AUTHOR_LEN:
        author = author[:MAX_AUTHOR_LEN].rstrip()
    if title and len(title) > MAX_TITLE_LEN:
        title = title[:MAX_TITLE_LEN].rstrip()

    prefix = " - ".join(filter(None, [author, year]))
    full_stem = " - ".join(filter(None, [prefix, tag, title]))
    cleaned = clean_name(full_stem)

    if len(cleaned) > MAX_FILENAME_LEN:
        cleaned = cleaned[:MAX_FILENAME_LEN].rstrip()
    return cleaned


def is_empty_demo_note(typ_text: str) -> bool:
    """Filtert Vorlagen heraus, die außer Layout/Quellenangabe keinen Text enthalten."""
    text = re.sub(r"^(?:==|=)\s+.*$", "", typ_text, flags=re.MULTILINE)
    text = re.sub(
        r"#block|\btext\b|\bsize\b|\bfill\b|\binset\b|\bradius\b|\bwidth\b|"
        r"\bCitation\b|\bSource\b|\bPaper Information\b|\bRating\b|"
        r"\bOwn Keywords\b|\bReading Progress\b",
        "",
        text,
        flags=re.IGNORECASE,
    )
    return not bool(re.search(r"[a-zA-Z0-9]", text))


# ---------------------------------------------------------------------------
# HTML → TYPST
# ---------------------------------------------------------------------------

def html_to_typst(html_str: str) -> str:
    """Konvertiert HTML-String mittels Pandoc direkt in sauber strukturierten Typst-Code."""
    if not html_str or not html_str.strip():
        return ""

    typst_output = _html_to_typst_pandoc(html_str)
    typst_output = _cleanup_typst_output(typst_output)
    typst_output = _collapse_blank_lines_in_lists(typst_output)
    return typst_output


def _html_to_typst_pandoc(html_str: str) -> str:
    try:
        return pypandoc.convert_text(
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
        return text


def _cleanup_typst_output(typst_output: str) -> str:
    typst_output = re.sub(r"^\s*<[a-zA-Z0-9_-]+>\s*$", "", typst_output, flags=re.MULTILINE)
    typst_output = typst_output.replace(r"\[ \]", "[ ]").replace(r"\[x\]", "[x]")
    return typst_output


def _collapse_blank_lines_in_lists(typst_output: str) -> str:
    lines = typst_output.splitlines()
    cleaned_lines = []
    in_list = False
    n = len(lines)

    for i in range(n):
        line = lines[i]
        next_line = lines[i + 1] if i + 1 < n else ""
        is_list_item = re.match(r"^\s*([-+*]|\d+\.)\s+", line) is not None

        if is_list_item:
            in_list = True
            cleaned_lines.append(line)
        elif not line.strip():
            if not in_list or next_line.startswith("="):
                cleaned_lines.append(line)
        else:
            if line.strip().startswith("="):
                in_list = False
            cleaned_lines.append(line)

    return re.sub(r"\n{3,}", "\n\n", "\n".join(cleaned_lines)).strip()


# ---------------------------------------------------------------------------
# TAGS, RATINGS, PROGRESS
# ---------------------------------------------------------------------------

@dataclass
class ParsedTags:
    ratings: list[str]
    reading_progress: list[str]
    paper_progress: list[str]
    source_info: list[str]
    slr_criteria: list[str]
    category_tags: list[str]


def parse_ethereal_tags(tags, extra_text: str = "") -> ParsedTags:
    """Liest Ratings, Fortschritte, Quellen, SLR-Kriterien und Tags aus Zotero aus."""
    ratings, reading_progress, paper_progress = [], [], []
    source_info, slr_criteria, tiered_tags = [], [], []

    if extra_text:
        for m in re.finditer(r"\b(?:rate|rating):\s*(\d+)\b", extra_text, re.IGNORECASE):
            num_clamped = max(1, min(5, int(m.group(1))))
            ratings.append(escape_typst_text(f"{'⭐' * num_clamped}"))

        for line in extra_text.splitlines():
            line_str = line.strip()
            if any(char in line_str for char in ["⭐", "★"]):
                ratings.append(escape_typst_text(line_str))

    for tag in tags:
        tag_str = tag.strip()
        if not tag_str:
            continue

        parsed = _parse_tag(
            tag_str, ratings, reading_progress, paper_progress,
            source_info, slr_criteria, tiered_tags,
        )
        if parsed:
            continue

        _add_tiered_tag(tag_str, tiered_tags)

    tiered_tags.sort(key=lambda item: item[0])
    category_tags = [text for _, text in tiered_tags]
    formatted_source_info = _format_source_info(source_info)

    return ParsedTags(
        ratings=list(dict.fromkeys(ratings)),
        reading_progress=list(dict.fromkeys(reading_progress)),
        paper_progress=list(dict.fromkeys(paper_progress)),
        source_info=formatted_source_info,
        slr_criteria=list(dict.fromkeys(slr_criteria)),
        category_tags=category_tags,
    )


def _format_source_info(source_tags: list[list[str]]) -> list[str]:
    sources = {}
    additional_paths = []
    search_types = {
        "abstract-search": "Abstract-Search",
        "full-text-search": "Full-Text-Search",
    }

    for parts in source_tags:
        if len(parts) == 1 or (
            len(parts) == 2 and parts[1].lower() in search_types
        ):
            source_name = parts[0]
            source_key = source_name.casefold()
            if source_key not in sources:
                sources[source_key] = {"name": source_name, "search_types": set()}
            if len(parts) == 2:
                sources[source_key]["search_types"].add(search_types[parts[1].lower()])
        else:
            additional_paths.append(" > ".join(escape_typst_text(p) for p in parts))

    formatted = []
    for source in sources.values():
        text = escape_typst_text(source["name"])
        for search_type in ("Abstract-Search", "Full-Text-Search"):
            if search_type in source["search_types"]:
                text += f" [{search_type}]"
        formatted.append(text)

    return list(dict.fromkeys(formatted + additional_paths))


def _parse_tag(tag_str, ratings, reading_progress, paper_progress, source_info,
               slr_criteria, tiered_tags) -> bool:
    """Verarbeitet einen Tag als Rating, Progress, Source oder SLR-Kriterium."""
    if any(char in tag_str for char in ["⭐", "★"]):
        ratings.append(escape_typst_text(tag_str))
        return True

    if (m := re.search(r"(?:rate|rating)[:/]\s*(\d+)", tag_str, re.IGNORECASE)):
        num_clamped = max(1, min(5, int(m.group(1))))
        ratings.append(escape_typst_text(f"{'⭐' * num_clamped} ({num_clamped}/5)"))
        return True

    if (m := re.match(r"^(?:#)?(\d+)\s*(?:stars?|sterne)$", tag_str, re.IGNORECASE)):
        num_clamped = max(1, min(5, int(m.group(1))))
        ratings.append(escape_typst_text(f"{'⭐' * num_clamped} ({num_clamped}/5)"))
        return True

    if (m := re.match(r"^#?read/(.+)$", tag_str, re.IGNORECASE)):
        parts = [escape_typst_text(p.strip()) for p in m.group(1).split("/") if p.strip()]
        reading_progress.append(" > ".join(parts))
        return True

    if (m := re.match(r"^#?paper/(.+)$", tag_str, re.IGNORECASE)):
        parts = [escape_typst_text(p.strip()) for p in m.group(1).split("/") if p.strip()]
        paper_progress.append(" > ".join(parts))
        return True

    if (m := re.match(r"^#?source/(.+)$", tag_str, re.IGNORECASE)):
        parts = [p.strip() for p in m.group(1).split("/") if p.strip()]
        if parts:
            source_info.append(parts)
        return True

    if (m := re.match(
        r"^#?slr/(?:exclusion|excluded|inclusion|included)/(.+)$",
        tag_str,
        re.IGNORECASE,
    )):
        criterion_parts = [
            escape_typst_text(p.strip()) for p in m.group(1).split("/") if p.strip()
        ]
        if criterion_parts:
            slr_criteria.append(" > ".join(criterion_parts))
        return True

    return False


def _add_tiered_tag(tag_str, tiered_tags) -> None:
    clean_tag = re.sub(r"^#+", "", tag_str).strip()
    parts = [p.strip() for p in clean_tag.split("/") if p.strip()]
    for depth, p in enumerate(parts):
        esc_part = escape_typst_text(p)
        if not any(text == esc_part for _, text in tiered_tags):
            tiered_tags.append((depth, esc_part))


# ---------------------------------------------------------------------------
# METADATEN-BLÖCKE & IEEE-ZITATION
# ---------------------------------------------------------------------------

def build_metadata_blocks(ieee_citation: str, tags: ParsedTags) -> str:
    """Baut die strukturierten Typst-Metadatenblöcke auf."""
    blocks = []

    def add_block(label, content):
        if content:
            blocks.append(
                f'#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[\n'
                f'  #text(size: 0.9em)[*{label}:* {content}]\n]'
            )

    add_block("Citation", ieee_citation)
    add_block("Source", ", ".join(tags.source_info))
    add_block("Inclusion/Exclusion Criteria", ", ".join(tags.slr_criteria))
    add_block("Paper Information", ", ".join(tags.paper_progress))
    add_block("Rating", ", ".join(tags.ratings))
    add_block("Own Keywords", ", ".join(tags.category_tags))
    add_block("Reading Progress", ", ".join(tags.reading_progress))

    return "\n\n".join(blocks)


def format_ieee_citation(creators, title, venue, year, url) -> str:
    """Erstellt eine formatierte Quellenangabe im IEEE-Stil."""
    formatted_authors = []
    for first, last in creators:
        if not last:
            continue
        last_esc = escape_typst_text(last)
        if first:
            initials = ". ".join(
                [p[0].upper() for p in re.split(r"[\s.-]+", first) if p]
            ) + "."
            formatted_authors.append(f"{escape_typst_text(initials)} {last_esc}")
        else:
            formatted_authors.append(last_esc)

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
        safe_title = escape_typst_text(title.strip().rstrip("."))
        parts.append(f'"{safe_title},"')
    if venue:
        safe_venue = escape_typst_text(venue.strip())
        parts.append(f"_{safe_venue}_,")
    if year:
        parts.append(f"{escape_typst_text(year)}.")
    if url:
        # Innerhalb eines Typst-Strings nur \ und " escapen
        safe_url = url.strip().replace("\\", "\\\\").replace('"', '\\"')
        parts.append(f'[Online]. Available: #link("{safe_url}")')

    return " ".join(parts)


# ---------------------------------------------------------------------------
# DATEINAMEN FÜR NOTIZEN
# ---------------------------------------------------------------------------

def generate_note_tag(typ_text, note_index, total_notes_in_category, is_annotated_bib, add_index=True):
    """Generiert den Datei-Tag (z.B. [NOTE Headline] oder [ANNOTATED BIB])."""
    h2_match = re.search(r"^(?:==|=)\s+(.+)$", typ_text, re.MULTILINE)
    raw_heading = h2_match.group(1).strip() if h2_match else ""
    clean_h = clean_name(raw_heading)

    tag_parts = []
    if is_annotated_bib:
        if not clean_h or clean_h.lower() == "annotated bib":
            clean_h = "ANNOTATED BIB"
        elif len(clean_h) > MAX_BIB_HEADING_LEN:
            clean_h = clean_h[:MAX_BIB_HEADING_LEN].rstrip()
        tag_parts.append(clean_h)
    else:
        tag_parts.append("NOTE")
        if clean_h:
            if len(clean_h) > MAX_NOTE_HEADING_LEN:
                clean_h = clean_h[:MAX_NOTE_HEADING_LEN].rstrip()
            tag_parts.append(clean_h)

    if add_index and total_notes_in_category > 1:
        tag_parts.append(str(note_index))

    return f"[{' '.join(tag_parts)}]"


def extract_annotated_bib_suffix(typ_text: str) -> str:
    """Extrahiert den Zusatz nach 'Annotated Bib' aus der Überschrift einer Notiz."""
    h_match = re.search(r"^(?:==|=)\s+(.+)$", typ_text, re.MULTILINE)
    if not h_match:
        return ""
    heading = h_match.group(1).strip()
    m = re.match(r"^annotated\s+bib\b\s*(.*)$", heading, re.IGNORECASE)
    if not m:
        return ""
    return clean_name(m.group(1).strip())


def resolve_note_stems(staged_notes) -> list:
    """Bestimmt die Basis-Dateinamen aller Notizen und nummeriert nur bei Kollisionen."""
    base_stems = []
    for note in staged_notes:
        if note.is_annotated_bib:
            suffix = extract_annotated_bib_suffix(note.typ_text)
            base_stems.append(f"[ANNOTATED BIB ({suffix})]" if suffix else "[ANNOTATED BIB]")
        else:
            base_stems.append(
                generate_note_tag(
                    note.typ_text, note.note_index, note.total_in_category,
                    is_annotated_bib=False, add_index=False,
                )
            )

    counts = Counter(base_stems)
    seen = {}
    resolved = []
    for s in base_stems:
        if counts[s] > 1:
            seen[s] = seen.get(s, 0) + 1
            resolved.append(s[:-1] + f" {seen[s]}]")
        else:
            resolved.append(s)
    return resolved


# ---------------------------------------------------------------------------
# DATENMODELLE
# ---------------------------------------------------------------------------

@dataclass
class ItemMetadata:
    item_type: str
    title: str
    creators: list
    venue: str
    year: str
    url: str
    author_short: str
    tags: list
    extra: str

    @property
    def is_publication(self) -> bool:
        return self.item_type in PUBLICATION_TYPES


@dataclass
class StagedNote:
    typ_text: str
    tag: str
    is_annotated_bib: bool
    note_index: int
    total_in_category: int


# ---------------------------------------------------------------------------
# ZOTERO-DATENBANK
# ---------------------------------------------------------------------------

def fetch_item_metadata(cursor, item_id: int) -> ItemMetadata:
    """Holt alle relevanten Metadaten eines Eintrags aus der Zotero-Datenbank."""
    cursor.execute(
        """
        SELECT t.typeName, f.fieldName, v.value
        FROM items i
        JOIN itemTypes t ON i.itemTypeID = t.itemTypeID
        LEFT JOIN itemData d ON d.itemID = i.itemID
        LEFT JOIN fields f ON d.fieldID = f.fieldID
        LEFT JOIN itemDataValues v ON d.valueID = v.valueID
        WHERE i.itemID = ?
        """,
        (item_id,),
    )
    rows = cursor.fetchall()
    item_type = rows[0][0] if rows else ""
    fields = {field_name: value for _, field_name, value in rows if field_name}

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

    creators = _fetch_creators(cursor, item_id)
    author_short = _build_author_short(creators)
    tags = _fetch_tags(cursor, item_id)

    return ItemMetadata(
        item_type=item_type,
        title=title,
        creators=creators,
        venue=venue,
        year=year,
        url=fields.get("url", ""),
        author_short=clean_name(author_short),
        tags=tags,
        extra=fields.get("extra", ""),
    )


def _fetch_creators(cursor, item_id: int):
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
    primary_creators = [c for c in all_creators if c[2] in PRIMARY_CREATOR_TYPES]
    selected = primary_creators if primary_creators else all_creators
    return [(c[0], c[1]) for c in selected]


def _build_author_short(creators) -> str:
    last_names = [last for _, last in creators if last]
    if len(last_names) == 1:
        return last_names[0]
    if len(last_names) == 2:
        return f"{last_names[0]} & {last_names[1]}"
    if len(last_names) > 2:
        return f"{last_names[0]} et al."
    return ""


def _fetch_tags(cursor, item_id: int) -> list:
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
    return [r[0] for r in cursor.fetchall()]


def collect_pdfs(cursor, item_id: int, item_type: str) -> list:
    """Sammelt alle PDF-Attachments, die laut Konfiguration exportiert werden sollen."""
    is_pub = item_type in PUBLICATION_TYPES
    if is_pub and "Publications" not in EXPORT_OPTIONS:
        return []
    if not is_pub and "PDFs" not in EXPORT_OPTIONS:
        return []

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

    staged = []
    for att_path, key in attachments:
        src_pdf = _resolve_attachment_path(att_path, key)
        if src_pdf and src_pdf.exists():
            staged.append(src_pdf)
    return staged


def _resolve_attachment_path(att_path: Optional[str], key: str) -> Optional[Path]:
    raw_filename = att_path.replace("storage:", "") if att_path else ""
    storage_folder = ZOTERO_DIR / "storage" / key

    src_pdf = storage_folder / raw_filename if raw_filename else None
    if not (src_pdf and src_pdf.exists()) and storage_folder.exists():
        pdfs_in_dir = list(storage_folder.glob("*.pdf"))
        if pdfs_in_dir:
            src_pdf = pdfs_in_dir[0]
    return src_pdf


def collect_notes(cursor, item_id: int):
    """Liest alle Notizen des Items und trennt Annotated Bibs von sonstigen Notizen."""
    cursor.execute(
        "SELECT note FROM itemNotes WHERE parentItemID = ? OR itemID = ?",
        (item_id, item_id),
    )
    raw_notes = cursor.fetchall()

    annotated_bibs, other_notes = [], []
    for (raw,) in raw_notes:
        if not (raw and raw.strip()):
            continue
        typ_text = html_to_typst(raw)

        if FILTER_DEMO_FILES and is_empty_demo_note(typ_text):
            continue

        h_match = re.search(r"^(?:==|=)\s+(.+)$", typ_text, re.MULTILINE)
        h_text = h_match.group(1) if h_match else ""

        if "annotated bib" in h_text.lower():
            annotated_bibs.append(typ_text)
        else:
            other_notes.append(typ_text)

    return annotated_bibs, other_notes


# ---------------------------------------------------------------------------
# SAMMLUNGSBAUM
# ---------------------------------------------------------------------------

def load_collections(cursor) -> dict:
    cursor.execute("SELECT collectionID, collectionName, parentCollectionID FROM collections")
    return {
        row[0]: {"name": clean_name(row[1]), "parent": row[2]}
        for row in cursor.fetchall()
    }


def find_target_collection(all_colls: dict, target_name: str) -> Optional[int]:
    return next(
        (cid for cid, info in all_colls.items() if info["name"].lower() == target_name.lower()),
        None,
    )


def get_descendant_collection_ids(ancestor_id: int, all_colls: dict) -> set:
    children_by_parent = {}
    for collection_id, info in all_colls.items():
        children_by_parent.setdefault(info["parent"], []).append(collection_id)

    descendants = set()
    pending = [ancestor_id]
    while pending:
        collection_id = pending.pop()
        if collection_id in descendants:
            continue
        descendants.add(collection_id)
        pending.extend(children_by_parent.get(collection_id, []))

    return descendants


def get_relative_path(coll_id: int, ancestor_id: int, all_colls: dict) -> Path:
    parts = []
    curr = coll_id
    while curr in all_colls and curr != ancestor_id:
        parts.insert(0, all_colls[curr]["name"])
        curr = all_colls[curr]["parent"]
    return Path(*parts) if parts else Path(".")


# ---------------------------------------------------------------------------
# TYPST-KOMPILIERUNG
# ---------------------------------------------------------------------------

def compile_typst_file(typ_path: Path, pdf_path: Path) -> None:
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


# ---------------------------------------------------------------------------
# EXPORT-ORDNER AUFRÄUMEN
# ---------------------------------------------------------------------------

def clean_export_directory(export_dir: Path) -> None:
    """Entfernt Exportinhalte rekursiv und bewahrt Skriptdateien auf."""
    script_extensions = {".py", ".pyw", ".ps1", ".bat", ".cmd", ".sh"}

    def remove_non_script_content(path: Path) -> None:
        if path.is_symlink():
            prepare_path(path).unlink()
        elif path.is_dir():
            for child in path.iterdir():
                remove_non_script_content(child)
            if not any(path.iterdir()):
                prepare_path(path).rmdir()
        elif path.suffix.lower() not in script_extensions:
            prepare_path(path).unlink()

    for item in prepare_path(export_dir).iterdir():
        remove_non_script_content(item)


# ---------------------------------------------------------------------------
# SCHREIBEN VON DATEIEN
# ---------------------------------------------------------------------------

def write_pdf(src_pdf: Path, item_folder: Path, use_subfolder: bool, meta: ItemMetadata, pdf_index: int, pdf_total: int) -> None:
    source_tag = "[SOURCE]" if pdf_total == 1 else f"[SOURCE_{pdf_index}]"

    if use_subfolder:
        pdf_stem = source_tag
    else:
        pdf_stem = build_filename(meta.author_short, meta.year, meta.title, tag=source_tag) \
            or clean_name(f"{source_tag} - {src_pdf.stem[:30]}")

    dst_pdf = item_folder / f"{pdf_stem}.pdf"
    counter = 1
    while prepare_path(dst_pdf).exists():
        dst_pdf = item_folder / f"{pdf_stem}_{counter}.pdf"
        counter += 1

    try:
        shutil.copy2(prepare_path(src_pdf), prepare_path(dst_pdf))
    except Exception as e:
        print(f"Fehler beim Kopieren von PDF '{src_pdf.name}': {e}")


def write_info_file(content: str, item_folder: Path, use_subfolder: bool,
                    meta: ItemMetadata, has_typst: bool,
                    compile_jobs: dict[Path, Path]) -> None:
    if use_subfolder:
        info_stem = "[INFO]"
    else:
        info_stem = build_filename(meta.author_short, meta.year, meta.title, tag="[INFO]") \
            or clean_name(f"[INFO] - {meta.title[:30]}")

    info_typ_file = item_folder / f"{info_stem}.typ"
    info_pdf_file = item_folder / f"{info_stem}.pdf"

    try:
        prepare_path(info_typ_file).write_text(content, encoding="utf-8")
        if has_typst:
            compile_jobs[prepare_path(info_pdf_file)] = prepare_path(info_typ_file)
    except Exception as e:
        print(f"Fehler beim Generieren der Info-Datei für '{meta.title}': {e}")


def write_note_file(note: StagedNote, note_stem: str, item_folder: Path, use_subfolder: bool,
                    meta: ItemMetadata, metadata_blocks: str, ieee_citation: str,
                    has_typst: bool, compile_jobs: dict[Path, Path]) -> None:
    if not use_subfolder:
        note_stem = build_filename(meta.author_short, meta.year, meta.title, tag=note.tag) or clean_name(note.tag)

    safe_title = escape_typst_text(meta.title)

    if note.is_annotated_bib:
        header_line = f"== {safe_title or 'Annotated Bibliography'}\n\n{metadata_blocks}"
    else:
        ieee_block = (
            f'#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[\n'
            f'  #text(size: 0.9em)[*Citation:* {ieee_citation}]\n]'
            if ieee_citation else ""
        )
        header_line = f"== {safe_title or 'Note'}\n\n{ieee_block}"

    typ_text = note.typ_text
    if re.search(r"^(?:==|=)\s+", typ_text, re.MULTILINE):
        # lambda statt String-Replacement: verhindert, dass \* als re.sub-Escape interpretiert wird
        typ_text = re.sub(
            r"^(?:==|=)\s+.*$",
            lambda _m: header_line,
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
            compile_jobs[prepare_path(note_pdf_file)] = prepare_path(note_typ_file)
    except Exception as e:
        print(f"Fehler beim Schreiben/Kompilieren der Notiz {note_typ_file}: {e}")


# ---------------------------------------------------------------------------
# ITEM-VERARBEITUNG
# ---------------------------------------------------------------------------

def process_item(cursor, item_id: int, target_folder: Path, has_typst: bool,
                 compile_jobs: dict[Path, Path]) -> None:
    """Verarbeitet ein einzelnes Zotero-Item vollständig."""
    prepare_path(target_folder).mkdir(parents=True, exist_ok=True)

    meta = fetch_item_metadata(cursor, item_id)
    staged_pdfs = collect_pdfs(cursor, item_id, meta.item_type)
    annotated_bibs, other_notes = collect_notes(cursor, item_id)

    ieee_citation = format_ieee_citation(meta.creators, meta.title, meta.venue, meta.year, meta.url)
    parsed_tags = parse_ethereal_tags(meta.tags, meta.extra)
    metadata_blocks = build_metadata_blocks(ieee_citation, parsed_tags)
    has_valid_metadata = bool(meta.title.strip() or ieee_citation.strip())

    staged_info = _build_info_content(meta, metadata_blocks, has_valid_metadata, annotated_bibs)
    staged_notes = _stage_notes(annotated_bibs, other_notes)

    use_subfolder = bool(staged_notes) or staged_info is not None or len(staged_pdfs) > 1

    base_paper_stem = build_filename(meta.author_short, meta.year, meta.title) \
        or clean_name(meta.title[:35]) or "Paper"

    item_folder = target_folder / base_paper_stem if use_subfolder else target_folder
    if use_subfolder:
        prepare_path(item_folder).mkdir(parents=True, exist_ok=True)

    resolved_stems = resolve_note_stems(staged_notes) if use_subfolder else []

    for pdf_idx, src_pdf in enumerate(staged_pdfs, 1):
        write_pdf(src_pdf, item_folder, use_subfolder, meta, pdf_idx, len(staged_pdfs))

    if staged_info is not None:
        write_info_file(staged_info, item_folder, use_subfolder, meta, has_typst, compile_jobs)

    for pos, note in enumerate(staged_notes):
        note_stem = resolved_stems[pos] if use_subfolder else ""
        write_note_file(
            note, note_stem, item_folder, use_subfolder, meta, metadata_blocks,
            ieee_citation, has_typst, compile_jobs,
        )


def _build_info_content(meta: ItemMetadata, metadata_blocks: str,
                        has_valid_metadata: bool, annotated_bibs) -> Optional[str]:
    has_annotated_bibs = len(annotated_bibs) > 0 and "Annotated Bibs" in EXPORT_OPTIONS
    if "Publication Infos" not in EXPORT_OPTIONS or not has_valid_metadata or has_annotated_bibs:
        return None

    safe_title = escape_typst_text(meta.title)
    content = f"== {safe_title or 'Publication Metadata'}\n\n{metadata_blocks}"
    if FILTER_DEMO_FILES and is_empty_demo_note(content):
        return None
    return content


def _stage_notes(annotated_bibs, other_notes) -> list:
    staged = []

    if "Annotated Bibs" in EXPORT_OPTIONS:
        total = len(annotated_bibs)
        for idx, typ_text in enumerate(annotated_bibs, 1):
            tag = generate_note_tag(typ_text, idx, total, is_annotated_bib=True)
            staged.append(StagedNote(typ_text, tag, True, idx, total))

    if "Notes" in EXPORT_OPTIONS:
        total = len(other_notes)
        for idx, typ_text in enumerate(other_notes, 1):
            tag = generate_note_tag(typ_text, idx, total, is_annotated_bib=False)
            staged.append(StagedNote(typ_text, tag, False, idx, total))

    return staged


# ---------------------------------------------------------------------------
# HAUPTPROGRAMM
# ---------------------------------------------------------------------------

def ensure_pandoc_available() -> None:
    """Stellt sicher, dass Pandoc vorhanden ist; bietet Download an."""
    try:
        pypandoc.get_pandoc_version()
        return
    except OSError:
        pass

    print("Pandoc wurde auf deinem System nicht gefunden.")
    answer = input(
        "Möchtest du Pandoc jetzt automatisch herunterladen und installieren? (j/n): "
    ).strip().lower()

    if answer in {"j", "ja", "y", "yes"}:
        print("Lade Pandoc automatisch herunter...")
        pypandoc.download_pandoc()
        print("Pandoc erfolgreich installiert!")
    else:
        print("Export abgebrochen, da Pandoc erforderlich ist.")
        sys.exit(0)


def export_zotero() -> None:
    """Hauptfunktion für den Exporter."""
    ensure_pandoc_available()

    db_path = ZOTERO_DIR / "zotero.sqlite"
    if not db_path.exists():
        print(f"Fehler: zotero.sqlite unter {db_path} nicht gefunden!")
        return

    has_typst = shutil.which("typst") is not None
    compile_jobs = {}

    with tempfile.TemporaryDirectory() as tmpdir:
        tmp_db = Path(tmpdir) / "zotero.sqlite"
        shutil.copy2(db_path, tmp_db)

        conn = sqlite3.connect(tmp_db)
        try:
            cursor = conn.cursor()
            all_colls = load_collections(cursor)
            target_id = find_target_collection(all_colls, TARGET_COLLECTION)

            if target_id is None:
                print(f"Fehler: Die Sammlung '{TARGET_COLLECTION}' wurde in Zotero nicht gefunden!")
                return

            clean_export_directory(EXPORT_DIR)

            target_collection_ids = get_descendant_collection_ids(target_id, all_colls)
            cursor.execute(
                "CREATE TEMP TABLE export_collection_ids "
                "(collectionID INTEGER PRIMARY KEY)"
            )
            cursor.executemany(
                "INSERT INTO export_collection_ids (collectionID) VALUES (?)",
                ((collection_id,) for collection_id in target_collection_ids),
            )
            items_cursor = conn.cursor()
            items_cursor.execute(
                """
                SELECT ci.collectionID, ci.itemID
                FROM collectionItems ci
                JOIN export_collection_ids eci
                  ON eci.collectionID = ci.collectionID
                ORDER BY ci.collectionID, ci.itemID
                """
            )
            for coll_id, item_id in items_cursor:
                target_folder = EXPORT_DIR / get_relative_path(coll_id, target_id, all_colls)
                process_item(cursor, item_id, target_folder, has_typst, compile_jobs)
        finally:
            conn.close()

    if compile_jobs:
        worker_count = min(TYPST_COMPILE_WORKERS, len(compile_jobs))
        with ThreadPoolExecutor(max_workers=worker_count) as executor:
            futures = [
                executor.submit(compile_typst_file, typ_path, pdf_path)
                for pdf_path, typ_path in compile_jobs.items()
            ]
            for future in as_completed(futures):
                future.result()

    print(f"Export von '{TARGET_COLLECTION}' erfolgreich abgeschlossen!")


if __name__ == "__main__":
    export_zotero()
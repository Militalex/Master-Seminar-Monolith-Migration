#import "@preview/charged-ieee:0.1.4": ieee

// Own Commands
#let citeauthor(cite-label) = cite(cite-label, form: "prose")

#let note(body) = text(fill: color.darken(blue, 60%))[*NOTES:*\ #body]
#let todo(body) = text(fill: purple)[*< TODO: #body >*]

#let template-setup(
  doc-title: [Beispiel Titel: Bitte anpassen],
  doc-authors: (
    (
      name: "Alexander Ley",
      department: [Computer Science Department],
      organization: [University of applied science Bonn-Rhein-Sieg],
      location: [Sankt Augustin, Germany],
      email: "s6alleyy@outlook.de"
    ),
  ),
  doc-abstract: none,
  bib-path: "../00 assets/refs.bib",
  doc-index-terms: (),
  doc-figure-supplement: [Fig.],
  body
) = {
  // Verringert den vertikalen Abstand für alle Block-Zitate
  show quote.where(block: true): set block(
    above: 1em,
    below: 1em,
  )

  // Load IEEE Template
  show: ieee.with(
    title: doc-title,
    authors: doc-authors,
    index-terms: doc-index-terms,
    abstract: doc-abstract,
    bibliography: bibliography(bib-path, style: "ieee"),
    figure-supplement: doc-figure-supplement,
  )

  body
}
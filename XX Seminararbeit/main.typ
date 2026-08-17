#import "@preview/charged-ieee:0.1.4": ieee

#let citeauthor(cite-label) = cite(cite-label, form: "prose")

#show: ieee.with(
  title: [SLR: Strategies for the automated identification of service interfaces during the migration from monoliths to microservices],
  abstract: [
    #lorem(120)
  ],
  authors: (
    (
      name: "Alexander Ley",
      department: [Computer Science Department],
      organization: [University of applied science Bonn-Rhein-Sieg],
      location: [Sankt Augustin, Germany],
      email: "s6alleyy@outlook.de"
    ),
  ),
  index-terms: (),
  bibliography: bibliography("refs.bib"),
  figure-supplement: [Fig.],
)

= Introduction

= Related Work

= Methods

= Results

= Discussion

= Conclusion

= Appendix
#include "appendix.typ"
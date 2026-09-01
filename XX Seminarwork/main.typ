#import "../00 assets/preamble.typ": *

#show: template-setup.with(
  doc-title: [SLR: Strategies for the automated identification of service interfaces during the migration from monoliths to microservices],
  doc-abstract: lorem(120)
)

= Introduction

#note[
  Traditionally, teams in Software Engineering of business applications are divided along technical capabilities.

  According to Conway's Law, which is quoted in @quote:conways_law, the technically oriented team decomposition yields to the technically oriented decomposition of the software output, which is illustrated in figure @fig:monolith.

  #figure(
    box(stroke: 1pt, inset: 1em, radius: 1em, fill: color.silver)[
      "Any organization that designs a system (defined broadly) will produce a design whose structure is a copy of the organization's communication structure."
    ],
    kind: "quote",
    supplement: [Quote],
    caption: [Conway's Law quoted by Melvin Conway, 1968 @lewis2014Microservices]
  ) <quote:conways_law>

  #figure(
    image("../00 assets/figures/Monolith.jpg", width: 90%),
    caption: [Illustration of a business application built as a monolith. Original illustration from #citeauthor(<nockemann2025DomainDriven>).]
  ) <fig:monolith>

  #figure(
    image("../00 assets/figures/Monoliths vs. Microservices.png", width: 75%),
    placement: auto,
    scope: "parent",
    caption: [Scaling and deploying of Monoliths and Microservices by #citeauthor(<lewis2014Microservices>)]
  ) <fig:monolith_and_microservices>

  == Migration Strategies (according #citeauthor(<abdellatif2021taxonomy>))
  The authors #citeauthor(<abdellatif2021taxonomy>) suggest three general strategies of migrating a legacy system into a SOA: _top-down-_, _bottom-up-_ and _hybrid strategies_

  #include "../00 assets/mindmaps/Migration Strategies according Abdellatif.typ"

  === Domain-Driven Design (DDD)
  #todo[DDD Buch verwenden und referenzieren]
  - tactical design and strategiel design
  - tactical design defines how the domain model is composed #todo[Beispiel einbauen?] and to identify bounded Contexts
  - strategiel design defines how the bounded contexts communicates
]

= Related Work

= Methods

= Results

= Discussion

= Conclusion

= Appendix
#include "appendix.typ"
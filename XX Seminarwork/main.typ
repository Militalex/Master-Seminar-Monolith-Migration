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
#todo[Mehr in SLR-Methodik einlesen]

#note[
  == Planning Phase
  - Identify the need for a review and the development of a review protocol
    - leading to the development of research questions

  === Identify the Need for an SLR
  - Explain why your SLR is necessary?
  - Which gap does it close?
  - Which other Literature does exist (only coarse, in a nutshell, not detailed)?
  - Why would be an SLR beneficial for your area?

  === Specifying the Research questions
  - What are your research questions?

  === Defining and Evaluating the Review Protocol
  - Where and who has performed the SLR? Which university?
    - Who lead the SLR, who wrote the protocol and who performed the Evaluations?
  - What are your IC and ECs?

  == Review Phase

  === Selection of Primary Studies
  - Talk about your identified Keywords.
    - What were your initial keywords? What synonyms did you found?
  - Which Search Strings did you used?
  - Explain how you selected the studies. Which inner phases and refinements the studies went through?
  - What happened during the semester? Which meetings, how often you have meet with the supervisor?
  - Explain _Snowballing_. What iterations did you do applying snowballing?
  - How many Paper are included thank to snowballing
  - Provide a figure showing the progress the paper went through and show how many are discarded in each step.
  - Provide a table with all selected studies, including title, number, Type, Year and so on...

  === Analysis of the Data
  - Explain how you extracted the Data. Which Tools did you use?
  - What Data did you extract?
  - Which data was obvious and inviolable?
]

= Results

= Discussion

= Conclusion

= Appendix
#include "appendix.typ"
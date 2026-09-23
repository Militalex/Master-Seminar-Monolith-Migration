#block[
#block[
== Service Cutter: A Systematic Approach to Service Decomposition

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Source:* M. Gysel _et al._ "Service Cutter: A Systematic Approach to Service Decomposition," _Proceedings of the 5th European Conference on Service-Oriented and Cloud Computing (ESOCC 2016)_, 2016. [Online]. Available: #link("http://link.springer.com/10.1007/978-3-319-44482-6_12")]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Rating:* ⭐⭐⭐⭐⭐]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Own Keywords:* Approaches, Background, Domain-Driven Design (DDD), Coupling Criteria]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Reading Progress:* First Pass]
]

== Introduction (What is the Paper about?)

- defining #strong[Coupling Strategies in a catalog]
- present a tool called #strong[Service Cutter] using that coupling
  strategies
- present useful definitions for the field

== Methods

- #strong[Service Cutter] extracts information from software engineering
  artifacts such as Domain Models and Use Cases
  - represent them as an uni-directed, weighted graph
  - find and score densely connected clusters
- #strong[Validation Activities] including #emph[Prototyping, Action
  Research] (?) and #emph[Two Case Studies]
  - Performance Measurements
  - Feedback from members of the target audience in industry and
    academia

== Scientific Benefit

- Collect #strong[Coupling Strategies in a catalog] distilled from
  literature, industry and workshops
  - Catalog can serve to establish common terminology in discussions and
    documentation
- Introduced #strong[Service Cutter] a knowledge management method and
  supporting tool framework assisting software architects when they
  making service design decisions
  - Can also suggest service decomposition candidates
- Most, but not all test scenarios resulted in appropriate service cuts
- Members from the target audience in industry and academia acknowledge
  that presented coupling criteria catalog and tool-supported service
  decomposition method have the potential to assist service architect's
  design decisions

== Challenges / Future Work

== Limitations

- not intended to fully automate Service Decomposition but rather
  support it
- collection might not yet be complete
  - \(Own) Requirements on software might change in the future or might
    be weighted differently

== Paper Outline and Read Progress

+ \[X\] Introduction
+ \[X\] Scopes the context and defines terminology
+ \[X\] Presentation of the Coupling Criteria Catalog
+ \[ ~\] Definition of a novel service decomposition process and tool
  architecture
+ \[ ~\] Presentation of an Implementation #emph[\(Service Cutter)] and
  validation
  - includes two case studies and performance measurements
+ \[ ~\] Discussion of Strengths and Weaknesses of Service Cutter
+ \[ ~\] Conclusion and Future Work

== Own Comments

- \(+) Key paper
- \(+) Paper serves as foundation of the field of #emph[Service
  Decomposition]
- \(-) Validation manly is based on peoples opinion #emph[\(Empirical)]
- \(-) Coupling Criterions could be slithly different today
  #emph[\(Potentially outdated now)] including more or different
  criterions
  - Assume that they not change so fast, but this should be reevaluated
]
]
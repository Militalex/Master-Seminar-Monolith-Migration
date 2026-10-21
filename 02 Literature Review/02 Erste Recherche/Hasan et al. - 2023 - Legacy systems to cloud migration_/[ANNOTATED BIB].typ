#block[
#block[
== Legacy systems to cloud migration: A review from the architectural perspective

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Source:* M. H. Hasan _et al._ "Legacy systems to cloud migration: A review from the architectural perspective," _Journal of Systems and Software_, 2023. [Online]. Available: #link("https://linkinghub.elsevier.com/retrieve/pii/S0164121223000973")]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Paper Information:* Systematic Literature Review (SLR)]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Rating:* ⭐⭐⭐⭐]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Own Keywords:* Background, Cloud Migration, Migration]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Reading Progress:* Second Pass]
]

== Introduction (What is the Paper about?)

- #strong[This paper aims to understand the current state of legacy to
  cloud migration progress:]
  - The motivation for cloud migration
  - existing cloud migration frameworks and patterns
  - target architecture for the cloud
  - derive post-migration quality issues
- #strong[Focus on to investigate Cloud Migration in general]
  - compare drivers with the resulting concerns
- #strong[Review of the current legacy to cloud migration approaches]
  - encompassing pre-migration, migration and post-migration
- #strong[Implementation point of view]

== Methods

- #emph[Systematic Literature Review (SLR)] with 47 selected studies
  - covering pre-migration, migration and post-migration stages
  - maintainability and quality perspective
  - consolidate also previous studies

== Scientific Benefit

- #strong[The migration phases are differential well covered]
  - Most studies focus on the planning phase
    - involving a monolith decomposition approach
  - for the migration phase itself only a high-level explanation was
    given
  - limited studies include the post-migration phase
- #strong[Microservices have been identified as the most targeted
  architectural pattern for a migration target]
- #strong[Maintainability, scalability and flexibility are the main
  drivers for cloud migration]
- #strong[Cloud Migration do not fully fulfill the migration drivers]
  - Cloud Migration can satisfy scalability, flexibility, manageability
    and resiliency but not the main driver of maintainability
  - Security and performance concerns rise after cloud migration
    - performance because of inadequate experience of system architects
- #strong[Migration approaches lack quality consideration]
  - contributing to post-migration quality concerns

== Challenges / Future Work

- #strong[Future research might focus on post-migration concerns]

== Limitations

== Paper Outline and Read Progress

+ \[X\] Introduction
+ \[ ~\] Related Work
+ \[ ~\] Methods
+ \[X\] Results: Findings and answer to the RQ's
+ \[X\] Discussion: Discuss main findings
+ \[X\] Threats to validity #emph[\(No Limitation)]
  - Authors explain why their study is valid
+ \[X\] Conclusion

== Own Comments

- \(-) Fist Pass provides not many information about the results of the
  paper
- \(-) Focus on to cloud migration in general without focus on
  microservices
  - Monolith Migration is a subset of Cloud Migration
- \(-) No focus on Service-Interfaces or API-Design
]
]
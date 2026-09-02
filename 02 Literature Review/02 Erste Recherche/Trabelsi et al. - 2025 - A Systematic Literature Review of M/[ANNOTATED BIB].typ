#block[
#block[
== A Systematic Literature Review of Machine Learning Approaches for Migrating Monolithic Systems to Microservices

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Source:* I. Trabelsi _et al._ "A Systematic Literature Review of Machine Learning Approaches for Migrating Monolithic Systems to Microservices," _IEEE Transactions on Software Engineering_, 2025. [Online]. Available: #link("https://ieeexplore.ieee.org/document/11145241/")]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Paper Information:* Key Paper, Systematic Literature Review (SLR)]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Rating:* ⭐⭐⭐⭐⭐]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Own Keywords:* Approaches, Machine Learning (ML)]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Reading Progress:* First Pass]
]

== Introduction (What is the Paper about?)

- #strong[Research GAP:] No prior work has yet systematically
  investigated #emph[Machine Learning (ML)] Approaches during the
  migration from monolithic systems to microservices
- This paper present a #emph[Systematic-Literature Review (SLR)] to
  address the above gap

== Methods

- #strong[Created an #emph[Systematic-Literature Review (SLR)]]
  - followed the updated #emph[Preferred Reporting Items for Systematic
    Review and Meta-Analysis (PRISMA)] statement for reporting
    systematic reviews
- Screened 2,301 potentially relevant studies from eight digital
  libraries #strong[considering publications between 2015 and 2024]
  - used Inclusion- and Exclusion criteria
  - used #emph[Snowball Sampling]
  - retained 81 studies for analysis after quality assessment

== Scientific Benefit

- #strong[Comprehensive Understanding of how ML can be used to support
  the Migration]
  - systematic analysis of the automated migration phases using ML
    - identifying gaps
  - synthesis of the types of inputs used in ML-driven approaches
    - including granularity, sources and how it is preprocessed
  - analysis of the applied ML techniques
    - highlighting commonly used models, emerging techniques
  - exploration of evaluation practices identifying common metrics,
    benchmarks and success criteria
  - discussion of the challenges encountered including scalability, data
    availability and the interpretability of models
  - Set of recommendations for practitioners and researcher
- #strong[Phases are differential well studied]
  - Well studied phases: #emph[Monitoring, Deployment] and #emph[Service
    Identification]
  - Less well studied: #emph[Pre-Migration], #emph[Packaging
    Microservices, Generating necessary code for microservice APIs] and
    #emph[Implementing Design Patterns]
  - #emph[Automating code generation] and #emph[Packaging Tasks] has
    received limited attention despite the potential of emerging
    technologies like LLM
- #strong[Extracted Key Challenges] hindering adoption in practical
  scenarios:
  - Insufficient availability of high-quality data
  - Scalability and complexity concerns
  - Insufficient tool support
  - Absence of standardized benchmarks, datasets and baselines

== Challenges / Future Work

- #strong[Automation of #emph[Business Processes (BP)] discovery and
  refactoring remains largely unexplored]
  - valuable opportunity for future research using #emph[NLP],
    #emph[Process Mining] or #emph[LLMs]
- #strong[Scarcity of real-world datasets]
  - raises concerns about the practical applicability of ML techniques
- #strong[Evaluation Practices vary widely]
  - System adaptability and real-world validation is often overlooked
- #strong[Enhancing data accessibility through industry] collaboration,
  privacy-preserving data-sharing frameworks #strong[and development of
  benchmark datasets will be crucial]
- Exploring hybrid ML approaches integrating multiple learning paradigms
  could be beneficial to accuracy and adaptability in the migration
  process

== Limitations

== Paper Outline and Read Progress

+ \[X\] Introduction
+ \[X\] Background and Related Work on monolithic to microservice
  migration
+ \[ ~\] Description of the SLR Methodology and used analysis processes
+ \[ ~\] Statistical Overview of the selected Literature
+ \[ ~\] Current Phases of migration being currently automated using ML
+ \[ ~\] Types of data collected and processes using ML
+ \[ ~\] ML techniques applied in migration
+ \[ ~\] How ML-based techniques are evaluated
+ \[ ~\] Challenges and Limitations of applying ML
+ \[ ~\] Observations and Recommendations
+ \[ ~\] Limitations
+ \[X\] Conclusion

== Own Comments

- \(+) Key Paper which might give an overview over the current field
- \(-) Introduction feels a bit repetitive. It could be shortened
- \(-) problems with citation numbering
  - in #emph[Table of closely related work] citations might not be all
    correct
    - e.g. the year of \[19\] does not match
  - citation \[15\] is used twice for two different sources
]
]
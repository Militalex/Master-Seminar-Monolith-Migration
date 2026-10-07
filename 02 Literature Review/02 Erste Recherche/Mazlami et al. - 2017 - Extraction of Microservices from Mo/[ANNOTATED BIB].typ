#block[
#block[
== Extraction of Microservices from Monolithic Software Architectures

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Source:* G. Mazlami _et al._ "Extraction of Microservices from Monolithic Software Architectures," _2017 IEEE International Conference on Web Services (ICWS)_, 2017. [Online]. Available: #link("http://ieeexplore.ieee.org/document/8029803/")]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Paper Information:* Key Paper]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Rating:* ⭐⭐⭐⭐]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Own Keywords:* Approaches, Clustering, Graph-based]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Reading Progress:* Second Pass]
]

== Introduction (What is the Paper about?)

- addressing the decomposition problem of monolithical applications into
  microservices #strong[algorithmically and graph-based]
- apply approaches from the software decomposition research formally and
  (semi-)automated to microservices

== Methods

- constructed a web-based prototype
- tested three formal coupling strategies used to construct a graph from
  code
  - perform a clustering algorithm on that
- performance evaluation on the prototype with custom
  microservice-specific metrics on 21 open source projects in Java, Ruby
  and Python

== Scientific Benefit

- Presenting a formal microservice extraction model as web-based
  prototype
  - semi-automated without heavy user input
- allow algorithmic recommendations of microservice candidates in a
  refactoring and migration scenario
- size of produced microservice candidates conforms with reported
  microservice size in empirical surveys
- produced microservice candidates lower the average development team
  size down to half of the original size or lower
- domain-specific redundancy among different microservices is kept low

== Challenges / Future Work

== Limitations

- extraction model uses classes as atomic unit rather than methods or
  procedures
  - left for future work
- extraction model treats database entities as normal classes
  - still unsolved to share or assign pre-existing databases to
    different models

== Paper Outline and Read Progress

+ \[X\] Introduction
+ \[X\] Related Work
+ \[ ~\] Formal Definition of the Extraction Models, Coupling Strategies
  and Clustering Algorithm
+ \[ ~\] Performance and Quality Evaluation
+ \[X\] Limitations and Future Work
+ \[ ~\] Conclusion

== Own Comments

- \(+) Potential key paper
- \(+) First Paper applying software decomposition methods to
  microservices
- \(-) potentially outdated
- \(-) custom metrics
- \(-) missing reference of Komondoor et al.
]
]
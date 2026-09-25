#block[
#block[
== Microservices: A definition of this new architectural term

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Source:* J. Lewis and M. Fowler "Microservices: A definition of this new architectural term," 2014. [Online]. Available: #link("https://martinfowler.com/articles/microservices.html")]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Paper Information:* Definitions]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Rating:* ⭐⭐⭐⭐]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Own Keywords:* Background, DevOps, Domain Driven Design (DDD), Microservices, Migration, Monolith]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Reading Progress:* Third Pass]
]

== Introduction (What is the Paper about?)

- The article describes the emerging architectural style “Microservices”
  as an approach to developing a single application as a suite of small,
  independently deployable services.
- Each service runs in its own process and communicates through
  lightweight mechanisms, often an HTTP resource API.
- The article contrasts microservices with the monolithic architectural
  style and discusses common characteristics, consequences, and
  trade-offs.
- Core characteristics include: organization around business
  capabilities, automated deployment, intelligence in the endpoints, and
  decentralized control of languages and data.
- The authors do not provide a formal definition. Instead, they describe
  common characteristics observed in projects and among practitioners.
- The article closes with a cautious discussion of whether microservices
  are the future direction for software architecture.

== Methods

- No formal research design; this is an experience-based architecture
  article and opinion piece.
- Conceptual comparison between monolithic architecture and microservice
  architecture.
- Description of practices and industry examples, including Amazon,
  Netflix, The Guardian, UK Government Digital Service,
  realestate.com.au, Forward, and comparethemarket.com.
- Discussion of related practices and patterns: Continuous Delivery,
  Infrastructure Automation, Consumer-Driven Contracts, Tolerant Reader,
  Circuit Breaker, Semantic Monitoring, and asynchronous communication.
- No systematic data collection, no statistical analysis, and no
  Systematic Literature Review.
- References to related work, books, presentations, and papers are
  provided, but the article itself is not a peer-reviewed study.

== Scientific Benefit

- Foundational and highly cited article that helped define and
  popularize the term “microservices.”
- Provides a shared vocabulary and a structured description of the
  characteristics of microservice architectures.
- Contrasts monoliths and microservices regarding scaling, deployment,
  modularity, and team organization.
- Discusses central trade-offs: strong module boundaries, independent
  deployment, and technology diversity versus distribution, eventual
  consistency, and operational complexity.
- Offers practical examples and patterns, making it useful as a
  background and related-work source.
- Relevant for topics such as service identification, monolith
  decomposition, and migration toward microservices.
- Emphasizes that microservices are not a novel invention but have roots
  in Unix design principles and service-oriented approaches.

== Challenges / Future Work

- Open question whether microservices are truly the future standard
  architecture; long-term maturity is unclear.
- Finding the right service boundaries is difficult. Refactoring across
  remote boundaries is much harder than with in-process libraries.
- Interface changes require coordination, backward compatibility, and
  more complex testing.
- Complexity can be shifted from inside components to the connections
  between services, where it is less explicit and harder to control.
- Team skill is a critical factor. Less skilled teams may create messy
  microservice systems, and it is unclear whether microservices reduce
  or worsen such mess.
- Operational challenges: monitoring, logging, resilience, eventual
  consistency, and avoiding distributed transactions.
- Recommendation: start with a modular monolith and split into
  microservices once the monolith becomes a problem. However, a good
  in-process interface is usually not a good service interface.
- Future work includes long-term evaluation, better tooling, automation,
  contract management, and resilience practices.

== Limitations

- No formal empirical research design; it is an experience report and
  opinion article.
- No precise or formal definition; only common characteristics are
  described.
- Examples come mainly from successful early adopters; selection bias is
  possible.
- Little quantitative data and no systematic evaluation.
- Published in 2014; later developments such as Kubernetes, service
  mesh, serverless, and LLM-based approaches are not covered.
- Focus on web and enterprise applications; legacy migration,
  mainframes, and regulated environments are barely addressed.
- Authors are part of the microservice community and Thoughtworks;
  enthusiasm bias cannot be excluded.

== Paper Outline and Read Progress

+ \[X\] Introduction / Application Architecture
+ \[X\] Characteristics of a Microservice Architecture
  - \[X\] Componentization via Services
  - \[X\] Organized around Business Capabilities
  - \[X\] Products not Projects
  - \[X\] Smart endpoints and dumb pipes
  - \[X\] Decentralized Governance
  - \[X\] Decentralized Data Management
  - \[X\] Infrastructure Automation
  - \[X\] Design for failure
  - \[X\] Evolutionary Design
+ \[X\] Are Microservices the Future?
+ \[X\] Microservice Trade-Offs
+ \[X\] Sidebars
  - \[X\] How big is a microservice?
  - \[X\] Microservices and SOA
  - \[X\] Many languages, many options
  - \[X\] Battle-tested standards and enforced standards
  - \[X\] Make it easy to do the right thing
  - \[X\] The circuit breaker and production ready code
  - \[X\] Synchronous calls considered harmful
+ \[X\] References / Further Reading
+ \[X\] Significant Revisions

== Own Comments

- \(+) Key paper / foundational article; very useful for definitions,
  characteristics, and trade-offs of microservices.
- \(+) Clear comparison between monoliths and microservices; good
  figures and industry examples.
- \(+) Balanced discussion of drawbacks; not just hype.
- \(-) Not peer-reviewed and no systematic evidence.
- \(-) Definition remains partly vague; the term “micro” is contested.
- \(-) Potentially outdated; published in 2014.
- \(-) No specific focus on legacy modernization, service
  identification, or ML-based migration.
- \(-) Examples are strongly shaped by large tech companies;
  generalizability is limited.
]
]
#import "../00 assets/preamble.typ": *

#show: template-setup.with(
  doc-title: [SLR-Protocol],
  bib-style: "apa"
)

= Theme
The topic of this _Systematic-Literature Review (SLR)_ is: #quote(block: true)[
 #mark(green)["_Interface Design after Monolith Decomposition during the Migration to Microservices_"]
]

= Research Questions
#[
  #set enum(numbering: "RQ1")
  + Which methods and procedures exist for defining service interfaces after the service identification phase in the migration from monoliths to microservices?
    - How are they implemented?
    - Ho mature are they?
  + Which types, patterns and metrics are used in the examined methods and procedures?
  + How are the methods and procedures evaluated?
]

= Literature Search

== Search on 02.10.2026 at ACM
=== ```yasm
[[All: microservice*] OR [All: monolith*]] AND [[All: interface*] OR [All: api*]] AND [[All: identif*] OR [All: extract*] OR [All: generat*] OR [All: decompos*]]
```
- found 12,378 results
- most of the result do not cover migration

=== ```yasm
[[All: microservice*] OR [All: monolith*]] AND [[All: interface*] OR [All: api*]] AND [[All: identif*] OR [All: extract*] OR [All: generat*] OR [All: decompos*]] AND [All: migrat*]
```
- found 3,221 results

=== ```yasm
[[All: microservice*] OR [All: monolith*]] AND [[Abstract: interface*] OR [Abstract: api*]] AND [[All: identif*] OR [All: extract*] OR [All: generat*] OR [All: decompos*]] AND [All: migrat*]
```
- found 306 results

== Search on 05.10.2026 at ACM
=== ```yasm
[[Abstract: microservice*] OR [Abstract: monolith*]] AND [[Abstract: interface*] OR [Abstract: api*]] AND [[All: identif*] OR [All: extract*] OR [All: generat*] OR [All: decompos*]] AND [[All: migrat*] OR [All: packaging]]
```
- 214 results

=== ```yasm
[[Abstract: microservice*] OR [Abstract: monolith*]] AND [[Abstract: interface*] OR [Abstract: api*] OR [Abstract: migrat*] OR [Abstract: packag*]]
```
- 454 results

=== ```yasm
[[Title: microservice*] OR [Title: monolith*]] AND [[Title: interface*] OR [Title: api*] OR [Title: migrat*] OR [Title: packag*]]
```
- 29 results

=== ```yasm
[[All: "monolith*"] OR [All: "legacy system*"] OR [All: "monolithic application*"]] AND [[All: "microservice*"] OR [All: "micro-service*"] OR [All: "micro service*"]] AND [[All: "interface identification"] OR [All: "service interface*"] OR [All: "api identification"] OR [All: "interface extraction"] OR [All: "interface recovery"] OR [All: "service boundary*"]]
```
- 55 results

=== ```yasm
[[All: "migration"] OR [All: "migrat*"] OR [All: "decomposition"] OR [All: "decompos*"] OR [All: "refactor*"] OR [All: "modernization"]]
AND
[[All: "monolith*"] OR [All: "legacy system*"]]
AND
[[All: "microservice*"] OR [All: "micro-service*"]] AND [[All: "service identification"] OR [All: "service interface*"] OR [All: "api*"] OR [All: "interface*"]]
```
- 226 results

== Search at ACM
=== Microservice, Monolith and Migration in Abstract and Interfaces Aspects Full-Text Search
```yasm
[[Abstract: microservice*] OR [Abstract: micro-service*] OR [Abstract: micro service*]]
AND
[[Abstract: monolith*] OR [Abstract: legacy system*] OR [Abstract: legacy software*] OR [Abstract: legacy application*]]
AND
[[Abstract: migrat*] OR [Abstract: decompos*] OR [Abstract: moderniz*] OR [Abstract: refactor*] OR [Abstract: transformation] OR [Abstract: reengineering]]
AND
[[All: service interface*] OR [All: service contract*] OR [All: api design] OR [All: api specification] OR [All: api contract*] OR [All: interface design] OR [All: interface specification] OR [All: interface selection] OR [All: endpoint design] OR [All: service boundar*] OR [All: communication pattern*]]
```
- 85 results (07.10.2026)
- 89 results (28.10.2026)
- 89 results (04.11.2026)

=== DeepSeek AI Categorized Papers from the first 20 in @tab:ai_cat
#[
  #set text(size: 7pt)
  #figure(
    placement: bottom,
    scope: "parent",
    table(
      columns: (0.7cm, 5.3cm, 6.8cm, 4.4cm),
      align: (center, left, left, left),
      stroke: 0.5pt,
      inset: 5pt,
      fill: (x, y) => if y == 0 {
        rgb("#D9D9D9")
      } else if calc.even(y) {
        rgb("#F5F5F5")
      } else {
        white
      },
      // Header
      [*Nr.*], [*Paper*], [*Warum relevant*], [*Interface-Aspekt*],

      // Row 1
      [1],
      [Handling Communication via APIs for Microservices (Kanvar et al., 2023)],
      [Kernstudie. Vergleicht JSON- vs. ID-passing für API-Kommunikation, entwickelt Algorithmus zur API-Reduktion (Function Isolation).],
      [API-Design, Kommunikationsmechanismen, API-Reduktion],

      // Row 2
      [2],
      [A Catalog of Non-Functional Requirements and Patterns for Microservices Migration (Veronez et al., 2024)],
      [Katalogisiert Patterns für API, API Gateway, API-Versioning, Database per Service, Service Registry.],
      [API-Patterns, Interface-bezogene NFRs],

      // Row 3
      [3],
      [Migrating from Monolithic to Microservices with Hybrid Database Design Architecture (Ng et al., 2024)],
      [Beschreibt API Gateway, Service Registry, Saga Choreography, RabbitMQ als Kommunikationsmedium.],
      [API Gateway, Messaging-Interfaces, Saga],

      // Row 4
      [4],
      [Towards Service Discovery and Autonomic Version Management in Self-healing Microservices Architecture (Wang, 2019)],
      [Service Discovery, API-Versioning, Blue-Green/Canary Deployment als Interface-Management.],
      [Service Discovery, API-Versioning, Version-Management],

      // Row 5
      [5],
      [Design and Practice of Digital Transformation for Large-Scale Group Treasury Management Systems (Xie et al., 2025)],
      [Praxisbericht mit API Gateway, Service Registry, RESTful APIs, Saga, ESB/SAP PO.],
      [API Gateway, REST-Interfaces, Service Registry],

      // Row 6
      [6],
      [Modernizing Legacy Systems with Microservices: A Roadmap (Wolfart et al., 2021)],
      [Aktivität 4 „Define the microservice architecture“ behandelt explizit APIs, Kommunikationsprotokolle, Service Discovery.],
      [Interface-Definition als Roadmap-Aktivität],

      // Row 7
      [7],
      [Cloud-Native Architecture for Municipal Government (Sun, 2025)],
      [Beschreibt REST, gRPC, Kafka, API Gateway, Service Mesh, Istio für Interface-Infrastruktur.],
      [REST/gRPC-Interfaces, Service Mesh],

      // Row 8
      [8],
      [Case Study on Data Communication in Microservice Architecture (Smid et al., 2019)],
      [Datenkommunikation via Kafka, Debezium, Redis; REST vs. Messaging.],
      [Daten-Interfaces, Messaging],
    ),
    caption: [Relevante Primärstudien (Kategorie A) für die SLR],
  ) <tab:ai_cat>
]

= Review Setup
== Used Screening Plattform: #mark(blue)[#link("https://www.zotero.org/")[Zotero]]

== Final Search String:

=== Search String for ACM and IEEE
#contentBox[
  ```yasm
  [[Abstract: microservice*] OR [Abstract: micro-service*] OR [Abstract: micro service*]]
  AND
  [[Abstract: monolith*] OR [Abstract: legacy system*] OR [Abstract: legacy software*] OR [Abstract: legacy application*]]
  AND
  [[Abstract: migrat*] OR [Abstract: decompos*] OR [Abstract: moderniz*] OR [Abstract: refactor*] OR [Abstract: transformation] OR [Abstract: reengineering]]
  AND
  [[All: service interface*] OR [All: service contract*] OR [All: api design] OR [All: api specification] OR [All: api contract*] OR [All: interface design] OR [All: interface specification] OR [All: interface selection] OR [All: endpoint design] OR [All: service boundar*] OR [All: communication pattern*]]
  ```
]
==== *Idea*
Microservice, Monolith and Migration in Abstract and Interfaces Aspects Full-Text Search

=== Search String for Springer
The Search String for Springer had to be slightly adapted, as no abstract search was possible
#contentBox[
  ```yasm
  (microservice* OR micro-service* OR "micro service" OR "micro services")
  AND
  (monolith* OR "legacy system" OR "legacy systems" OR "legacy software" OR " legacy softwares" OR "legacy  application" OR "legacy  applications")
  AND
  (migrat* OR decompos* OR moderniz* OR refactor* OR transformation OR reengineering)AND
  ("service interface" OR "service interfaces" OR "service contract" OR "service contracts" OR "api design" OR "api specification" OR "api  contract" OR "api  contracts" OR "interface design" OR "interface  specification" OR "interface selection" OR "endpoint design" OR "service boundary" OR "service boundaries" OR "communication pattern" OR "communication patterns")
  ```
]

== Results by used Searching Platform:
*Note:* Books were filtered out directly
#table(
  columns: (1fr, 1fr),
  [*Search Platform*], [*Results*],
  [#mark(blue)[#link("https://dl.acm.org/")[ACM - Digital Library]]],
  [89 results],
  [#mark(blue)[#link("https://ieeexplore.ieee.org/")[IEEE - Xplore]]],
  [99 results (without books)],
  [#mark(blue)[#link("https://link.springer.com/")[Springer]]],
  [83 results (without books)],
  [*All*],[271 results],
  [*Duplicates*],[1 result],
  [*Results entering Screening*],[270 results]
)

== Inclusion and Exclusion Criteria

=== Inclusion:
- #mark(green)[(IC1)] The paper speaks about microservice/monolith
- #mark(green)[(IC2)] The paper deals with migration
- #mark(green)[(IC3)] The paper speaks about interfaces or API

=== Exclusion:
- #mark(red)[(EC1)] The paper is not a book. #mark(gray)[_(How many?)_]
- #mark(red)[(EC2)] The paper does not provide an abstract.
- #mark(red)[(EC3)] The paper does not deal with migration of monoliths.
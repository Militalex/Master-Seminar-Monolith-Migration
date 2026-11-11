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
#contentBox[
  ```yasm
  [[All: microservice*] OR [All: monolith*]] AND [[All: interface*] OR [All: api*]] AND [[All: identif*] OR [All: extract*] OR [All: generat*] OR [All: decompos*]]
  ```
]
- 12,378 results
- most of the result do not cover migration

#contentBox[
  ```yasm
  [[All: microservice*] OR [All: monolith*]] AND [[All: interface*] OR [All: api*]] AND [[All: identif*] OR [All: extract*] OR [All: generat*] OR [All: decompos*]] AND [All: migrat*]
  ```
]
- 3,221 results

#contentBox[
  ```yasm
  [[All: microservice*] OR [All: monolith*]] AND [[Abstract: interface*] OR [Abstract: api*]] AND [[All: identif*] OR [All: extract*] OR [All: generat*] OR [All: decompos*]] AND [All: migrat*]
  ```
]
- 306 results

== Search on 05.10.2026 at ACM
#contentBox[
  ```yasm
  [[Abstract: microservice*] OR [Abstract: monolith*]] AND [[Abstract: interface*] OR [Abstract: api*]] AND [[All: identif*] OR [All: extract*] OR [All: generat*] OR [All: decompos*]] AND [[All: migrat*] OR [All: packaging]]
  ```
]
- 214 results

#contentBox[
  ```yasm
  [[Abstract: microservice*] OR [Abstract: monolith*]] AND [[Abstract: interface*] OR [Abstract: api*] OR [Abstract: migrat*] OR [Abstract: packag*]]
  ```
]
- 454 results

#contentBox[
  ```yasm
  [[Title: microservice*] OR [Title: monolith*]] AND [[Title: interface*] OR [Title: api*] OR [Title: migrat*] OR [Title: packag*]]
  ```
]
- 29 results

#contentBox[
  ```yasm
  [[All: "monolith*"] OR [All: "legacy system*"] OR [All: "monolithic application*"]] AND [[All: "microservice*"] OR [All: "micro-service*"] OR [All: "micro service*"]] AND [[All: "interface identification"] OR [All: "service interface*"] OR [All: "api identification"] OR [All: "interface extraction"] OR [All: "interface recovery"] OR [All: "service boundary*"]]
  ```
]
- 55 results

#contentBox[
  ```yasm
  [[All: "migration"] OR [All: "migrat*"] OR [All: "decomposition"] OR [All: "decompos*"] OR [All: "refactor*"] OR [All: "modernization"]]
  AND
  [[All: "monolith*"] OR [All: "legacy system*"]]
  AND
  [[All: "microservice*"] OR [All: "micro-service*"]] AND [[All: "service identification"] OR [All: "service interface*"] OR [All: "api*"] OR [All: "interface*"]]
  ```
]
- 226 results

== Searches after 07.10.2026 at ACM
*Idea:* Microservice, Monolith and Migration in Abstract and Interfaces Aspects Full-Text Search
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

== Concept of the Final Search Strings:
Combination of a precise abstract only search combined with more sensitiv abstract-fulltext search to find results which may not interface aspects in Abstract.

The generic Search String looks sth. like this:
#contentBox[
  ```yasm
  < Microservice Key Words>
  AND < Monolith Key Words >
  AND < Migration Key Words >
  AND < Interface Keywords >
  ```
]

The Microservice, Monolith and Migration Keywords will always searched within the abstract, as it is wished that the paper lies in the right context. The Interface aspects however are varied in Full-Text and Abstract-Only to combine a precise and sensitive search.

It shall also find Paper which do not focus about interfaces within the abstract, but might provide important information about it in later sections.

== Search String adjusted for ACM
- Two Search Arrays to search:
  - _The ACM Guide to Computing Literature_ including also results from other libraries, may not contain Full-Text, not applicable for Full-Text-Search
  - _The ACM Full-Text collection_ includes only sources with Full-Text, no books
=== Precise Abstract Search
#contentBox[
  ```yasm
  [[Abstract: microservice] OR [Abstract: micro-service] OR [Abstract: "micro service"] OR [Abstract: "micro services"]]
  AND
  [[Abstract: monolith*] OR [Abstract: legacy]]
  AND
  [[Abstract: migrat*] OR [Abstract: decompos*] OR [Abstract: moderniz*] OR [Abstract: refactor*] OR [Abstract: transformation] OR [Abstract: reengineering]] AND
  [[Abstract: interface] OR [Abstract: api] OR [Abstract: communication] OR [Abstract: contract] OR [Abstract: endpoint] OR [Abstract: boundary]]
  ```
]
- 82 results _(07.11.2026)_ in _The ACM Guide to Computing Literature_
- 83 results _(11.11.2026)_
  - 4 books

=== Sensitive Interface-Full-Text Search

==== *Idea* Microservice, Monolith andAND Migration in Abstract and Interfaces Aspects Full-Text Search

#contentBox[
  ```yasm
  [[Abstract: microservice] OR [Abstract: micro-service] OR [Abstract: "micro service"] OR [Abstract: "micro services"]]
  AND
  [[Abstract: monolith*] OR [Abstract: legacy]]
  AND
  [[Abstract: migrat*] OR [Abstract: decompos*] OR [Abstract: moderniz*] OR [Abstract: refactor*] OR [Abstract: transformation] OR [Abstract: reengineering]]
  AND
  [[All: interface] OR [All: api] OR [All: communication] OR [All: contract] OR [All: endpoint] OR [All: boundary]]
  ```
]
- 95 results _(07.11.2026)_ in _The ACM Full-Text collection_
  - no books as _The ACM Full-Text collection_ provide no book results

== Search Strings adjusted for IEEE
- *Limitation:* Only 10 Wildcards per query are allowed according to the UI, old documents may talk about a Limit of 5
- *Automatic Stemming:* microservice alone also search plural forms and etc...
- *"" allows for exact search:* No stemming
- *\*-Wildcard allowed in "":* Will again activate stemming, but was avoided because ACM does not allow it

=== Precise Abstract Search
#contentBox[
  ```yasm
  ("Abstract":microservice OR "Abstract":micro-service OR "Abstract":"micro service" OR "Abstract":"micro services")
  AND
  ("Abstract":monolith* OR "Abstract":legacy)
  AND
  ("Abstract":migrat* OR "Abstract":decompos* OR "Abstract": moderniz* OR "Abstract":refactor* OR "Abstract":transformation OR "Abstract":reengineering) AND
  ("Abstract":interface OR "Abstract":API OR "Abstract":communication OR "Abstract":contract OR "Abstract":endpoint OR "Abstract":boundary)
  ```
]
- 96 results _(07.11.2026)_
- 97 results _(11.11.2026)_
  - 7 books

=== Sensitive Interface-Full-Text Search
#contentBox[
  ```yasm
  ("Abstract":microservice OR "Abstract":micro-service OR "Abstract":"micro service" OR "Abstract":"micro services")
  AND
  ("Abstract":monolith* OR "Abstract":legacy) AND ("Abstract":migrat* OR "Abstract":decompos* OR "Abstract": moderniz* OR "Abstract":refactor* OR "Abstract":transformation OR "Abstract":reengineering)
  AND
  ("All Metadata":interface OR "All Metadata":API OR "All Metadata":communication OR "All Metadata":contract OR "All Metadata":endpoint OR "All Metadata":boundary)
  ```
]
- 163 results _(07.11.2026)_
- 164 results _(11.11.2026)_
  - 12 books

== Search String for Springer
The Search String for Springer had to be adapted, as no abstract search was possible and everything was searched Full-Text. For this purpose an additional Title Condition and Filters were applied.
#contentBox[
  *Search String:*
  ```yasm
  (microservice OR micro-service OR "micro service" OR "micro services")
  AND
  (monolith* OR "legacy system" OR "legacy systems" OR "legacy software" OR " legacy softwares" OR "legacy  application" OR "legacy  applications")
  AND
  (migrat* OR decompos* OR moderniz* OR refactor* OR transformation OR reengineering)
  AND
  ("service interface" OR "service interfaces" OR "service contract" OR "service contracts" OR "api design" OR "api specification" OR "api  contract" OR "api  contracts" OR "interface design" OR "interface specification" OR "interface selection" OR "endpoint design" OR "service boundary" OR "service boundaries" OR "communication pattern" OR "communication patterns")
  ```
  *Title Condition:*
  ```yasm
  (microservice OR micro-service OR "micro service" OR "micro services" OR monolith* OR legacy OR migrat* OR decompos* OR moderniz* OR refactor* OR transformation OR reengineering OR interface OR API OR communication OR boundary)
  ```
  *Filter:*
  - *Disciplines:*
    - Computer science
  - *Subdisciplines:*
    - Software engineering/programming and operating systems
    - Software engineering, Computer communication networks
    - Computer applications
    - Computer science, general
    - Information systems applications (incl. internet)
    - Computer systems organization and communication networks
    - It in business
    - Computer system implementation
]
- 170 results _(07.11.2026)_
  - 1 book

== Results by used Searching Platform:

#figure(
  //placement: bottom,
  //scope: "parent",
  table(
    columns: (2.5cm, 1.2fr, 1.2fr, 1.2fr, auto),
    align: center + horizon,
    [*Search Platform*], [*Results: Abstract Search*],[*Results: Full-Text Search*], [*Duplicates within platform*],[*Final*],
    [#mark(blue)[#link("https://dl.acm.org/")[ACM - Digital Library]]],[83],[95],[34],[144],
    [#mark(blue)[#link("https://ieeexplore.ieee.org/")[IEEE - Xplore]]],[97],[164],[97],[164],
    [*All*],[180],[259],[131],[308],
    [*Duplicates Between platforms*],[/],[/],[/],[6],
    [*Results entering Screening*],[/],[/],[/],[302]
  ),
  caption: [Search results are from 11.11.2026]
)

== Inclusion and Exclusion Criteria

=== Inclusion:
- #mark(green)[(IC1)] The paper speaks about interfaces within a migration context.

=== Exclusion:
- #mark(red)[(EC1)] The search result is not a whole book.
- #mark(red)[(EC2)] The paper does not deal with migration of monoliths.
#import "../00 assets/preamble.typ": *

#show: template-setup.with(
  doc-title: [SLR-Protocol],
  bib-style: "apa"
)

= Theme
The topic of this _Systematic-Literature Review (SLR)_ is: #quote(block: true)[
  "_Interface Design after Monolith Decomposition during the Migration to Microservices_"
]

= Research Questions
#[
  #set enum(numbering: "RQ1")
  + Which methods and procedures exist for defining service interfaces after the service identification phase in the migration from monoliths to microservices?
    - How are they implemented?
    - Ho mature are they?
  + Which types, patterns amd metrics are used in the examined methods and procedures?
  + How are the methods and procedures evaluated?
]

= Literature Search

== Search on 02.10.2026 at ACM
=== `[[All: microservice*] OR [All: monolith*]] AND [[All: interface*] OR [All: api*]] AND [[All: identif*] OR [All: extract*] OR [All: generat*] OR [All: decompos*]]`
- found 12,378 results
- most of the result do not cover migration

=== `[[All: microservice*] OR [All: monolith*]] AND [[All: interface*] OR [All: api*]] AND [[All: identif*] OR [All: extract*] OR [All: generat*] OR [All: decompos*]] AND [All: migrat*]`
- found 3,221 results

=== `[[All: microservice*] OR [All: monolith*]] AND [[Abstract: interface*] OR [Abstract: api*]] AND [[All: identif*] OR [All: extract*] OR [All: generat*] OR [All: decompos*]] AND [All: migrat*]`
- found 306 results

== Search on 05.10.2026 at ACM
=== `[[Abstract: microservice*] OR [Abstract: monolith*]] AND [[Abstract: interface*] OR [Abstract: api*]] AND [[All: identif*] OR [All: extract*] OR [All: generat*] OR [All: decompos*]] AND [[All: migrat*] OR [All: packaging]]`
- 214 results

=== `[[Abstract: microservice*] OR [Abstract: monolith*]] AND [[Abstract: interface*] OR [Abstract: api*] OR [Abstract: migrat*] OR [Abstract: packag*]]`
- 454 results

=== `[[Title: microservice*] OR [Title: monolith*]] AND [[Title: interface*] OR [Title: api*] OR [Title: migrat*] OR [Title: packag*]]`
- 29 results

=== `[[All: "monolith*"] OR [All: "legacy system*"] OR [All: "monolithic application*"]] AND [[All: "microservice*"] OR [All: "micro-service*"] OR [All: "micro service*"]] AND [[All: "interface identification"] OR [All: "service interface*"] OR [All: "api identification"] OR [All: "interface extraction"] OR [All: "interface recovery"] OR [All: "service boundary*"]]`
- 55 results

=== `[[All: "migration"] OR [All: "migrat*"] OR [All: "decomposition"] OR [All: "decompos*"] OR [All: "refactor*"] OR [All: "modernization"]] AND [[All: "monolith*"] OR [All: "legacy system*"]] AND [[All: "microservice*"] OR [All: "micro-service*"]] AND [[All: "service identification"] OR [All: "service interface*"] OR [All: "api*"] OR [All: "interface*"]]`
- 226 results

== Search on 07.10.2026 at ACM
=== `[[Abstract: microservice*] OR [Abstract: micro-service*] OR [Abstract: micro service*]] AND [[Abstract: migrat*] OR [Abstract: decompos*] OR [Abstract: moderniz*] OR [Abstract: refactor*] OR [Abstract: transformation] OR [Abstract: reengineering]] AND [[All: service interface*] OR [All: service contract*] OR [All: api design] OR [All: api specification] OR [All: api contract*] OR [All: interface design] OR [All: interface specification] OR [All: interface selection] OR [All: endpoint design] OR [All: service boundar*] OR [All: communication pattern*]] AND [[Abstract: monolith*] OR [Abstract: legacy system*] OR [Abstract: legacy software*] OR [Abstract: legacy application*]]`
- 85 results
- 89 results (28.10.2026)

=== AI Categorized Papers from the first 20
#set page(paper: "a4", margin: 1.5cm)
#set text(size: 9pt, lang: "de")
#set par(justify: false, leading: 0.55em)

#figure(
  placement: auto,
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
)

= Inclusion and Exclusion Criteria

== Inclusion:
- paper speaks about microservice/monolith
- paper deal with migration
- paper speaks about the interface or API

== Exclusion:
- paper does not deal with migration of monoliths
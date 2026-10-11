#import "/00 assets/preamble.typ": *

#show: template-setup.with(
  doc-title: [Specification: Interface Design after Monolith Decomposition during the Migration to Microservices],
)

= Context and Motivation
// _Was ist die Motivation für Ihr Thema und in welchem Kontext hat das Thema Relevanz?_

In software engineering for business applications, the resulting software products are traditionally built as a single deployable unit. This kind of software organization is called a _monolithical architecture_. @lewis2014Microservices @abgaz2023Decomposition

Enterprise applications often consist of the following three parts @lewis2014Microservices:
+ User Interface (UI)
+ Business Logic Layer (BL)
+ Database (DB)

As software is traditionally organized and split around these technical layers the teams maintaining the software are split likewise in the same manner according to these layers leading to "UI Teams", "BL Teams" and "DB Teams". On the left side of @fig:monolith_vs_microservices, there is an example of a monolith. @lewis2014Microservices

Whenever the software has to be adapted all teams may be involved even if the changes are small. According to Conway's Law which is quoted in @quote:conways_law, the communication structure of software teams tends to become mirrored in the software product itself.

#figure(
  box(stroke: 1pt, inset: 1em, radius: 1em, fill: color.lighten(silver, 50%))[
    "Any organization that designs a system (defined broadly) will produce a design whose structure is a copy of the organization's communication structure."
  ],
  kind: "quote",
  supplement: [Quote],
  caption: [Conway's Law quoted by Melvin Conway, 1968 @lewis2014Microservices]
) <quote:conways_law>

#figure(
  [
    #grid(
      columns: (1fr, 0.775fr),
      gutter: 1em,
      [
        #set align(center)
        #image("/00 assets/figures/Monolith.jpg", width: 80%)
        (a) Monolithical Architecture
      ],
      [
        #set align(center)
        #image("/00 assets/figures/Microservices.jpg", width: 80%)
        (b) Microservice Architecture
      ]
    )
    #v(1em)
  ],
  placement: bottom,
  scope: "parent",
  caption: [Difference between a _Monolithical Architecture_ _(left)_ and a _Microservice Architecture_ _(right)_. Original illustration by #citeauthor(<nockemann2025DomainDriven>).]
) <fig:monolith_vs_microservices>

As consequence of Conway's law, when monoliths grow larger and more complex, they often result in software products which are _highly coupled_ and _less cohesive_. _High coupling_  means that internal software components generally have many dependencies on other components. _Low cohesion_ means that a component does not have a single responsibility and might be responsible for several things. In order words, the software logic is scattered all over the software product. @lewis2014Microservices @abgaz2023Decomposition

Therefore, when a monolith grows large, desired qualities such as _scalability_, _maintainability_ and _deployability_ suffer.

The _microservice architecture_, on the other hand, focuses on addressing the above mentioned downsides of monoliths. As illustrated on the the right side of figure @fig:monolith_vs_microservices, microservices favor decomposing systems into several, relatively small components which are organized around business capabilities. Each component is implemented as a single deployable unit and can be maintained and scaled individually. @lewis2014Microservices @abgaz2023Decomposition

/*#note[
== Monolith
- traditionally software is built as one single deployable unit which is called a monolith @lewis2014Microservices @abgaz2023Decomposition
- Enterprise Applications are often made of three main parts: @lewis2014Microservices
  - User Interface (UI)
  - Business Logic (BL)
  - Daabase (DB)
- Software is traditionally split around these layers leading to UI Teams, Business-Logic Teams and Database Teams @lewis2014Microservices
- whenever the software changes all teams might be involved @lewis2014Microservices
- according to Conway's Law the team communication structures become mirrored in the software product itself @lewis2014Microservices
- as software systems grow large and become complex the above presented organisation of software is resulting in highly coupled meaning there are many dependencies to other parts of the software but less cohesive components meaning the module ave not a single responsibility but is responsable for several things @abgaz2023Decomposition
- when this kind of software architecture grow large  desired features like scalability, maintenance and deployability suffers @abgaz2023Decomposition

== Microservices
- the microservice architecture instead is focusing on splitting the software around business capabilities @lewis2014Microservices
  - they favor the decomposition of systems into various relatively small and independent components which can be maintained, scaled and deployed individually @abgaz2023Decomposition

== Migration
- companies having invested in a monolithtic architectures might consider to migrate to microservices @abgaz2023Decomposition
- however migrating to microservices is a resource intensive task involving the identification of service boundaries and packaging them into self-contained microservices with defined API's @trabelsi2025Systematic

]
*/

= Research Problem and Research Questions
// _Was genau ist Ihre Problemstellung? Welche Fragestelllungen behandeln Sie in Ihrer Arbeit?_

Companies that have invested in a monolith might consider migrating and decompose their software into microservices @abgaz2023Decomposition. However, migrating to microservices is a resource-intensive task involving the identification of service boundaries within the monolith and the packaging of identified candidates into self-contained microservices with a defined API @trabelsi2025Systematic.

The authors #citeauthor(<trabelsi2025Systematic>) acknowledge that some phases such as the identification of services within a monolith and its decomposition have been extensively studied whereas other phases like the packaging of microservices and generating necessary code for interfaces and APIs are less intensively studied. @trabelsi2025Systematic

A first literature review has so far found and analyzed the _systematic literature reviews (SLRs)_ presented in @table:research at different levels. Even though the SLR literature might provide some information about the packaging phase, interfaces and API's, it does not focus on them and only touches on these aspects in passing.

Further AI-guided research indicates that no further SLR exists that only focuses on service interfaces and API's after the service identification phase of the migration. Often research might only shortly mention some desired aspects about interfaces but either without a migration background or with a focus on service deployment.

Therefore, this work seeks to conduct a _systematic literature review (SLR)_ to shed light on the above-described gap seeking how far research got and finding existing approaches in regard of interface design after the service decomposition step as this is an important step in the migration process. The SLR is trying to answer the following questions:
#[
  #set enum(numbering: "RQ1")
  + Which methods and procedures exist for defining service interfaces after the service identification phase in the migration from monoliths to microservices?
    - How are they implemented?
    - Ho mature are they?
  + Which types, patterns amd metrics are used in the examined methods and procedures?
  + How are the methods and procedures evaluated?
]

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: horizon,
    [*Author*],[*Title*],[*Year*],[*Depth of\ Analysis*],[*Focus*],
    [#citeauthor(<trabelsi2025Systematic>)],[A Systematic Literature Review of Machine Learning Approaches for Migrating Monolithic Systems to Microservices],[2025],[First Pass],[Understand how Machine Learning approaches are used during the Migration from Monoliths to Microservices],
    [#citeauthor(<abgaz2023Decomposition>)],[Decomposition of Monolith Applications Into Microservices Architectures: A Systematic Review],[2023],[First Pass],[Aim to give an overview about the field of Monolith Decomposition. Seeking to give an interrelated picture of various decomposition techniques, benchmarks and metrics.],
    [#citeauthor(<abdellatif2021taxonomy>)],[A taxonomy of service identification approaches for legacy software systems modernization],[2021],[Second Pass],[Seeks to give an overview and creates an taxonomy of existing service identification approaches during the migration.],
    [#citeauthor(<velepucha2021Monoliths>)],[Monoliths to microservices - Migration Problems and Challenges: A SMS],[2021],[Mentioned by\ other research like @trabelsi2025Systematic],[Identification of the problems and challenges associated with the microservice migration.]
  ),
  placement: bottom,
  scope: "parent",
  caption: [The table present the so far analyzed _systematic literature reviews (SLRs)_ on different analysis levels. _First Pass_ means that at least Abstract and Introduction was read and _Second Pass_ means that more than Abstract and Introduction was read such as Conclusion, Discussion, Results or Methods. _Third Pass_ means the Paper was read completely.]
) <table:research>

/*#note[
  - The authors #citeauthor(<trabelsi2025Systematic>) acknowledge that some phases such as Service Identification which is also called service decomposition are extensively studied while some other phases like Packaging Microservices and generating necessary code for microservice API is less well studied @trabelsi2025Systematic
  - a first ai guided literature review shows that so far no existing SLR exists which focus on service interfaces / API after the service identification migration phase. Some literature might only shortly mention some desired aspects like API's without the migration background or dealing with Packaging Phase and deploying without dedicated focus on service interfaces
  - the authors #citeauthor(<trabelsi2025Systematic>) focus on Machine Learning approaches during the migration phase
  - the authors #citeauthor(<abgaz2023Decomposition>) seek to give a general overview about the field of Monolith Decomposition without a special focus on interfaces
  - the authors #citeauthor(<abdellatif2021taxonomy>) focus to create a taxonomy of different Service-Identification methods without a focus on the interfaces
  - an SLR with dedicated focus on service interfaces after the service identification seems in the migration to be missing
  - this work is seeking to enlight that gap and seek to present how far research got in regard to interface design after the service decomposition step as it is important phase in the migration process
  - focus on the following questions:
    - Which methods and procedures does exist to define and implement service interfaces after the Service-Identifikation phase in the migration from Monoliths to Microservices?
      - How mature are there?
    - Which types, patterns amd metrics are used in the examined methods and procedures?
    - How does the methods and procedures are evaluated?
]*/

= Methodology and Planned Procedures
//_Wie gehen Sie bei der Erstellung der Ergebnisse vor (Arbeitsschritte) und welche Methodik praktizieren Sie dabei?_

To examine the above-presented research questions and gain an initial overview of the answers, an iterative, AI-guided #footnote[I used #link("https://www.deepseek.com/en/")[DeepSeek AI] for all AI-related tasks] creation of search strings was performed to get an overview of the research landscape and to restrict the literature results to the desired topic. The AI was especially useful during the creation of the search strings as it could supply the search string with many alternative keywords, since the researched topic seems to encompass many different kinds of keywords.

The final search string presented in @quote:search_string follows the core idea of first searching the abstracts of papers for Monolith, Microservice and Migration keywords and secondly applying a filter using a full-text search for interface aspects.

The presented search string yielded 85 search results on October 7, 2026. To get an initial impression of the amount of primary studies dealing with interface aspects, an AI-guided categorization was performed.

#figure(
  box(stroke: 1pt, inset: 1em, radius: 1em, fill: color.lighten(silver, 50%))[
    `[[Abstract: monolith*] OR [Abstract: legacy system*] OR [Abstract: legacy software*] OR [Abstract: legacy application*]]
    AND
    [[Abstract: microservice*] OR [Abstract: micro-service*] OR [Abstract: micro service*]]
    AND
    [[Abstract: migrat*] OR [Abstract: decompos*] OR [Abstract: moderniz*] OR [Abstract: refactor*] OR [Abstract: transformation] OR [Abstract: reengineering]]
    AND
    [[All: service interface*] OR [All: service contract*] OR [All: api design] OR [All: api specification] OR [All: api contract*] OR [All: interface design] OR [All: interface specification] OR [All: interface selection] OR [All: endpoint design] OR [All: service boundar*] OR [All: communication pattern*]]`
  ],
  kind: "quote",
  supplement: [Quote],
  caption: [Final Search-String of the iteration procedure.]
) <quote:search_string>

The AI categorized 25 of the 85 papers as primary studies that directly address interface aspects and a further 28 as borderline cases that cover interface aspects only in passing.

To sum up, at first glance there might be enough literature for an SLR. The next steps would include obtaining a more detailed view of (SLR-)literature focusing on the migration phases after the decomposition step. Based on the insights, the search string might be adapted.

In general, this work plans to follow the SLR-procedure proposed by #citeauthor(<kitchenham2009Systematic>).

#heading(numbering: none)[Acknowledgement]
During the work #link("https://www.deepseek.com/en/")[DeepSeek AI] was used to guide the literature review, create search strings and categorize the first 85 results to get first insights.
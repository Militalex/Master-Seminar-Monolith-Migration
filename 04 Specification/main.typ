#import "/00 assets/preamble.typ": *

#show: template-setup.with(
  doc-title: [Specification: Identification of service interfaces during the migration from monoliths to microservices],
)

= Context and Motivation
// _Was ist die Motivation für Ihr Thema und in welchem Kontext hat das Thema Relevanz?_

In Software Engineering of business applications resulting software products are traditionally built as one single deployable unit. This kind of software organization is called a _Monolithical Architecture_. @lewis2014Microservices @abgaz2023Decomposition

Enterprise Applications are often made of the three following parts @lewis2014Microservices:
+ User Interface (UI)
+ Business Logic Layer (BL)
+ Database (DB)

As software is traditionally organized and split around these technical layers the team maintaining the software is split likewise according these layers leading to "UI Teams", "BL Teams" and "DB Teams". Figure @fig:monolith_vs_microservices provides on the left an illustrations of a Monolithical Architecture. @lewis2014Microservices

Whenever the software has to be adapted all teams might be involved even when the changes might be small. According to Conway's Law which is quoted in @quote:conways_law the communication structure of software team will become mirrored in the software product itself.

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
  caption: [Difference between a _Monolithical Architecture_ _(left)_ and a _Microservice Architecture_ _(right)_. Orifinal illustration by #citeauthor(<nockemann2025DomainDriven>).]
) <fig:monolith_vs_microservices>

As software systems grow large and becomes more and more complex the above presented Monolithical Architectures is resulting according Conway's Law into a software product which is _highly coupled_ and _less cohesive_. _Highly coupled_ means that the software product has many dependecies to other parts of the software and _less cohesive_ means that one component not have a single responsibility and might be responsable for several things. In order words the software logic is scattered all over the system. @lewis2014Microservices @abgaz2023Decomposition

Therefore when a monolith grow large desired features like _scalability_, _maintenance_ and _deployability_ suffers.

The _Microservice Architecture_ on the other hand focus to address the above mentioned downsides of monoliths. As illustrated in figure @fig:monolith_vs_microservices on the right, Microservices favor to decompose systems into several, relatively small components which are organized around business capabilities. These components can be maintained, scaled and deployed individually. @lewis2014Microservices @abgaz2023Decomposition

Therefore, companies who have invested in a monolithical architecture might consider to migrate and decompose their software into microservices @abgaz2023Decomposition. However, migrating to microservices is a resource intensive task involving identification of service boundaries within the monolith and package found candidates into self-contained microservices with a defined API @trabelsi2025Systematic.

#note[
/*
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
*/

== Migration
- companies having invested in a monolithtic architectures might consider to migrate to microservices @abgaz2023Decomposition
- however migrating to microservices is a resource intensive task involving the identification of service boundaries and packaging them into self-contained microservices with defined API's @trabelsi2025Systematic

]

= Probleme / Fragestellungen
_Was genau ist Ihre Problemstellung? Welche Fragestelllungen behandeln Sie in Ihrer Arbeit?_
#note[
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
]

= Methodisches Vorgehen zur Zielerreichung
_Wie gehen Sie bei der Erstellung der Ergebnisse vor (Arbeitsschritte) und welche Methodik praktizieren Sie dabei?_
#note[

]

= Ziele und angestrebte Ergebnisse
_Welche Ziele verfolgen Sie mit der Beantwortung der behandelten Fragen und welche  wesentlichen Ergebnisse entstehen dabei?_
#note[
  - Developing a more detailed view over dedicated SLR's
]

= Wissenschaftlicher Beitrag
_Welchen Beitrag zur Bewältigung der Problemstellung leistet Ihre Arbeit? Welche neuen Erkenntnisse können Lesende Ihrer Arbeit erwarten?_
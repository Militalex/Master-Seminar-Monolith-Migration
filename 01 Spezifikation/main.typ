#import "@preview/charged-ieee:0.1.4": ieee

// Verringert den vertikalen Abstand für alle Block-Zitate
#show quote.where(block: true): set block(
  above: 1em,
  below: 1em,
)

#let citeauthor(cite-label) = cite(cite-label, form: "prose")

#show: ieee.with(
  title: [Specification: Strategies for the automated identification of service interfaces during the migration from monoliths to microservices],
  authors: (
    (
      name: "Alexander Ley",
      department: [Computer Science Department],
      organization: [University of applied science Bonn-Rhein-Sieg],
      location: [Sankt Augustin, Germany],
      email: "s6alleyy@outlook.de"
    ),
  ),
  index-terms: (),
  bibliography: bibliography("refs.bib", style: "ieee"),
  figure-supplement: [Fig.],
)

= Context and Motivation
// _Was ist die Motivation für Ihr Thema und in welchem Kontext hat das Thema Relevanz?_
In Software Engineering of business applications, the architecture and organization of software components are playing a pivotal rule to enable desired features like _scalability_, _maintainability_ and _deployability_.

As software systems become more and more complex these featured are more and more less achieved due to the predominant implementation of _Monolithical Architectures_ @abgaz2023Decomposition.

== Monolithical Architectures
Traditionally, teams in Software Engineering of business applications are divided along technical capabilities.

According to Conway's Law, which is quoted in @quote:conways_law, the technically oriented team decomposition yields to the technically oriented decomposition of the software output, which is illustrated in figure @fig:monolith.

#figure(
  box(stroke: 1pt, inset: 1em, radius: 1em, fill: color.silver)[
    "Any organization that designs a system (defined broadly) will produce a design whose structure is a copy of the organization's communication structure."
  ],
  kind: "quote",
  supplement: [Quote],
  caption: [Conway's Law quoted by Melvin Conway, 1968 @lewis2014Microservices]
) <quote:conways_law>

_Monolithtical Architectures_ decompose the software according horizontal and technical oriented layers. Between these layers are often lots of dependencies resulting in a loss of flexibility whenever the software have to be adapted hindering agile software development and maintenance.

As illustrated in figure @fig:monolith_and_microservices monoliths are traditionally built as a single unit which can only be deployed and scaled as whole. Therefore the deployability and scalability using a Monolithical Architecture is limited. @abgaz2023Decomposition

As the requirements towards the software are evolving there is need for software to be locally, flexible, adaptable and deployable without influencing other parts of software.

#figure(
  image("assets/Monolith.jpg", width: 90%),
  caption: [Illustration of a business application built as a monolith. Original illustration from #citeauthor(<nockemann2025DomainDriven>).]
) <fig:monolith>

== Microservice Architecture
Due to the downsides of Monolithtical Architectures researchers has reached out to other software paradigm @daoud2020Automatic.

_Microservice Architectures_ seeks to overcome the shortcomings of monoliths and have therefore gained significant attraction @garriga2018Taxonomy. The core idea behind this novel kind of software organization is to decompose the software vertically along the enterprise business capabilities as illustrated in @fig:microservices.

#citeauthor(<lewis2014Microservices>) described the _Microservice Architecture_ as follows: #quote(block: true)[
  "The microservice architectural style is an approach to developing a single application as a suite of small services, each running in its own process and communicating with lightweight mechanisms, often an HTTP resource API [today often a RESTful API @garriga2018Taxonomy]. These services are built around business capabilities and independently deployable by fully automated deployment machinery. There is a bare minimum of centralized management of these services, which may be written in different programming languages and use different data storage technologies."
]

Microservices are typically build in a way that they encapsulate one single business capability as shown in @fig:microservices which can encompass an own database, own User-Interface (UI) and business logic seeking of being as independent as possible to other Microservices. Therefore they can be maintained, adapted and deployed individually which satisfy more companies desire for agile software development.

#figure(
  image("assets/Microservices.jpg", width: 80%),
  caption: [Illustration of a business application built as microservices. Original illustration from #citeauthor(<nockemann2025DomainDriven>).]
) <fig:microservices>

#figure(
    image("assets/Monoliths vs. Microservices.png", width: 75%),
    placement: bottom,
    scope: "parent",
    caption: [Scaling and deploying of Monoliths and Microservices by #citeauthor(<lewis2014Microservices>)]
) <fig:monolith_and_microservices>

= Probleme / Fragestellungen
_Was genau ist Ihre Problemstellung? Welche Fragestelllungen behandeln Sie in Ihrer Arbeit?_

= Methodisches Vorgehen zur Zielerreichung
_Wie gehen Sie bei der Erstellung der Ergebnisse vor (Arbeitsschritte) und welche Methodik praktizieren Sie dabei?_

= Ziele und angestrebte Ergebnisse
_Welche Ziele verfolgen Sie mit der Beantwortung der behandelten Fragen und welche  wesentlichen Ergebnisse entstehen dabei?_

= Wissenschaftlicher Beitrag
_Welchen Beitrag zur Bewältigung der Problemstellung leistet Ihre Arbeit? Welche neuen Erkenntnisse können Lesende Ihrer Arbeit erwarten?_
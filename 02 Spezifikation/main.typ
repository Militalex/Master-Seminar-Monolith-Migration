#import "../00 assets/preamble.typ": *

#show: template-setup.with(
  doc-title: [Specification: Strategies for the automated identification of service interfaces during the migration from monoliths to microservices],
)

= Context and Motivation
// _Was ist die Motivation für Ihr Thema und in welchem Kontext hat das Thema Relevanz?_
In Software Engineering of business applications, the architecture and organization of software components are playing a pivotal rule to enable desired features like _scalability_, _maintainability_ and _deployability_.

As software become more and more complex these featured are more and more less achieved due to the predominant implementation of _Monolithical Architectures_ @abgaz2023Decomposition.

== Monolithical Architectures
_Monolithtical Architectures_ decompose the software according horizontal and technical oriented layers, which is illustrated in @fig:monolith. Between these layers are often lots of dependencies resulting in a loss of flexibility whenever the software have to be adapted hindering _agile software development_ and _maintenance_. #todo[Quelle?]

Monoliths are traditionally built as a single unit which can only be deployed and scaled as whole. Therefore the deployability and scalability using a Monolithical Architecture is limited. @abgaz2023Decomposition

As the requirements towards the software are evolving there is need for software to be flexible, adaptable and deployable without influencing other parts of the software.

#figure(
  image("../00 assets/figures/Monolith.jpg", width: 90%),
  caption: [Illustration of a business application built as a monolith. Original illustration from #citeauthor(<nockemann2025DomainDriven>).]
) <fig:monolith>

== Microservice Architecture
Due to the downsides of Monolithtical Architectures, researchers has reached out to other software paradigms @daoud2020Automatic.

_Microservice Architectures_ seeks to overcome the shortcomings of monoliths and have therefore gained significant attraction @garriga2018Taxonomy. The core idea behind this novel kind of software organization is to decompose the software vertically along enterprise business capabilities as illustrated in @fig:microservices.

#figure(
  image("../00 assets/figures/Microservices.jpg", width: 80%),
  caption: [Illustration of a business application built as microservices. Original illustration from #citeauthor(<nockemann2025DomainDriven>).]
) <fig:microservices>

#citeauthor(<lewis2014Microservices>) described the _Microservice Architecture_ as follows: #quote(block: true)[
  "The microservice architectural style is an approach to developing a single application as a suite of small services, each running in its own process and communicating with lightweight mechanisms, often an HTTP resource API [today often a RESTful API @garriga2018Taxonomy]. These services are built around business capabilities and independently deployable by fully automated deployment machinery. There is a bare minimum of centralized management of these services, which may be written in different programming languages and use different data storage technologies."
]

Microservices are typically build in a way that they encapsulate one single business capability which can encompass:

+ User-Interface (UI) technology
+ Business logic
+ Database technology

Microservices seek to be as independent as possible by trying to minimize dependencies on other services. Therefore they can be maintained, adapted and deployed individually which satisfy more adequate companies desire for agile software development. #todo[Quelle?]

#note[
  == Migration
  - companies which have invented monolithical architectures may consider to migrate to a Microservice Architecture
  - to perform that they have to decompose their monolithical application into smaller services
  - decomposing a software into smaller parts have always been a challenge in software engineering @gysel2016Service

  === Domain-Driven Design (DDD)
  - let migration engineer analyse and identify application's domain using techniques like _Domain-Driven Design (DDD)_ to obtain service boundaries @abgaz2023Decomposition @gysel2016Service
  - DDD is a collection of abstract concepts helping to model complex and large software with respect to the domain @nockemann2025DomainDriven #todo[In Seminararbeit DDD genauer erklären und hier nur kurz]
]

= Probleme / Fragestellungen
_Was genau ist Ihre Problemstellung? Welche Fragestelllungen behandeln Sie in Ihrer Arbeit?_

= Methodisches Vorgehen zur Zielerreichung
_Wie gehen Sie bei der Erstellung der Ergebnisse vor (Arbeitsschritte) und welche Methodik praktizieren Sie dabei?_

= Ziele und angestrebte Ergebnisse
_Welche Ziele verfolgen Sie mit der Beantwortung der behandelten Fragen und welche  wesentlichen Ergebnisse entstehen dabei?_

= Wissenschaftlicher Beitrag
_Welchen Beitrag zur Bewältigung der Problemstellung leistet Ihre Arbeit? Welche neuen Erkenntnisse können Lesende Ihrer Arbeit erwarten?_
#import "../00 assets/preamble.typ": *

#show: template-setup.with(
  doc-title: [Monolith and Microservices],
  bib-style: "apa"
)

= Definiton @lewis2014Microservices

== Monoliths
- *Enterprise Applications often consists of three main parts:*
  - User Interface (UI)
  - Server-side application
  - Database (DB)
- *Monoliths are built as one single deployable unit*
  - all logic for handling a request runs just in a single process
  - any (even small) changes involve building and deploying a new version of the entire application
  - people are facing frustrations with monoliths as applications are more deployed to the cloud
- *Monoliths are horizontally scalable* by deploying multiple instances of the monolith itself rather scaling of single parts of the monolith is not possible
- *Monoliths struggle over time to maintain a good modular structure*
  - using just the provided features of the used programming language to divide and structure the application
  - hard to keep changes being only limited to one module/place in code
    - often affects many places in the code

== Microservices
- The authors #citeauthor(<lewis2014Microservices>) proposed the following description: @lewis2014Microservices #quote(block: true)[
  _"The microservice architectural style is an approach to developing a single application as a suite of small services, each running in its own process and communicating with lightweight mechanisms, often an HTTP resource API [today often a RESTful API @garriga2018Taxonomy]. These services are built around business capabilities and independently deployable by fully automated deployment machinery. There is a bare minimum of centralized management of these services, which may be written in different programming languages and use different data storage technologies."_
]
  - seeks to build applications as suites of services
  - services seek to be independently deployable and therefore scalable
    - Microservice adds an opportunity for more granular release planning
    - Can speed up release process
  - each service may use different programming languages and technology stacks to fit their central business capability the best

#figure(
  image("/00 assets/figures/Monoliths vs. Microservices.png", width: 75%),
  caption: [Difference in scaling of monoliths and microservices. @lewis2014Microservices],
  placement: auto,
  scope: "parent"
)

= Team Management @lewis2014Microservices
#quote(block: true, attribution: [Conways Law])[_"Any organization that designs a system (defined broadly) will produce a design whose structure is a copy of the organization's communication structure."_]
  - this means the decomposition of teams and their communication structure will become mirrored in the resulting software architecture
- *Splitting around technical Layers:* Management often focus
  to split large application according technology layer leading to UI Teams, Server-Side-Logic Teams and Database Teams
  - even simple changes can result in a multi-team project resulting in scattered logic
- *Splitting around business capabilities:* when teams become
  decomposed around business capabilities where each team include the full range of skills (From UI specialists to DB specialists) allowing them to use the full software stack (UI, BL and DB) this will result according Conway's Law in a software which is as well organized around business capabilities
  - explicit separation which is enforced due to the usage of service components make its easier to keep team responsibilities boundaries clear

#note[
  In Software Engineering of business applications, the architecture and organization of software components are playing a pivotal rule to enable desired features like _scalability_, _maintainability_ and _deployability_.

As software become more and more complex these features are more and more less achieved due to the predominant implementation of _Monolithical Architectures_ @abgaz2023Decomposition.

== Monolithical Architectures
_Monolithtical Architectures_ decompose the software according horizontal and technical oriented layers, which is illustrated in @fig:monolith. Between these layers are often lots of dependencies resulting in a loss of flexibility whenever the software have to be adapted hindering _deployability_ and _maintenance_. @lewis2014Microservices

Monoliths are traditionally built as a single unit which can only be deployed and scaled as single unit. Therefore the deployability and scalability using a Monolithical Architecture is limited. @abgaz2023Decomposition
#todo[Letzten beiden Abschnitte anpassen]

As the requirements towards the software are evolving there is need for software to be flexible, adaptable and deployable without influencing other parts of the software.

#figure(
  image("/00 assets/figures/Monolith.jpg", width: 90%),
  caption: [Illustration of a business application built as a monolith. Original illustration from #citeauthor(<nockemann2025DomainDriven>).]
) <fig:monolith>

== Microservice Architecture
Due to the downsides of Monolithtical Architectures, researchers has reached out to other software paradigms @daoud2020Automatic.

_Microservice Architectures_ seeks to overcome the shortcomings of monoliths and have therefore gained significant attraction @garriga2018Taxonomy @abgaz2023Decomposition. The core idea behind this novel kind of software organization is to decompose the software vertically along enterprise business capabilities as illustrated in @fig:microservices.

#figure(
  image("/00 assets/figures/Microservices.jpg", width: 80%),
  caption: [Illustration of a business application built as microservices. Original illustration from #citeauthor(<nockemann2025DomainDriven>).]
) <fig:microservices>

#citeauthor(<lewis2014Microservices>) described the _Microservice Architecture_ as follows: #quote(block: true)[
  "The microservice architectural style is an approach to developing a single application as a suite of small services, each running in its own process and communicating with lightweight mechanisms, often an HTTP resource API [today often a RESTful API @garriga2018Taxonomy]. These services are built around business capabilities and independently deployable by fully automated deployment machinery. There is a bare minimum of centralized management of these services, which may be written in different programming languages and use different data storage technologies."
]

Microservices are typically build in a way that they encapsulate one single business capability which can encompass:

+ User-Interface (UI) technology
+ Business logic
+ Database technology
]

#note[
  Microservices seek to be as independent as possible by trying to minimize dependencies to other services. Therefore they can be maintained, adapted and deployed individually which satisfy more adequate companies desire for agile software development. #todo[Quelle?]
  - microservice architectures are distributed and favour the decomposition of systems into various independent components which may invoked as required @abgaz2023Decomposition
  - benefits: increased scalability and improved deployment frequency @abgaz2023Decomposition
]

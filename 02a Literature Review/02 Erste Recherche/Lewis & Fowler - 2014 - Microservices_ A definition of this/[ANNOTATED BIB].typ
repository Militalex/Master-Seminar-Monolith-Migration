#block[
#block[
== Microservices: A definition of this new architectural term

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Source:* J. Lewis and M. Fowler "Microservices: A definition of this new architectural term," 2014. [Online]. Available: #link("https://martinfowler.com/articles/microservices.html")]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Rating:* ⭐⭐⭐⭐]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Own Keywords:* Background, Domain Driven Design (DDD), Microservices, Migration, Monolith]
]

#block(fill: rgb("f8f9fa"), inset: 8pt, radius: 3pt, width: 100%)[
  #text(size: 0.9em)[*Reading Progress:* Third Pass]
]

== Introduction (What is the Paper about?)

- The authors wish to describe a new up-coming trend in 2014 towards
  Microservices
- The authors seek to describe what they have seen is typical for
  microservices
  - they compare microservices to the old fashioned monolith and point
    out different key features and ways of thinking

== Methods

- the authors describe their observations and experiences in industry
  applying no further or special methodology

== Scientific Benefit #emph[\(Here the observations)]

- #strong[The authors provide several useful definitions:]
  - #strong[Component:] #emph[“A Component is a unit of software that is
    independently replaceable and upgradeable.”]
  - #strong[Libraries]: #emph[“We define libraries as components that
    are linked into a program and called using in-memory function
    calls.“]
  - #strong[Service:] #emph[“Services are out-of-process components who
    communicate with a mechanism such as a web service request, or
    remote procedure call.“]
    - are independently deployable - libraries not
  - #strong[Microservices:] #emph[“In short, the microservice
    architectural style 1 is an approach to developing a single
    application as a suite of small services, each running in its own
    process and communicating with lightweight mechanisms, often an HTTP
    resource API. These services are built around business capabilities
    and independently deployable by fully automated deployment
    machinery. There is a bare minimum of centralized management of
    these services, which may be written in different programming
    languages and use different data storage technologies.”]
    - seeks to build applications as suites of services
    - services seek to be independently deployable and therefore
      scalable
    - each service may use different programming languages and
      technology stacks to fit their central business capability the
      best
- #strong[Enterprise Applications often consists of three main parts]:
  + User Interface (UI)
  + Server-side application
  + Database (DB)
- #strong[Monoliths are built as one single deployable unit]
  - all logic for handling a request runs just in a single process
  - any (even small) changes involve building and deploying a new
    version of the server-side application
  - people are facing frustrations with monoliths as applications are
    more deployed to the cloud
- #strong[Monoliths are horizontally scalable] by deploying multiple
  instances of the monolith itself rather
  - scaling of single parts of the monolith is not possible
  -
- #strong[Monoliths struggle over time to maintain a good modular
  structure]
  - using just the provided features of the used programming language to
    divide and structure the application
  - hard to keep changes being only limited to one module/place in code
    - often affects many places in the code
-

== Challenges / Future Work

- authors are active members of the microservice community
  - potentially more subjective in this regard

== Limitations

== Paper Outline and Read Progress

+ \[X\] Introduction: Definition of microservices and how it is
  different from monoliths
+ \[X\] Characteristics of a Microservice Architecture

== Own Comments

- \(+) provides several basic ideas and definitions
- \(+) key article of microservices
- \(-) old
- \(-) statements are based on observations
]
]
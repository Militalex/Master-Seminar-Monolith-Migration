#import "../00 assets/preamble.typ": *

#show: template-setup.with(
  doc-title: [Migration],
  bib-style: "apa"
)

= Migration
- companies which have implemented monolithical architectures may consider to migrate to a Microservice Architecture
- for companies with existing monolith-based system it is a challenge to decompose their system into coherent microservice-based implementations @abgaz2023Decomposition
  - may require existing application experts to devote a considerable volume of time @abgaz2023Decomposition
- migration involves identifying service boundaries and packaging them into self-contained microservices with defined APIs @trabelsi2025Systematic
- effective migration require robust strategies for deploying microservices and guaranteeing desired features like scalability, security and fault tolerance @trabelsi2025Systematic
- the authors #citeauthor(<abgaz2023Decomposition>) presented as a result of their research question to identify the primary phases of monolith-to-microservices decomposition the following phases:
  + *Input Collection:* Acquire data that describes the essential characteristics of the monolith application e.g. domain models, codebases, log files or code versions.
  + *Monolith Analysis:* Focus on filtering and transforming the collected data into a representation being suitable for subsequent phases. It may include multiple stages of analysis including domain analysis and static analysis of code to extract structural relationships. Dynamic Analysis and Version Analysis focus on enriching the relationships with frequencies and associations.
  + *Microservice Identification:* Uses heuristics to guide the microservice identification process by partitioning the monolith into microservice candidates. Often clustering algorithms are widely used to extract microservices. They represent the monolith as a graph or matrix and treat the identification problem as a clustering problem.
  + *Microservice Optimisation:* This phase may not be implemented, but in case this phase is executed this approach first generate large pools of possible microservice partitions and seeks to select the optimal partition.
  + *Microservice Evaluation:*
  + *Microservice Deployment:*

== Migration Techniques
- decomposing software into smaller parts have always been a challenge in software engineering and remains a complex and resource intensive task @gysel2016Service @trabelsi2025Systematic
- decomposition sometimes focussed on supporting migration engineers in the microservice identification phase by for analyzing the applications domain @abgaz2023Decomposition
- other techniques may involve analyzing source code, execution traces and version related information @abgaz2023Decomposition
- existing published material tends to focus on addressing specific scenarios, domains or programming languages @abgaz2023Decomposition
- monolith decomposition remains at an early stage and remains a complicated and expensive task event though it has gained more attracrion @abgaz2023Decomposition
  - lack of integrated, comprehensive data collection and analysis methods with respect to crucial monolith aspects
  - lack of comparison between various decomposition methods
  - insufficient tool support, standardized metrics and datasets

=== Domain-Driven Design (DDD)
- let migration engineer analyse and identify application's domain using techniques like _Domain-Driven Design (DDD)_ to obtain service boundaries @gysel2016Service
- DDD is a collection of abstract concepts helping to model complex and large software with respect to the domain @nockemann2025DomainDriven #todo[In Seminararbeit DDD vielleicht genauer erklären und hier nur kurz]

=== Machine Learning (ML) @trabelsi2025Systematic
- ML offer a promising avenue to tackle the manuel intervention and adaptability challenges
  - ML can further improve service boundary identification, analysing interdependencies and predicting failures
    - can assist in automating repetitive and error-prone tasks such as clustering related components or optimising deployment strategies
  - ML perform well in processing large and complex datasets and can uncover invisible patterns
  $=>$ can support decision-making processes which would be otherwise difficult to achieve with traditional methods




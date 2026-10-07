#import "../00 assets/preamble.typ": *

#show: template-setup.with(
  doc-title: [SLR-Protocol],
  bib-style: "apa"
)

= Theme
The topic of this _Systematic-Literature Review (SLR)_ is: #quote(block: true)[
  "_Identification of service interfaces during the migration from monoliths to microservices_"
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

= Inclusion and Exclusion Criteria

== Inclusion:
- paper speaks about microservice/monolith
- paper deal with migration
- paper speaks about the interface or API

== Exclusion:
- paper does not deal with migration of monoliths
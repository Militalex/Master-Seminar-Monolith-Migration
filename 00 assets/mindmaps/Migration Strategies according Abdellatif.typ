#import "../preamble.typ": citeauthor
#import "@preview/tidymind:0.2.0": mindmap, node

#figure(
  placement: auto,
  scope: "parent",
  caption: [Own created mindmap of the authors #citeauthor(<abdellatif2021taxonomy>) proposed migration strategies.]
)[
  #mindmap(
    node-max-width: 200pt,
    node([Migration Strategies],
      node([Top-Down Strategy \ (Forward Engineering)],
        node([(1) High-level decomposition of domain artifacts]),
        node([(2) Modeling of the needed services]),
        node([(3) Implementing those services]),
        node([(4) Implementing the orchestration process])
      ),
      node([Bottom-Up Strategy],
        node([(1) Extracting all dependencies of the legacy system]),
        node([(2) Extracting reusable functionalities (services)]),
        node([(3) Packaging functions and removing legacy dependencies]),
        node([(4) Rewriting apps to _use_ new services])
      ),
      node([Hybrid Strategy],
        node([(1) Grouping functions into coarse functional blocks]),
        node([(2) Mapping blocks to services and removing legacy dependencies]),
        node([(3) Implementing orchestrating processes])
      )
    )
  )
] <mind:mig_strat_abdellatif>
# Migration Strategies

- Top-Down Strategy<br>
  _Strategy: Forward Engineering_
  - (1) Performing a high-level <br>decomposition of domain artifacts
  - (2) Modeling of the needed services
  - (3) Implementing those services
  - (4) Implementing the orchestration process
- Bottom-Up Strategy
  - (1) Extracting of all dependencies of the legacy system
  - (2) Extracring reusable functionalities that could qualify as services
  - (3) Packaging these functions into reusable services with deleting the dependencies to the legacy system
  - (4) Rewriting some existing applications to _use_ the newly-identified services
- Hybrid Strategy
  - (1) Grouping the functions of the application into coarse functional blocks
  - (2) Mapping these functional blocks to available services while deleting their dependecies to the legacy system
  - (3) Implementing orchestrating processes

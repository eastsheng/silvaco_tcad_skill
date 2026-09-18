# Atlas Language and Deck Contract

Read this before generating or auditing a deck. It converts Chapter 2 of the 2018 manual into structural invariants.

## Required phase order

```text
1 structure:  MESH -> REGION -> ELECTRODE -> DOPING
2 physics:    MATERIAL -> MODELS/MOBILITY/IMPACT/TRAP -> CONTACT/INTERFACE
               plus THERMCONTACT before METHOD when LAT.TEMP is used
3 numerics:   METHOD
4 solution:   LOAD/LOG/SOLVE/SAVE in the state order required by the experiment
5 analysis:   EXTRACT/TONYPLOT
```

The manual's five groups are normative; the expanded order above preserves dependencies used by this skill. `LOG` must be open before the `SOLVE` points intended for terminal recording. `LOAD` may begin a solution phase, but it does not restore thermal contacts.

## State contract

Treat a deck as a state machine:

1. `solve init` establishes equilibrium.
2. Each converged `SOLVE` inherits unspecified electrode biases from the preceding solution.
3. `SAVE` stores a spatial solution; `LOG` stores terminal results. They are not interchangeable.
4. `LOAD` must be compatible with the current structure/models and does not recreate every run-level declaration.
5. For curve families, save a clean conditioning state and reload it for every branch so one branch does not inherit another branch's trapped charge, heat, avalanche state, or high-field solution.

Always write the inherited biases explicitly in the run plan even when Atlas permits omission.

## Syntax contract

- Prefer full parameter names. Short forms are safe only when unambiguous in that statement and release.
- Keep electrode names identical across `ELECTRODE`, `CONTACT`, `SOLVE`, `PROBE`, and extraction.
- Quote filenames consistently and avoid platform-dependent case assumptions.
- Split long statements with `\`; do not exceed the 2018 manual's 256-character line limit.
- Put comments on separate `#` lines when a continuation could make parsing ambiguous.
- Request `PRINT` during model development and retain its output as the effective-default record.

## Structure-source decision

1. Use Atlas direct construction when rectangular/polygonal regions and analytic/imported doping reproduce the intended electrical geometry.
2. Use Athena when process history changes oxide shape, junction placement, lateral straggle, activation, or diffusion.
3. Use DevEdit after Atlas/Athena only for mesh/geometry cleanup that the source tool cannot express adequately.

Do not use `REGRID` as the default remesher. Audit triangle angles, interface conformity, electrode coverage, and conservation after any remesh.

## Pre-run audit

- Every region is covered by an intentional material and mesh.
- Gate oxide thickness and trench/corner radii are geometrically resolved.
- Every electrical and thermal contact selects the intended faces only.
- Net chemical doping, ionized dopant density, and free carriers are not conflated.
- All material/model/contact/interface statements precede `METHOD`.
- The log opens before the requested sweep; saved states correspond to named physical conditions.
- All DeckBuild-only commands retain required case and execute in DeckBuild.

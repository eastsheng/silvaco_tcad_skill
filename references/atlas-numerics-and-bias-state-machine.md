# Atlas Numerics and Bias State Machine

Read this when designing a sweep, restarting from a state, diagnosing nonconvergence, or claiming breakdown/latch-up. It condenses Chapters 2 and 21 plus `METHOD`/`SOLVE` statement behavior from the 2018 manual.

## Solver choice

| Scheme | Best use | Warning |
| --- | --- | --- |
| Gummel | robust decoupled equilibrium/low-bias initialization | can converge slowly or fail for strongly coupled high injection |
| Newton | coupled continuation from a good nearby solution | a large first step or poor initial state can diverge sharply |
| Block | selected coupled multiphysics systems, including electrothermal cases | choose coupling from the actual equations, not by habit |
| trap/cutback | reduce a failed bias/time increment | cannot repair wrong geometry, units, signs, or physics |

Exact flags and defaults are release-specific. Modify tolerances only after inspecting the failing equation, residual location, scaling, units, and mesh.

## Deterministic bias protocol

1. Initialize at equilibrium and inspect potential, carrier density and ionized dopants.
2. Ramp one physically controlling terminal at a time with moderate steps.
3. Save named checkpoints before activating a difficult mechanism or changing sweep direction.
4. Open a fresh log for each characteristic/branch.
5. Use coarse continuation away from a knee and fine steps near threshold, avalanche, snapback, thermal runaway, or trap transitions.
6. Apply current/voltage compliance before a destructive numerical branch.
7. Repeat with smaller steps and a refined mesh; the claimed feature must remain stable.

## Failure classification

| Observation | Test before interpreting it physically |
| --- | --- |
| current jump | halve step; reload same checkpoint; inspect fields/generation/temperature |
| solver stops near BV | use compliance/continuation; distinguish avalanche growth from residual failure |
| hysteresis | reproduce with transient/dwell protocol and both sweep directions from controlled states |
| latch-like turn-on | show regenerative carrier flow and parasitic path, not only terminal current |
| hot spot | verify energy balance, thermal boundaries and thermal mesh convergence |
| branch depends on prior sweep | reload an identical conditioning state for each branch |

## Restart invariants

- A structure/solution file is not a complete deck specification.
- Reissue `THERMCONTACT` for every Atlas run using `LAT.TEMP`; the 2018 manual states thermal-contact data are not stored in solution files.
- Reissue model, contact, interface and numerical declarations intentionally; verify compatibility before `LOAD`.
- Save both the runtime `PRINT` record and the spatial state used to start each published curve.

## Minimal evidence for a research curve

Report structure/version, effective model/default printout, initial state, complete bias history, step sizes, compliance, solver scheme, convergence criteria, failed points, mesh study, normalization, extraction definition, and the exact saved state at the claimed operating point.

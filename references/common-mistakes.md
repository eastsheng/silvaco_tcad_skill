# Common mistakes and diagnostic map

| Symptom | Likely cause | Checks and corrections |
|---|---|---|
| Equilibrium fails | overlap/gap, impossible doping, bad contact, extreme mesh | plot regions/net doping; simplify models; inspect electrode coverage |
| Current is orders of magnitude wrong | width/area normalization, units, contact resistance, mobility | audit µm/cm, 2D width, terminal sign, material parameters |
| Breakdown changes with mesh | unresolved field peak or abrupt transition | refine junction/termination smoothly; compare multiple meshes |
| Premature breakdown | edge/corner crowding, wrong ionization set, surface charge | inspect field/ionization maps; check orientation and termination |
| No avalanche | impact model absent/incompatible, bias too low, current compliance | print model set; inspect generation rate and field |
| Solver fails near breakdown | true positive feedback or step too large | reduce step, use cutback, save/reload, distinguish divergence from criterion |
| MOS threshold shifted | work function, fixed charge, interface traps, oxide thickness | validate C-V and electrostatics before mobility fitting |
| MOS on-current too low | channel mobility, traps, JFET width, contact/drift resistance | decompose resistance; inspect current density and potential |
| Leakage temperature trend wrong | barrier/lifetime/traps/tunnelling model mismatch | use I-V(T), activation plots, and separate mechanisms |
| Self-heating is absent | lattice model or thermal boundary missing | inspect lattice temperature and heat-flow boundary |
| Temperature explodes | unrealistic thermal resistance/conductivity or runaway step | audit units/data; reduce steps; check power balance |
| Reverse recovery wrong | lifetime/high injection/circuit parasitics/time step | calibrate lifetime independently; refine transient; verify circuit |
| Negative/unphysical concentrations | convergence/tolerance/parameter error | inspect runtime warnings; reduce step; validate model coefficients |

## Five audits before trusting a curve

1. Syntax audit: valid statement ordering, names, parameters, and files.
2. Unit audit: µm geometry; cm-based densities/cross-sections where documented; K, eV, V, s.
3. Physics audit: every dominant mechanism included and every coefficient matched to its equation.
4. Numerical audit: mesh, step, tolerance, and initial-state sensitivity.
5. Validation audit: comparison to independent experimental or trusted benchmark data.

A successful Atlas exit status proves only that the numerical task completed; it does not prove physical correctness.


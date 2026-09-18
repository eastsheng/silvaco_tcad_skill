# Atlas Model Selection and Parameter Evidence

Read this for any request asking which models, commands, coefficients, defaults, or modifications are needed. It synthesizes Chapters 3, 5, 6, 8, 21 and 22 of the 2018 manual.

## Build models by mechanism

| Mechanism | Command family | Enable when | Key evidence/calibration |
| --- | --- | --- | --- |
| carrier statistics | `MODELS FERMI`/release equivalent | degeneracy or heavy injection changes occupation | doping and carrier-density range |
| incomplete ionization | `MODELS INCOMPLETE`; material ionization parameters | dopant freeze-out/activation matters, especially SiC | species, site, energy, degeneracy, temperature |
| low-field/doping mobility | `MODELS` + `MOBILITY` | all transport simulations | material, polytype, direction, doping and temperature |
| surface/channel mobility | verified MOS/interface mobility model | MOS inversion channel controls current | surface orientation, oxide/interface process, field |
| high-field mobility | `FLDMOB` or material-specific equivalent | output saturation/high-field drift | field direction, velocity data, temperature |
| recombination | `SRH`, `AUGER`, traps | leakage, lifetime, bipolar/high injection | lifetime/trap data; Auger at high injection |
| avalanche | `IMPACT ...` | breakdown or avalanche-assisted latch-up | exact equation, electron/hole coefficients, orientation, temperature |
| tunneling/gate current | relevant `MODELS`/`SOLVE` tunneling family | oxide/barrier current is measured or affects bias | barrier, mass, oxide field/thickness; self-consistent vs post-process |
| interface charge/traps | `INTERFACE`, verified interface-trap mechanism | Vth, subthreshold, hysteresis, dynamic R_on | Qf/Dit spectrum, energy reference, cross-sections, kinetics |
| lattice heat | `MODELS LAT.TEMP`, `MATERIAL TCON.*`, `THERMCONTACT` | self-heating or thermal runaway | k(T,N), heat capacity, heat source, boundary impedance |

## Enabling is not calibration

For every explicit coefficient, report:

| Field | Required content |
| --- | --- |
| parameter | exact Atlas keyword and owning statement |
| equation | model equation/name; coefficients from different laws are not interchangeable |
| unit | Atlas deck unit and source-data unit conversion |
| scope | material/region/interface/contact and crystal direction |
| source | installed default, manual table, vendor example, literature, or measured fit |
| status | `keep-default`, `version-check`, `literature-start`, or `must-calibrate` |
| validity | temperature, doping, field, injection and geometry range |

An unprinted or extraction-corrupted default is `unknown`, not zero. Use `MODELS ... PRINT` and runtime output to establish the effective value.

## Material safeguards

- Silicon convenience flags/model stacks are not SiC stacks.
- For 4H-SiC, record crystal face and field direction before mobility or impact selection. The 2018 manual distinguishes `SIC4H0001` and `SIC4H1120` impact orientations.
- Incomplete ionization changes ionized charge; it does not by itself supply a calibrated mobility law. Some mobility choices may automatically enable it, so inspect printed flags and avoid accidental double assumptions.
- Separate chemical dopant concentration, ionized dopants, net doping, and mobile-carrier density.
- `INTDEFECTS` in this manual is TFT-specific. For SiC MOS work, use it only if the installed release documents the intended SiC interface equation; otherwise use verified `INTERFACE`/trap/interface-mobility mechanisms.

## Characteristic deltas

- Transfer: electrostatics, work function, oxide, Qf/Dit, channel mobility, statistics and ionization.
- Output: transfer baseline plus high-field mobility, access/drift/contact resistance; add lifetime/Auger for IGBT conductivity modulation and heat flow when power is appreciable.
- Breakdown: leakage baseline plus equation- and orientation-correct impact model, termination/corner mesh, compliance and explicit criterion.
- Latch-up: full pnpn geometry, electron/hole transport, SRH/Auger, body resistance, collector injection, impact when relevant, transient circuit and electrothermal feedback.

Never use one universal `MODELS` line across these characteristics. Start with the smallest sufficient stack, save a baseline, and add one mechanism at a time.

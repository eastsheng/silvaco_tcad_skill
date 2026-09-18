# Local MOSFET, IGBT, and HEMT Reproduction Knowledge

Read this reference when selecting or reproducing a MOSFET, IGBT, HEMT/HFET, PHEMT, GaN MISFET, CAVET, or related power-FET example. It records the installed vendor-deck families without copying the vendor decks. The observed libraries were `4.2.2.R` and `4.2.5.R`; rediscover them on another computer.

## Evidence boundary

- A case is **source-available** only when its main `.in` deck is present. An index or HTML description alone is not executable evidence.
- A main deck may call auxiliary `.in`, `.lib`, layout, structure, table, or data files. Copy the whole example directory, not only the main deck.
- Files produced earlier in the same deck are generated checkpoints, not missing startup dependencies.
- `Requires:` and `Minimum Versions:` come from the matching `*_examples.index`; they describe vendor packaging, not guaranteed licenses on the current machine.
- Duplicate cases in `4.2.2.R` and `4.2.5.R` must be compared by hash before assuming they are identical. Prefer the version matching the installed executable.
- Do not reproduce a result by copying only its final bias sweep. Geometry, mesh, material parameters, contacts, interface definitions, initial states, and save/load chain are part of the experiment.

Run `scripts/index-mosfet-igbt-hemt-examples.ps1 -Root <deckbuild-version-root> -Format Markdown` to regenerate the machine-specific inventory. Its JSON mode is suitable for programmatic selection.

## Installed source coverage

The two observed roots contain 86 distinct named, source-available main examples after full-library scanning and category/example de-duplication, plus auxiliary decks. The earlier six-directory scan found only 66 and was incomplete; always use the current full-root indexer.

| Family | Distinct source-available cases | Scope |
| --- | ---: | --- |
| `mos1` | 15 | matched NMOS/PMOS process-built DC/extraction cases |
| `mos2` | 21 | circuit, transient, 3D, reliability, breakdown, CV and mobility cases |
| `power` | 11 relevant | DMOS/LDMOS/power MOSFET and two silicon IGBT cases |
| `sic` | 5 relevant | T-MOSFET, DMOS, IEMOSFET, 3D MOSFET, and a Victory-only 3D trench IGBT |
| `hemt` | 6 | AlGaAs/GaAs HEMT and PHEMT |
| `ganfet` | 8 | source-available AlGaN/GaN HEMT/CAVET cases |
| other local categories | 20 | Athena process/stress/diffusion, ESD, MC Device, Mercury, noise, quantum and radiation transistor cases |

Some later cases are declared by `4.2.5.R` indexes but have no local `.in` source. Treat them as documentation-only and do not claim exact reproduction from this installation.

### Cases outside the six obvious device directories

The full-root scan also found source decks that a directory-only search misses:

- Athena process: `advdifex11`, `andfex13`, `anmiex05`, `anstex02`, `anstex03` for halo diffusion, defect-cluster anneal, geometry scaling and SiGe stress.
- ESD/electrothermal: `esdex03`, `esdex04`, `esdex05` for HBM and second breakdown.
- Monte Carlo/quantum: `mcdeviceex02`-`05`, `quantumex07`, `quantumex08`, `quantumex16` for nanoscale MOSFET/FinFET transport.
- HEMT quantum/alternative solver: `quantumex03`, `quantumex09`, `mercuryex04`.
- Noise/radiation: `noiseex03`, `radex03`.

These specialized solvers/modules do not override the default `Atlas -> Athena -> DevEdit` construction priority. Use them only when the requested observable requires the corresponding transport, quantum, ESD, noise or radiation capability and the installed license supports it.

## MOSFET case map

### MOS1: paired NMOS/PMOS measurement grammar

All 15 cases are process-built, generally `Athena -> Atlas`; DevEdit occurs only in the high-field/current cases. Use the NMOS/PMOS pairs to preserve polarity, voltage direction, carrier models, and extraction signs.

| Cases | Reproduction target |
| --- | --- |
| `mos1ex01`, `mos1ex08` | Id-Vg, threshold, beta and mobility-rolloff extraction |
| `mos1ex02`, `mos1ex09` | family of Id-Vd curves with independent gate-conditioned states |
| `mos1ex03`, `mos1ex10` | subthreshold slope on a logarithmic current curve |
| `mos1ex04`, `mos1ex11` | DIBL from low- and high-drain-bias threshold definitions |
| `mos1ex05`, `mos1ex12` | body effect with explicit substrate bias |
| `mos1ex06`, `mos1ex13` | substrate/gate current; retain high-field mesh and generation models |
| `mos1ex07`, `mos1ex14` | avalanche breakdown and compliance-aware ramp |
| `mos1ex15` | gate-length process split and consistent electrical extraction |

### MOS2: advanced silicon MOS workflows

| Cases | Reproduction target and transferable rule |
| --- | --- |
| `mos2ex01` | MixedMode NMOS inverter: preserve named terminal-to-node mapping and the saved Atlas structure |
| `mos2ex02` | hot-electron aging: reproduce fresh-state solve, stress duration, degraded-state solve, and user-model dependency |
| `mos2ex03` | gate turn-on transient: retain process structure, initial off-state, pulse timing and adaptive time stepping |
| `mos2ex04` | 3D width effect: preserve extrusion/cell width and current normalization |
| `mos2ex05` | drift-diffusion versus EB/NEB: change only transport stack and solver settings |
| `mos2ex06` | BSIM3 extraction: reproduce process, bias matrix and Utmost handoff; do not treat as a single-curve fit |
| `mos2ex07` | snapback: preserve parasitic BJT path, current/voltage continuation and series resistance |
| `mos2ex08` | second breakdown: preserve electrothermal initial state, heat equation and transient/load conditions |
| `mos2ex09` | drain-gate overlap capacitance: retain AC bias point, frequency and electrode geometry |
| `mos2ex10` | map 1D Athena doping into 2D; audit lateral profile construction before Atlas |
| `mos2ex11` | breakdown from ionization integrals; distinguish integral criterion from terminal-current criterion |
| `mos2ex12`, `mos2ex13` | SiGe PMOS process/transport: preserve composition grading, band offsets and NEB comparison |
| `mos2ex14` | CVT/Shirahata/Watt mobility comparison: hold structure and bias protocol fixed |
| `mos2ex15` | poly depletion C-V: preserve gate doping, AC settings and charge model |
| `mos2ex16` | poly doping versus Vth: change only the intended gate-doping split |
| `mos2ex17` | sub-lithographic 20 nm NMOS: preserve process masks, implant and lateral geometry |
| `mos2ex18` | pMOS NBTI: preserve stress/recovery sequence, temperature and trap/degradation state |
| `mos2ex19` | nMOS threshold hysteresis: reproduce forward/reverse sweep history; main deck may source auxiliary content |
| `mos2ex20` | reaction-diffusion pMOS degradation: preserve time/temperature loops and state checkpoints |
| `mos2ex23` | pMOS hole trapping degradation: preserve trap kinetics and fresh/stressed transfer sweeps |

`mos2ex21`, `mos2ex22`, and `mos2ex26` are declared in the newer index but do not have main `.in` sources in the observed roots. `mos2ex24` and `mos2ex25` are vacuum-triode cases and are not MOSFET evidence.

### Power and SiC MOSFETs

| Cases | Reproduction target and transferable rule |
| --- | --- |
| `powerex02` | vertical DMOS turn-on; process structure followed by electrical transient |
| `powerex07`, `powerex08` | LDMOS breakdown by terminal current versus ionization-integral criteria |
| `powerex09`/`sicex02` | SiC trench MOSFET anisotropic mobility; same case family appears in two categories |
| `powerex10`/`sicex03` | SiC DMOS anisotropic mobility; preserve crystal direction and mobility-plane assignment |
| `powerex12` | low-voltage power MOSFET: process, DevEdit remesh, transfer/output/breakdown suite |
| `powerex14` | CoolMOS/superjunction: preserve charge balance and column mesh before breakdown |
| `powerex15` | SEGR: preserve ion strike, transient bias, oxide field outputs and failure criterion |
| `powerex17` | Ga2O3 MOSFET: do not transfer Si/SiC material or avalanche parameters |
| `sicex07` | Atlas-direct 4H-SiC IEMOSFET transfer, output, breakdown and oxide-field checkpoints |
| `sicex08` | Atlas-direct 3D SiC MOSFET; preserve 3D electrode patches, symmetry and width/current normalization |

`powerex11`, `powerex20`, `powerex22`, and `powerex23` are described by the newer index but lack a local main `.in` deck in the observed roots. They can guide a search in another installation, not exact reproduction here.

## IGBT case map

| Case | Source status | Reproduction contract |
| --- | --- | --- |
| `powerex03` | Atlas source available | silicon IGBT transient latch-up with lattice heating: preserve full terminal structure, parasitic thyristor path, thermal boundary, off/on initial states, gate/load transient and latch criterion |
| `powerex04` | Atlas source available | silicon IGBT Ic-Vce family: initialize once, form a separate gate-conditioned state per Vge, sweep collector from that state, preserve carrier lifetimes and conductivity modulation |
| `sicex09` | source available but Victory-only | 3D trench IGBT structure/device chain. Do not run or recommend Victory by default. Extract topology, rounded-trench mesh, layer/electrode layout and bias intent, then rebuild Atlas-first where representable; report any 3D process-shape loss explicitly |

`powerex16` and `powerex21` are documentation-only in the observed installation. Do not claim their BiGT/anode-short or multicell-filament decks are locally reproducible without finding their `.in` and support files elsewhere.

For any SiC IGBT adaptation, replace silicon lifetime, incomplete-ionization, mobility, bandgap, impact-ionization and thermal parameters using the material-specific references in this skill. The silicon IGBT decks provide experiment sequencing, not 4H-SiC calibration values.

## HEMT and GaN-FET case map

### AlGaAs/GaAs HEMT/PHEMT

| Case | Reproduction target |
| --- | --- |
| `hemtex01` | composition- and doping-dependent mobility through C-Interpreter; preserve `.lib` function and built-in comparison |
| `hemtex02` | lattice-matched HEMT breakdown; retain heterojunction, Schottky gate, high-field mesh and avalanche ramp |
| `hemtex03` | Id-Vg and Id-Vd characterization with separate gate states and consistent drain sweeps |
| `hemtex04` | energy-balance versus drift-diffusion; hold structure and material parameters fixed |
| `hemtex05` | recessed-gate PHEMT DC; preserve DevEdit geometry/mesh, recess depth, Schottky gate and heterostructure grading |
| `hemtex06` | PHEMT AC/high-frequency analysis; preserve DC operating point, frequency settings and small-signal extraction |

### AlGaN/GaN and vertical GaN

| Case | Reproduction target |
| --- | --- |
| `ganfetex01` | polarization charge versus cap thickness; main deck sources an auxiliary device deck and post-processes channel charge |
| `ganfetex02` | GaN HEMT breakdown; preserve passivation/surface charge, trap state, field-plate geometry and staged drain ramp |
| `ganfetex03` | AlGaN/GaN Id-Vg and Id-Vd; preserve Al composition, polarization treatment, Schottky gate and contact resistance assumptions |
| `ganfetex04` | InGaN/AlGaN/GaN polarization calculation; preserve layer compositions, strain/polarization choices and charge extraction |
| `ganfetex09` | current collapse and recovery; preserve quiescent stress, trap occupancy history and pulsed/recovery timing |
| `ganfetex10` | Fe-doping-related current collapse; preserve deep-level definition, spatial Fe profile and stress/recovery sequence |
| `ganfetex11` | large-signal output power; preserve DC state, RF/circuit boundary, waveform period and power extraction |
| `ganfetex20` | normally-on vertical GaN CAVET I-V; Atlas-compatible source exists, but keep vertical current path and 3D/current normalization explicit |

The newer index additionally describes `ganfetex05`-`08`, `12`-`19`, and `21`, but no main `.in` source is present in the observed roots. In particular, `ganfetex19` uses Victory Process and must not enter the default route. Search another local installation only when one of these documented capabilities is specifically required.

## Reproduction procedure

1. Run the inventory script and select a **source-available** case by device, material, topology and characteristic—not merely by a similar title.
2. Prefer the executable version's matching example root. Copy the complete example directory to a working location and retain relative filenames.
3. Read the main deck plus every `source`/`include`, `F.*`, layout, imported mesh/structure and measurement-data input before editing.
4. Build a run graph: generator/process deck -> mesh/structure checkpoints -> equilibrium/bias checkpoints -> logs -> extraction/plots. Mark generated versus startup files.
5. Record modules, simulator transitions, dimensionality, coordinate convention, width/area scaling, materials, crystal orientation, terminal names, models, explicit parameters, solver and compliance.
6. Run the unmodified vendor case first when the installed license/version supports it. A successful run verifies syntax and dependencies, not physical suitability for a new design.
7. Adapt one class at a time: geometry/mesh, then material and doping, then contacts/interfaces, then physics, then bias/extraction. Re-run a baseline after each class.
8. Apply the user's priority to new construction: Atlas first, Athena only for essential process history, DevEdit only for necessary remesh/cleanup. Translate—not inherit—Victory-only flows.
9. Validate mesh convergence, bias-step convergence, charge/current continuity, expected terminal signs, and characteristic-specific criteria. For thermal work also close the heat-flow balance.
10. In the answer, cite root version, category/example, source availability, required modules, dependency status, reused rule, changed parameters, and unresolved calibration.

## Minimum output for an exact-reproduction request

Return:

- exact local source path and version;
- main/auxiliary file run graph;
- simulator and module requirements;
- coordinate/region/electrode/doping tables;
- material/interface/model/contact parameter table with source labels;
- bias initialization and sweep state machine;
- generated files and extraction definitions;
- modifications needed for the target material/device;
- blockers caused by unavailable modules, missing source/support files, or Victory-only steps; and
- verification results or a clear statement that the deck was inspected but not executed.

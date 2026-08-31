# Local Silvaco Atlas Examples Index



Use this file as a routing index when the user asks for examples from a locally installed Silvaco TCAD package. Do not assume a fixed installation path. First use `references/tcad-example-discovery.md` or `scripts/find-silvaco-examples.ps1` to locate that machine's examples. Treat all examples as vendor examples for learning deck patterns, not as calibrated recipes for a new device unless the material system, geometry, temperature, and model coefficients match the research target.

## High-Value Directories

| Directory | Main value for SiC power TCAD work |
| --- | --- |
| `sic` | Direct SiC Atlas examples, including 4H-SiC MOSFETs, Schottky/JBS diodes, DLTS, anisotropic impact ionization, interface traps, and 2D/3D comparison. |
| `power` | General power-device Atlas examples. Useful for solver strategy, blocking-state sweeps, termination concepts, and extraction style; verify material assumptions before reusing for SiC. |
| `diode` | Basic diode and breakdown examples. Useful for bias ramping, impact ionization setup, and log/extract patterns. Most examples are not SiC-specific. |
| `mos1`, `mos2` | MOS/MOSFET examples. Useful for gate sweep, threshold extraction, oxide/interface setup, and mobility model patterns; do not transfer silicon defaults directly to SiC. |
| `ganfet`, `mesfet` | Compound semiconductor FET examples. Useful for wide-bandgap solver habits, heterointerface thinking, and field-driven behavior, but not a SiC material model source. |
| `bjt` | Bipolar examples. Useful for recombination, current gain, and mixed-mode style patterns; not a first stop for SiC unipolar power devices. |

## SiC Example Files

Vendor indexes can describe `sicex01` through `sicex14` even when only a subset of payload directories is installed. On the machine observed while maintaining this skill, `4.2.2.R` had all 14 main decks (plus three `sicex10` auxiliary decks), whereas `4.2.5.R` physically had only `sicex02`-`06`, `sicex12`, and `sicex13`. Always use discovery output rather than this historical observation to decide whether a deck can be opened.

| Example | Observed title or purpose | Most useful patterns |
| --- | --- | --- |
| `sicex01` | SiC extended precision / breakdown precision comparison | `go atlas simflags`, 4H-SiC region, SRH, anisotropic impact ionization, high-voltage ramp, clock-time extraction. |
| `sicex02` | Anisotropic mobility characteristics of 4H-SiC trench MOSFET | 4H-SiC trench MOSFET, oxide gate region, analytic/conmob/fldmob/SRH model stack, mobility angle parameters, Id-Vd comparison. |
| `sicex03` | Anisotropic mobility characteristics of 3C-SiC DMOS | DMOS deck pattern and mobility comparison; useful structurally, but material is 3C-SiC, not 4H-SiC. |
| `sicex04` | Aluminum implant into 6H-SiC | Athena/process-style implant profile extraction for Al in SiC. |
| `sicex05` | Al implant in 4H-SiC with screen oxide | Implant profile extraction and screen oxide effect. |
| `sicex06` | Al implant in 4H-SiC without screen oxide | Implant profile extraction and no-screen comparison. |
| `sicex07` | Enhancement-mode IEMOSFET in 4H-SiC | 4H-SiC MOSFET, SiC/oxide interface states, threshold voltage, oxide electric field, on-resistance, breakdown extraction. |
| `sicex08` | 3D SiC MOSFET | 3D 4H-SiC MOSFET geometry, 3D doping/electrodes, precision settings, Id-Vd/Id-Vg style analysis. |
| `sicex09` | 3D SiC trench IGBT | Victory-based historical example; use only for transferable rounded-corner/field-crowding insight and translate it using Atlas first, Athena if process history is essential, and DevEdit only for necessary remeshing. |
| `sicex10` | 3D trench-shape effect on I-V and breakdown | Layout-driven flow with Athena implant auxiliaries; voltage-to-current controlled breakdown continuation. |
| `sicex11` | 2D versus 3D breakdown comparison | 4H-SiC breakdown, 2D/3D comparison, `material ... ZETA`, anisotropic impact model setup. |
| `sicex12` | 4H-SiC Schottky diode DLTS | SBD, trap definition, transient/capacitance extraction, temperature sweep. |
| `sicex13` | Alternative inversion layer mobility model | SiC/oxide interface traps, `INTTRAP`, fixed interface charge, probe-based inversion mobility behavior. |
| `sicex14` | Reverse I-V of SiC Schottky and JBS diodes | 4H-SiC SBD/JBS, Schottky work function, incomplete ionization, anisotropic impact ionization, measured-data overlay. |

## Routing Rules

- For transfer, output, IGBT latch-up, or breakdown physics/model/parameter selection, read `references/device-characteristics-model-matrix.md`; use `powerex03` for silicon electrothermal latch-up, `powerex04` for IGBT output families, `powerex07`/`08` for silicon breakdown methods, and `sicex07` for 4H-SiC MOSFET transfer/output/breakdown sequencing.
- For IGBT structure, mesh, gate oxide, and electrodes, use `references/igbt-mosfet-structure.md`; start with `powerex03`/`powerex04` for a simple Atlas-built planar IGBT and `sicex09` for a process-built 3D trench SiC IGBT.
- For SiC MOSFET channel/interface questions, start with `sicex07` and `sicex13`; use `sicex02` for trench MOSFET anisotropic mobility and `sicex08` for 3D setup.
- For SiC Schottky/JBS reverse leakage or breakdown, start with `sicex14`; use `sicex12` for trap/DLTS behavior.
- For high-voltage breakdown convergence and arithmetic precision, start with `sicex01` and `sicex11`.
- For process/implant background, use `sicex04` to `sicex06`, but label them as implant/process examples rather than Atlas electrical device decks.
- For non-SiC examples in `power`, `diode`, and `mos*`, extract deck structure and solver/extraction patterns only; replace material, mobility, impact, ionization, lifetime, interface, and contact assumptions for 4H-SiC.





# Local Silvaco Atlas Examples Index

Source tree inspected: `D:\softwares\sedatools\examples\deckbuild\4.2.2.R`

Use this file as a routing index when the user asks for examples from the locally installed Silvaco TCAD package. Treat these examples as vendor examples for learning deck patterns, not as calibrated recipes for a new device unless the material system, geometry, temperature, and model coefficients match the research target.

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

The installed `sic` directory contains examples `sicex01` through `sicex14`.

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
| `sicex09` | SiC layout/rounding example | Layout-driven/rounded geometry flow; use for edge geometry and field-crowding studies. |
| `sicex10` | SiC 3D or layout-related flow with auxiliary decks | GDS/layout flow, MPI/PAM method use, 4H-SiC material blocks, anisotropic impact. |
| `sicex11` | 2D versus 3D breakdown comparison | 4H-SiC breakdown, 2D/3D comparison, `material ... ZETA`, anisotropic impact model setup. |
| `sicex12` | 4H-SiC Schottky diode DLTS | SBD, trap definition, transient/capacitance extraction, temperature sweep. |
| `sicex13` | Alternative inversion layer mobility model | SiC/oxide interface traps, `INTTRAP`, fixed interface charge, probe-based inversion mobility behavior. |
| `sicex14` | Reverse I-V of SiC Schottky and JBS diodes | 4H-SiC SBD/JBS, Schottky work function, incomplete ionization, anisotropic impact ionization, measured-data overlay. |

## Routing Rules

- For SiC MOSFET channel/interface questions, start with `sicex07` and `sicex13`; use `sicex02` for trench MOSFET anisotropic mobility and `sicex08` for 3D setup.
- For SiC Schottky/JBS reverse leakage or breakdown, start with `sicex14`; use `sicex12` for trap/DLTS behavior.
- For high-voltage breakdown convergence and arithmetic precision, start with `sicex01` and `sicex11`.
- For process/implant background, use `sicex04` to `sicex06`, but label them as implant/process examples rather than Atlas electrical device decks.
- For non-SiC examples in `power`, `diode`, and `mos*`, extract deck structure and solver/extraction patterns only; replace material, mobility, impact, ionization, lifetime, interface, and contact assumptions for 4H-SiC.


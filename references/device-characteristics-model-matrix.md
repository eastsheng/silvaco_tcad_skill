# Device Characteristics, Material Models, Commands, and Parameter Governance

For high-voltage SiC IGBT calibration order, false turn-on, short-circuit/latch-up, and multi-objective collector-side optimisation distilled from Almpanis (2024), also read `almpanis-2024-sic-igbt-research.md`.

Read this reference for MOSFET/IGBT transfer, output, latch-up, and breakdown work. Commands target Atlas and are informed by bundled rules plus local vendor examples; confirm exact keyword spelling and availability only when the installed release rejects a command. Example coefficients are evidence of vendor-example usage, not recommended calibration values.

## Parameter modification levels

Label every explicit parameter in a proposed deck:

| Level | Meaning | Action |
| --- | --- | --- |
| `keep-default` | documented built-in value is appropriate for the installed material/model and intended range | state the release and do not override merely to reproduce an old deck |
| `version-check` | keyword, default, equation, or material support may differ by release/module | verify installed manual/example output before running |
| `literature-start` | credible material/polytype/orientation data can initialize the model | cite equation, units, temperature/doping/field range; still run sensitivity tests |
| `must-calibrate` | device/process dependent or directly controls the claimed curve | fit to independent data and report uncertainty/identifiability |

Never adjust bandgap, affinity, permittivity, intrinsic-density floors, lifetimes, mobility, impact coefficients, interface traps, fixed charge, contact work function, or thermal resistance solely to force a curve match without documenting the physical source.

## Material-property baseline

| Material | Always identify | Characteristic-sensitive properties | Default/override rule |
| --- | --- | --- | --- |
| Silicon | orientation, doping, temperature, lifetime, oxide/interface process | CVT/surface mobility, SRH/Auger, BGN, Selberherr impact, thermal conductivity | built-ins are often usable as a baseline, but lifetime, interface charge/traps, contacts, and thermal boundary remain `must-calibrate` |
| 4H-SiC | polytype, c-axis relative to device axes, surface plane, dopant species and ionization, temperature | anisotropic bulk/channel mobility, incomplete ionization, interface traps/fixed charge, SRH lifetime, anisotropic impact, extended precision | most transport/interface/avalanche quantities are `literature-start` or `must-calibrate`; verify all orientation and ionization parameters |
| 3C-SiC | cubic polytype, substrate/interface orientation, defects | mobility, lifetime, interface, impact coefficients | do not inherit 4H-SiC anisotropy or coefficients; local `powerex10` is only a vendor pattern and its explicit values require revalidation |
| 6H-SiC | polytype and crystal direction, especially for implants | implant channeling, activation, mobility, lifetime, impact | use 6H-specific datasets; never treat implant examples as 4H electrical calibration |
| Ga2O3 or user-defined WBG | phase/orientation, user material mapping, thermal conductivity, contacts, trap spectrum | user-defined band parameters, mobility, heat flow, traps, impact model availability | nearly all explicit values are `version-check` plus `must-calibrate`; `USER.DEFAULT` inheritance is only a software scaffold, not physical equivalence |
| GaAs/AlGaAs/InGaAs HEMT/PHEMT | layer composition/grade, band alignment, spacer/doping, Schottky gate, recess, temperature | heterojunction mobility and saturation, hot carriers, interface charge, avalanche, AC/RF | alignment, mobility, barrier, charge and access/contact resistance are `must-calibrate`; do not transfer GaN parameters |
| AlGaN/GaN HEMT/MIS-HEMT | barrier composition/thickness, strain/polarization strategy, 2DEG, passivation, buffer/surface traps, contacts | GaN high-field mobility, trap kinetics, avalanche, gate leakage, heat flow | polarization scale/charge, traps, mobility, contacts and thermal boundary are `must-calibrate`; avoid double-counting polarization |

If a requested material is absent from this table, first identify whether the simulator has a built-in material or requires a user-defined material. Do not invent a complete parameter set.

## Transfer characteristic: Id–Vg / Ic–Vg

### Bias protocol

Hold drain/collector at a stated low or application-relevant voltage, initialize from equilibrium, ramp the drain/collector gently, open the log, then sweep gate. State sweep direction, temperature, body/emitter connection, current normalization, and threshold definition.

```atlas
solve init
solve previous
solve vdrain=<small_bias>
log outf=<transfer.log>
solve name=gate vgate=<start> vstep=<step> vfinal=<stop>
log off
extract name="Vth" <documented_method>
```

For hysteresis or trapping, run forward and reverse sweeps with a controlled dwell/time protocol; do not interpret a purely DC continuation artifact as physical hysteresis.

### Required model decisions

| Material/device | Required baseline | Add when relevant | Parameters normally modified |
| --- | --- | --- | --- |
| Si MOSFET/IGBT gate channel | concentration/surface mobility such as `CVT` or release-appropriate equivalent, `SRH`, Fermi statistics when degenerate | `AUGER`, `BGN` at high injection/heavy doping; interface traps for measured subthreshold/hysteresis | oxide thickness, gate work function, fixed charge, interface traps, mobility coefficients: `must-calibrate` |
| 4H-SiC MOS channel | `SRH`, field/concentration mobility, verified 4H-SiC channel/interface treatment, incomplete ionization when supported/important | `INTERFACE`, discrete/continuous interface traps supported by the installed release, alternative inversion mobility such as `ALTCVT.N`, temperature dependence | work function, Dit spectrum/cross-sections, Qf, channel mobility/scattering, dopant activation: `must-calibrate`; anisotropy: `version-check` + calibration. Do not use `INTDEFECTS` generically: the 2018 manual documents it as a TFT model. |
| 3C/6H-SiC | correct polytype material and mobility/interface model | traps, incomplete ionization, temperature models as supported | every borrowed 4H coefficient must be replaced; polytype data are `literature-start` |
| HEMT/HFET/PHEMT | heterojunction band alignment, material-scoped mobility/recombination, Schottky or MIS gate, polarization for III-nitrides | buffer/surface traps, gate leakage, self-heating, energy-balance/nonlocal transport | layer composition, sheet density, barrier/work function, fixed/interface charge, traps and access resistance: `must-calibrate` |

Useful command families: `MODELS ... PRINT`, `MOBILITY ...`, release-verified interface-trap statements, `INTERFACE QF=...`, `CONTACT NAME=gate WORKFUNCTION=...` or `N.POLY`, `PROBE`, `OUTPUT E.MOB ...`, and `EXTRACT`.

Do not fit Vth by varying Qf, Dit, work function, channel implant, and mobility simultaneously. Calibrate electrostatics first, subthreshold/interface response second, mobility/on-current third.

## Output characteristic: Id–Vd / Ic–Vce

Create one saved gate-conditioned state per curve, reload it, then sweep drain/collector. This prevents a curve family from inheriting the previous high-field state.

```atlas
solve init
solve name=gate vgate=<target> vstep=<gate_step> vfinal=<target>
save outf=<gate_state.str> master

load inf=<gate_state.str> master
log outf=<output.log> master
solve vdrain=<small>
solve name=drain vstep=<step> vfinal=<stop>
log off
```

For IGBT use `collector` consistently. Local `powerex04` demonstrates saving `VG5.str`/`VG10.str`, reloading each, and sweeping collector.

| Region of curve | Dominant requirements | Parameters to calibrate/check |
| --- | --- | --- |
| Linear/on-state MOSFET | channel mobility, contact/series resistance, JFET and drift geometry | channel mobility, source/drain contact resistance, active width/area, drift doping |
| Saturation | field-dependent mobility/velocity saturation, self-heating if power is significant | saturation velocity/model coefficients, thermal conductivity/boundary |
| IGBT conductivity modulation | electron/hole mobility, SRH lifetime, Auger/high injection, buffer/collector injection efficiency | carrier lifetimes, collector doping, buffer, contact, area normalization |
| High-current roll-off | self-heating, mobility temperature dependence, contact/circuit resistance | thermal resistance, thermal contact, pulse duration, external circuit |

Silicon vendor examples use patterns such as `MODELS ANALYTIC SRH AUGER FLDMOB SURFMOB`. For 4H-SiC, do not transfer that line unchanged: select verified SiC mobility, incomplete-ionization, interface, high-injection, and thermal behavior for the operating range.

## IGBT latch-up

Latch-up is activation of the parasitic thyristor, not merely a solver failure or sharp current rise. The model must resolve carrier injection, recombination, lateral body resistance, impact generation when relevant, temperature feedback, and the external drive/circuit.

### Minimum physics and structure

- correct pnpn topology and intentional emitter/body short geometry;
- electron and hole transport with concentration/field/temperature dependence;
- `SRH` and, at high injection, `AUGER`;
- impact ionization for avalanche-assisted latch-up;
- `LAT.TEMP`/heat flow plus explicit `THERMCONTACT` for electrothermal latch-up;
- realistic carrier lifetime, body resistance, collector injection, contact resistance, and external impedance;
- transient time steps short enough to resolve gate ramp, carrier storage, and thermal growth.

Vendor-example command pattern from silicon `powerex03`:

```atlas
models analytic srh auger fldmob surfmob lat.temp
impact selb
thermcontact num=<n> elec.num=<collector_id> temp=<K>
load inf=<blocking_state.str> master
log outf=<latch.log>
solve vgate=<target> ramptime=<rise_time> tstep=<initial_dt> tstop=<stop_time> t.compl=<limit>
```

For 4H-SiC replace silicon impact and mobility assumptions with verified 4H-SiC anisotropic impact, mobility, incomplete ionization, lifetime, and thermal data. Extended precision may be needed for the initial blocking state. These replacements are `version-check` plus `must-calibrate`—the silicon latch-up deck is not a SiC coefficient source.

### Latch-up evidence

Require terminal waveforms, lattice-temperature map, electron/hole current-density maps, impact-generation map, potential drop under the emitter/body short, and parasitic transistor current gain or an equivalent carrier-flow explanation. Repeat with smaller time steps and mesh refinement. Separate electrical regenerative turn-on from thermal runaway.

## Breakdown characteristic

### Model selection

| Material | Impact model rule | Other required checks |
| --- | --- | --- |
| Silicon | a supported calibrated model such as `IMPACT SELB`; ionization-integral workflow may estimate onset | temperature, field peak mesh, leakage mechanism, termination, criterion |
| 4H-SiC | verified anisotropic 4H-SiC impact form and axis/orientation mapping | incomplete ionization, extended precision, interface/surface charge, trap/leakage, corner mesh |
| 3C/6H-SiC | polytype-specific impact data/model | never reuse 4H coefficients; verify simulator support |
| User-defined WBG | only a model actually supported for that material/equation | coefficient provenance, equation convention, traps/tunneling, thermal feedback |

### Continuation pattern

```atlas
models <material-appropriate stack> print
impact <verified model and coefficients>
method <verified solver controls>
solve init
solve <small drain/collector steps>
log outf=<breakdown.log>
solve name=<terminal> vstep=<coarse> vfinal=<pre_knee>
solve name=<terminal> vstep=<fine> vfinal=<target> compliance=<I_limit> cname=<terminal>
contact name=<terminal> current
solve name=<terminal> istep=<factor> imult ifinal=<I_final>
save outf=<breakdown.str>
extract name="BV" <explicit criterion>
```

Ionization integrals (`IONIZ`, `IONLINES`, related output) can locate avalanche onset without full carrier transport, as in `powerex08`, but they are not automatically equivalent to a current-defined terminal breakdown curve.

### Parameters requiring modification

- Impact coefficients and their equation/orientation: `must-calibrate` for publication claims.
- Mesh at junction/trench/oxide/contact corners: convergence study required.
- Drift doping/thickness and termination charge/geometry: device definition, never a solver tuning parameter.
- Lifetime, traps, tunneling, barrier/contact and surface charge: calibrate to leakage versus voltage and temperature before BV fitting.
- Precision, solver tolerance, voltage/current step and compliance: numerical controls; vary for robustness but do not report them as physical calibration.
- Breakdown current/current-density criterion: explicitly define and normalize by area/width.

## Characteristic-specific validation order

1. Validate equilibrium electrostatics and material activation.
2. Validate transfer/C–V electrostatics and interface behavior.
3. Validate low-field mobility and on-state resistance/output curves.
4. Validate lifetime and high-injection behavior for IGBT.
5. Validate leakage mechanisms versus temperature.
6. Only then calibrate avalanche/breakdown and latch-up.

This order reduces parameter compensation. A good breakdown fit cannot validate an incorrect transfer curve, interface model, lifetime, or current normalization.

## Required answer format

For each requested characteristic and material, provide:

1. bias sequence and terminal convention;
2. material properties that affect the result;
3. required and optional models with exact command families;
4. parameter table with value/unit/source/modification level;
5. mesh and structure hot spots;
6. extraction definition and normalization;
7. convergence and experimental validation plan; and
8. unsupported or version-dependent items that still require manual verification.

For self-heating, thermal conductivity, or interface/package heat-flow questions, also read `thermal-properties-and-boundaries.md` and separate bulk `MATERIAL TCON.*`, internal interface resistance, and external `THERMCONTACT` conductance.

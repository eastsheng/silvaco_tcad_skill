# 4H-SiC IGBT Electrothermal Models and Defaults

Read this reference first for any 4H-SiC IGBT self-heating, short-circuit, latch-up, turn-off, or electrothermal breakdown task. It defines the complete model-selection audit; it does not claim that every installed-release default is physically calibrated for a particular wafer or device.

## Default-value authority

Use this evidence order:

1. Runtime output from the exact installed simulator using `MODELS ... PRINT` and the real material/region/model stack.
2. The matching installed-version manual parameter table.
3. A vendor example from the same installed release.
4. Peer-reviewed material/device data used as an explicit override.

Record simulator name/version, enabled modules, material alias, dimensionality, temperature, and every explicit override. A parameter absent from runtime/manual evidence is `unknown`, not an assumed zero.

On the maintenance machine, Atlas 5.30 started and reported GIGA/GIGA3D enabled, but its minimal default-audit deck aborted on an internal formatted-specification-file error before `MODELS PRINT` completed. Therefore the values below are Atlas 5.30 manual baselines and remain `runtime-unverified` on that installation.

## Recommended baseline stack

There is no single universal `MODELS` line. A defensible starting point for a drift-diffusion, electrothermal 4H-SiC IGBT is:

```atlas
models fermi bgn analytic fldmob srh auger incomplete lat.temp heat.full print
impact aniso sic4h0001
```

Then add or remove models based on the experiment:

- add anisotropic `MOBILITY` statements with verified crystal axes;
- add `INTDEFECTS`/`INTERFACE` for MOS-channel electrostatics and channel mobility;
- add `HCTE` or `HCTE.EL` only when carrier energy transport materially affects the result;
- add tunneling/trap models only when supported by leakage or transient evidence;
- add `THERMCONTACT` and explicit thermal material properties for every relevant heat-flow path.

`HEAT.FULL` is not synonymous with `LAT.TEMP`: `LAT.TEMP` solves lattice heat flow; `HEAT.FULL` selects the full drift-diffusion heat-source expression. Atlas 5.30 otherwise uses the simpler `J·E` form by default for steady state.

## Complete audit matrix

| Physics block | Commands/models | Controlling parameters | Atlas-default status | 4H-SiC IGBT action |
| --- | --- | --- | --- | --- |
| Band structure/statistics | `MATERIAL`, `FERMI`, `BGN` | `EG300`, `EGALPHA`, `EGBETA`, `AFFINITY`, `PERMITTI`, `NC300`, `NV300`, effective masses; BGN coefficients | some built-ins exist; manual tables are model-specific | runtime-print; calibrate band alignment/contact-sensitive values; do not tune Eg to fit current |
| Dopant activation | `INCOMPLETE`, default `INC.TWO_LEVEL` for 4H/6H-SiC | `ALPHA.INCOMPLETE`, `ED/EA.CUBIC`, `ED/EA.HEXAGONAL`, `A/B.EDB`, `A/B.EAB`, degeneracies | confirmed manual defaults listed below | select dopant species; defaults correspond to particular donors/acceptors and are not universal |
| Low-field mobility | `ANALYTIC`/`CONMOB`, `MOBILITY` | `MU1/2N/P.CAUG`, `NCRIT*`, `ALPHA*`, `BETA*`, `GAMMA*`, `DELTA*` | confirmed model defaults listed below | calibrate separately for drift, channel orientation, doping and temperature |
| Mobility anisotropy | two `MOBILITY` statements, one with `N.ANGLE/P.ANGLE` | angle, all mobility coefficients in each direction | no universal device-axis mapping | mandatory axis audit; calibrate surface/channel versus bulk independently |
| High-field transport | `FLDMOB` | `ALPHAN.FLD`, `TNOMN.FLD`, `DELTAN.FLD`, `N.BETA0`, `N.BETAEXP`; hole equivalents/model | electron defaults listed below | validate high-current and temperature dependence; do not infer hole parameters from electron data |
| Recombination/lifetime | `SRH` or `CONSRH`, `AUGER` | `TAUN0`, `TAUP0`, trap energy, capture/lifetime doping and temperature coefficients, `AUGN/AUGP` | reliable universal 4H-SiC device defaults not established here | `must-calibrate`; controls conductivity modulation, tail current, latch-up and heat |
| Avalanche | `IMPACT ANISO SIC4H0001` or verified alternative | `AE/BE/AH/BH` for 0001 and 1120, `N/P.ANISOHW`, orientation, carrier-side flags | confirmed manual defaults below | literature-start only; calibrate BV and temperature trend; mesh-converge corners |
| MOS interface | `CONTACT`, `INTERFACE`, `INTDEFECTS`, channel `MOBILITY` | gate work function, Qf, Dit(E), capture cross-sections, channel scattering/mobility | no universal defaults for fabricated SiC/SiO2 | `must-calibrate` from C-V/Id-Vg/mobility data before power tests |
| Ohmic/collector injection | `CONTACT` plus geometry/doping | contact resistance, work function/barrier, surface recombination, collector efficiency | device/process dependent | `must-calibrate`; affects Vce(sat), carrier storage and heat |
| Lattice heat equation | `LAT.TEMP` | thermal conductivity, heat capacity, thermopower, heat-source flags | model enabled default is false | explicit activation and boundary required |
| Heat sources | default simple heat or `HEAT.FULL`; `JOULE.HEAT`, `GR.HEAT`, `PT.HEAT` | model flags and numerical discretization | simple `J·E` steady-state heat is default; flux Joule discretization is default | use `HEAT.FULL` for latch-up/turn-off studies unless justified otherwise; compare sensitivity |
| Carrier energy transport | `HCTE`, `HCTE.EL`, `HCTE.HO` | relaxation-time models/parameters, `KSN/KSP`, carrier-temperature mobility options | off by default | optional; enable only with evidence and additional calibration |
| Bulk heat conduction | `MATERIAL TCON.*`, `TANI.*`, `F.TCOND` | `TC.*`, `A.TC.*`, axis transform; optional doping function | 4H-SiC universal runtime default not confirmed | explicitly set from selected wafer/polytype/orientation dataset; include doping and T dependence |
| Heat capacity | `HC.STD`, `HC.*`, `F.TCAP` | `HC.A/B/C/D` or `HC.RHO/C300/C1/BETA` | common-material defaults exist, but 4H-SiC runtime value unconfirmed | explicitly document for transients; steady-state is insensitive to heat capacity |
| Internal TBR | explicit thin region | `R''`, `G`, chosen thickness, `k=G*t` | no dedicated adjacent-region TBR keyword found in Atlas 5.30 | calibrate SiC/SiO2, metal/oxide, backside interfaces separately |
| External cooling | `THERMCONTACT` | `EXT.TEMP`, `ALPHA`, optional `BETA`, radiation flags, geometry/`ELEC.NUM` | fixed T if `ALPHA` omitted; `R''=1/ALPHA` when supplied | derive from package stack or measured Zth; never copy example ALPHA |
| Numerical precision | `GO ATLAS SIMFLAGS="-80/-128/-160"`, `METHOD` | precision, tolerance, iteration limits, scaling, bias/time steps | not physical defaults | convergence controls only; compare precision/steps without retuning physics |

## Atlas 5.30 manual baseline values

The following values are default-model baselines, not recommended calibrated values.

### Basic 4H-SiC properties

| Parameter | Atlas 5.30 manual value | Unit | Status |
| --- | ---: | --- | --- |
| `EG300` | 3.26 | eV | manual baseline |
| `EGALPHA` | 0 | eV/K | manual baseline table |
| `EGBETA` | 0 | K | manual baseline table |
| `AFFINITY` | 4.0 | eV | manual baseline table |
| `PERMITTI` | 9.7 | dimensionless | manual baseline |

The manual contains inconsistent-looking generic SiC mobility summaries in different sections after PDF extraction. Use the model-specific Table 6-26/6-28 values and runtime `PRINT`, not an unlabeled appendix row.

### Analytic doping-dependent mobility, 4H-SiC

| Parameter | Default | Unit |
| --- | ---: | --- |
| `MU1N.CAUG` | 0.0 | cm2/(V s) |
| `MU1P.CAUG` | 15.9 | cm2/(V s) |
| `MU2N.CAUG` | 947.0 | cm2/(V s) |
| `MU2P.CAUG` | 124.0 | cm2/(V s) |
| `ALPHAN.CAUG`, `ALPHAP.CAUG` | 0.0 | - |
| `BETAN.CAUG`, `BETAP.CAUG` | -1.8 | - |
| `GAMMAN.CAUG`, `GAMMAP.CAUG` | 0.0 | - |
| `DELTAN.CAUG` | 0.61 | - |
| `DELTAP.CAUG` | 0.34 | - |
| `NCRITN.CAUG` | 1.94e17 | cm-3 |
| `NCRITP.CAUG` | 1.76e19 | cm-3 |

These are bulk analytic-mobility defaults, not SiC MOS inversion-channel calibration.

### 4H-SiC saturated electron velocity model

| Parameter | Default | Unit |
| --- | ---: | --- |
| `ALPHAN.FLD` | 2.2e7 | cm/s |
| `TNOMN.FLD` | 300 | K |
| `DELTAN.FLD` | -0.44 | - |
| `N.BETA0` | 1.2 | - |
| `N.BETAEXP` | 1.0 | - |

### 4H-SiC anisotropic impact model

| Parameter | Default | Unit |
| --- | ---: | --- |
| `AE0001` | 1.76e8 | cm-1 |
| `BE0001` | 3.30e7 | V/cm |
| `AH0001` | 3.41e8 | cm-1 |
| `BH0001` | 2.50e7 | V/cm |
| `AE1120` | 2.10e7 | cm-1 |
| `BE1120` | 1.70e7 | V/cm |
| `AH1120` | 2.96e7 | cm-1 |
| `BH1120` | 1.60e7 | V/cm |
| `N.ANISOHW`, `P.ANISOHW` | 0.19 | eV |
| default orientation flag | `SIC4H0001` | - |

These coefficients are strongly model/equation/orientation dependent. Never mix them with `SELB` coefficients or a different anisotropic-impact formulation.

### Two-level incomplete ionization, 4H-SiC

| Parameter | Default | Unit/meaning |
| --- | ---: | --- |
| `INC.TWO_LEVEL` | true | for 4H/6H-SiC |
| `ALPHA.INCOMPLETE` | 1/2 | site fraction |
| `A.EAB` | 0.205 | manual table unit reported as eV.cm |
| `B.EAB` | 1.7 | eV |
| `A.EDB` | 0.105 | manual table unit reported as eV.cm |
| `B.EDB` | 4.26 | - |
| `ED.CUBIC` | 0.09 | eV |
| `ED.HEXAGONAL` | 0.05 | eV |
| `EA.CUBIC`, `EA.HEXAGONAL` | 0.32 | eV |

The manual states donor defaults correspond to nitrogen and acceptor defaults to boron. Aluminum acceptors or other dopants require appropriate overrides; do not silently use the boron value.

### Gate dielectric defaults relevant to heat flow

Atlas 5.30 Appendix B lists at 300 K:

| Material alias | Thermal capacity | Thermal conductivity |
| --- | ---: | ---: |
| `Oxide` / `SiO2` | 3.066 J/(cm3 K) | 0.014 W/(cm K) |

This is a bulk-amorphous-oxide baseline. It does not include SiC/SiO2 thermal boundary resistance, gate-metal/oxide TBR, processing/porosity effects, or thickness-dependent conductivity.

## Values that must not remain implicit

For research-grade 4H-SiC IGBT electrothermal results, explicitly document or override:

- electron and hole SRH lifetime and their doping/temperature dependence;
- Auger coefficients when high injection is important;
- bulk and channel mobility in each crystal direction;
- active donor/acceptor model and species;
- impact-ionization coefficient set and orientation;
- 4H-SiC thermal conductivity tensor versus temperature and doping;
- volumetric heat capacity versus temperature for transients;
- SiC/SiO2 and backside interface TBR;
- oxide, metal, substrate, die-attach and package thermal properties;
- collector injection/contact resistance and emitter/body-short resistance;
- external thermal boundary `ALPHA`, ambient temperature, and transient thermal capacitance if used.

If any is omitted, state why it is negligible for the requested observable and quantify sensitivity.

## Heat-source selection

Atlas 5.30 behavior:

- `LAT.TEMP` is off by default.
- With drift-diffusion and steady state, the simple `J·E` heat expression is the default.
- `HEAT.FULL` selects Joule, generation/recombination, and Peltier/Thomson terms.
- Individual controls include `JOULE.HEAT`, `GR.HEAT`, and `PT.HEAT`.
- Flux-like Joule-heat discretization is default; `METHOD ^FLUX.JOULE` selects the alternative source-like form.
- Insulator heat generation is zero in this formulation; heat still conducts through insulator regions.

For IGBT conductivity modulation, latch-up, short-circuit, and turn-off, compare the default simple heat result with `HEAT.FULL`; use the latter as the preferred physical baseline unless numerical or validation evidence supports another choice.

## Characteristic-specific additions

| Experiment | Baseline additions | Key calibration |
| --- | --- | --- |
| DC output/self-heating | `LAT.TEMP`, finite collector thermal boundary, T-dependent mobility and lifetime | Vce(sat), Ic, surface/peak T, Rth |
| Short circuit | transient `LAT.TEMP`, `HEAT.FULL`, high-field mobility, SRH/Auger, impact as needed | pulse circuit, heat capacity, Zth(t), saturation current |
| Latch-up | full electron/hole transport, `HEAT.FULL`, impact, thermal feedback | body resistance, lifetime, parasitic gains, emitter short, timestep |
| Turn-off/tail | SRH/Auger, stored charge, thermal feedback | lifetime profile, buffer/collector injection, circuit inductance |
| Electrothermal breakdown | anisotropic impact, T-dependent coefficients, extended precision, thermal boundaries | leakage(T), BV(T), criterion, corner mesh |

## Required final model report

Before accepting a deck, produce one row per active model/parameter with:

```text
statement | model/parameter | value | unit | default or override |
Atlas version/source | applicable regions | calibration dataset |
sensitivity result | keep/change verdict
```

Also list disabled but plausible models and why they were excluded. “Simulation converged” is not evidence that the electrothermal model is complete.

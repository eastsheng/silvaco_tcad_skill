# Almpanis 2024 SiC IGBT research lessons

Read this reference for high-voltage 4H-SiC IGBT calibration, false turn-on, short-circuit/latch-up, collector-side optimisation, or 10–40 kV scaling. It distils Ioannis Almpanis, *Silicon Carbide (SiC) Insulated Gate Bipolar Transistors (IGBTs) for High Voltage Applications*, PhD thesis, University of Nottingham, April 2024.

## Evidence boundary

The thesis used Synopsys Sentaurus (`SPROCESS` and `SDEVICE`), not Silvaco Atlas/Athena. Treat its physical relationships, experimental-validation order, device/circuit cases, and reported fitted values as `thesis-derived research evidence`. Do not translate Sentaurus keywords or parameter-file coefficients directly into Atlas syntax. For Atlas:

1. select the nearest documented Atlas equation and command family;
2. verify coefficient convention, units, carrier ordering, orientation, and temperature law;
3. label transferred numbers `literature-start` until reproduced and calibrated;
4. use installed-version `MODELS ... PRINT`, manual equations, and local Atlas examples for syntax/default authority.

The thesis mainly models the active cell. Its active-cell breakdown normally overestimates die breakdown and underestimates leakage when termination and surface leakage are absent. Do not claim die-level BV, leakage, yield, or reliability from an active-cell-only deck.

## Research-grade calibration ladder

The most reusable result is the order used to prevent compensating errors. Keep independent datasets and do not tune all parameters at once.

| Stage | Test condition and observable | Determine first | Hold back |
| --- | --- | --- | --- |
| 1. Process/geometry | section or process data | drift/buffer/collector geometry, channel/JFET dimensions, oxide, p-well profile | electrical fitting |
| 2. Low-`Vce` transfer | low collector bias so conductivity modulation is weak | p-well surface doping, oxide thickness, gate work function/fixed charge from `Vth` | lifetime and buffer fitting |
| 3. Subthreshold/weak inversion | same transfer dataset | energy-resolved acceptor-like interface traps from slope/curvature | strong-inversion mobility |
| 4. Strong inversion | upper transfer curve | channel electron mobility and process degradation | high-injection lifetime |
| 5. Output/high injection | several `Vge`, sufficient `Vce` for plasma injection | electron/hole lifetime and uncertain channel/JFET dimensions | buffer switching fit |
| 6. Inductive turn-off at room temperature | measured `Ic(t)`, `Vc(t)`, punch-through transition and tail | drift thickness/doping, buffer/CSL thickness and doping, hole saturation velocity | temperature extrapolation |
| 7. Multi-temperature repetition | transfer, output and turn-off at elevated temperature | mobility, activation and lifetime temperature exponents; separate parameters that fit the same room-temperature curve | breakdown tuning |
| 8. Blocking/BV | leakage and breakdown versus temperature | impact law/orientation and termination after prior stages pass | retuning channel/lifetime to rescue BV |

For every stage save a clean common state and branch independently. Report which measurement constrains each parameter. A fit at one temperature or one characteristic is not a validated SiC IGBT model.

## Material and interface lessons

### Mobility and high-field velocity

- Use doping- and temperature-dependent bulk electron and hole mobility plus high-field saturation. Calibrate bulk and inversion-channel mobility independently.
- The thesis reduced fitted maximum electron and hole mobilities by about 10% relative to simpler material-test values to reproduce a fabricated IGBT. This is process-specific evidence, not a universal multiplier.
- The best-fit hole saturation velocity for one 27 kV device was `6e6 cm/s`. It influenced inductive turn-off/punch-through but not the on-state curve appreciably. In Atlas it is a `literature-start`; verify the `FLDMOB` hole equation and temperature exponent.
- Crystal anisotropy in mobility and avalanche must follow the device-to-crystal coordinate map, not the drawing axes.

### Incomplete ionisation

- Explicitly model donor and especially aluminium acceptor activation over temperature and chemical doping.
- The thesis example found roughly 83% activation for a `5e17 cm-3` nitrogen buffer and about 4% for a `1e19 cm-3` aluminium collector at 300 K under its chosen model. These are model outcomes, not fixed material constants.
- In short-circuit extrapolation, increased activation contributes to early current growth. Plot the ionised fraction and check physical bounds outside the validated range.

### Lifetime and recombination

- Use SRH with doping and temperature dependence and Auger recombination for high injection. Drift and buffer operate in different injection regimes; one apparent lifetime does not validate both.
- Lifetime controls conductivity modulation, `Vce(sat)`, stored charge, tail current, internal PNP gain, short-circuit current, and thermal feedback. It is `must-calibrate` for an IGBT.
- The thesis used `tau_n/tau_p = 5` in its validated family and a representative fitted electron maximum lifetime near `1.5–1.8 us`. These are experiment-specific starts, not Atlas defaults.
- Preserve the distinction between chemical-doping dependence, temperature dependence, injection-dependent effective lifetime, and deliberate lifetime-control processing.

### SiC/SiO2 electrostatics

- Separate fixed charge, interface-trap spectrum, and inversion mobility. They affect overlapping portions of `Ic–Vge` but are not interchangeable knobs.
- In the cited fit, positive fixed charge near `4.7e12 cm-2` reproduced threshold position, while an acceptor-like uniform trap distribution near `8e12 cm-2 eV-1` over `Ec-0.1 eV < E < Ec` reproduced the low-gate-voltage slope. Treat both as process-specific `literature-start` values.
- Near-conduction-band traps became mostly occupied at strong positive gate bias in that case, so their effect on strong on-state current was smaller than on subthreshold/weak inversion.
- Do not use Atlas `INTDEFECTS` generically. Use only an installed-release-supported SiC interface formulation with documented energy reference, distribution, sign, and capture cross-sections.

## Structure and mesh implications

- A process simulator was chosen because aluminium implant lateral straggle changes p-well and channel geometry. Use Athena only when that history matters; otherwise reproduce a measured profile directly in Atlas and label it imported/calibrated geometry.
- Refine SiC/SiO2 interfaces, doping gradients, channel/JFET constriction, p-well/n-drift junction, drift/buffer transition, buffer/collector junction, current crowding, field peaks, and thermal hot spots. A uniformly dense drift mesh adds cost without necessarily adding accuracy.
- A planar PT/asymmetrical IGBT uses the buffer to prevent reach-through and reduce required drift thickness. Check both avalanche and reach-through.

Thesis study points for drift-region scaling:

| Nominal BV | Drift thickness | Drift chemical doping | Status |
| ---: | ---: | ---: | --- |
| 13 kV | 100 um | `3e14 cm-3` | literature/device study point |
| 20 kV | 160 um | `1.75e14 cm-3` | literature/device study point |
| 27 kV | 210 um | `1.3e14 cm-3` | experimentally anchored study point |
| 30 kV | 260 um | `1.5e14 cm-3` | thesis prediction |
| 40 kV | 360 um | `1.25e14 cm-3` | thesis prediction |

Do not interpolate this table blindly. Recalculate ionised charge, termination, avalanche integral, punch-through margin, temperature, thickness tolerance, and mesh convergence for the intended wafer and Atlas impact model.

## False turn-on during inductive turn-off

The thesis attributes the positive gate spike to collector-to-gate capacitive coupling during the fast collector-voltage rise after punch-through. Evaluate the coupled device/circuit state rather than a DC transfer curve alone.

Required evidence:

- `Vge(t)`, `Vce(t)`, total/electron/hole emitter current, `dVce/dt`, and channel electron-current maps;
- explicit external `Rg`, negative off-state gate bias, common-emitter/source inductance, and bridge-leg configuration;
- nonlinear voltage-dependent `Cgc` and geometry-dependent `Cge`, not only a fixed Miller capacitance;
- a declared false-turn-on criterion: `Vge` crossing the calibrated dynamic threshold plus observable channel electron injection.

Design trends to reproduce:

- lower `Rg` and larger `Cge` reduce the induced spike, subject to driver loss and switching trade-offs;
- co-adjust gate-oxide thickness and p-well surface doping to change capacitance without unintentionally changing `Vth`;
- channel overlap, JFET width and intermetal oxide thickness alter `Cge`; keep cell pitch constraints explicit;
- negative gate bias improves margin but is a circuit assumption, not a substitute for device robustness;
- sweep current density and temperature.

The demonstrated percentage improvements belong to the specific 10 kV cell and circuit. Reproduce them before reuse.

## Short-circuit and latch-up state machine

Use transient electrothermal simulation with electron and hole transport. The thesis divides the short-circuit response into three regimes:

1. Initial saturation/current rise: increasing activation and lifetime strengthen conductivity modulation.
2. Mobility-limited decline after strong heating: scattering reduces mobility.
3. High-temperature positive feedback: lower `Vth`, lower PN built-in potential, greater leakage/generation and increasing parasitic transistor gains lead to thyristor latch-up or thermal destruction.

Latch-up must be diagnosed by the parasitic PNP–NPN current path. The p-well voltage drop scales with hole current and lateral base resistance; raising deep p-well doping or reducing n++ emitter width can reduce this resistance and increase margin. A sharp terminal-current rise or solver failure alone is not evidence.

Required outputs:

- `Ic(t)`, `Vge(t)`, `Vce(t)`, and gate command;
- electron/hole/total current-density maps through channel, p-well and collector path;
- lattice-temperature maps and moving hot-spot coordinate;
- p-well voltage drop, PN built-in-potential proxy, generation/recombination, and impact generation if active;
- semiconductor maximum temperature, emitter-metal temperature and gate-oxide temperature/stress proxy;
- event-clearing time and post-turn-off leakage for hundreds of microseconds when thermal runaway remains possible.

Failure can occur after gate turn-off because hot blocking-state leakage sustains feedback. A simulation ending at the gate falling edge is incomplete.

### Thesis short-circuit case for sensitivity reproduction

One 10 kV study used `Vdc=5 kV`, `Vge=15 V`, `Rg=7.5 ohm`, `Ls=100 nH`, emitter inductance `10 nH`, collector-side initial temperature `373 K`, and areal thermal resistance `0.034 K cm2/W` (`G approximately 29.4 W/(cm2 K)`). These define one experiment, not defaults.

Observed trends to reproduce, not assume:

- higher DC-bus voltage shortens SCWT and can trigger latch-up at lower peak temperature;
- lower gate voltage lowers fault current and extends SCWT;
- gate resistance and stray inductance mainly affect the early transient in the studied range;
- shorter channel/wider JFET at fixed pitch increases fault current and reduces robustness;
- higher buffer doping improves on-state injection but reduces SCWT;
- higher deep p-well doping and narrower n++ emitter reduce base resistance and improve latch-up margin;
- backside heat-transfer changes may have little effect during a very fast pulse, but demonstrate this before generalising;
- aluminium metallisation can melt near `933 K`; other metals and stack eutectics require their own limits. A semiconductor temperature near 1500 K is not a universal destruction criterion.

Material models above roughly 600 K were extrapolated in the thesis. Label any 600–1500 K prediction `extrapolated`; provide bounded alternative laws and sensitivity bands.

## Collector-side optimisation

Conventional buffer doping/thickness strongly couples `Von`, `Eoff`, punch-through and maximum `dV/dt`. Optimise the three-objective surface `Von–Eoff–max(dV/dt)` and include SCWT/noise margin as constraints.

The proposed four-step collector-side profile separates functions:

| Layer | Primary function |
| --- | --- |
| LDD: lower-doped drift | blocking voltage and main depletion support |
| HDD: higher-doped drift near collector | delays depletion reaching the buffer and controls fast `dV/dt` |
| LDB: lower-doped buffer | controls plasma injection and `Von–Eoff` trade-off |
| HDB: higher-doped buffer next to p+ collector | supplies reach-through blocking charge |

When testing this structure in Atlas:

1. use separate regions or a continuous doping profile with explicit interfaces;
2. refine all four transitions and verify electric-field slope changes are physical;
3. hold voltage rating, cell pitch, collector injection, circuit and normalization constant;
4. sweep HDD and LDB independently, then revalidate BV, `Von`, `Eoff`, maximum `dV/dt`, false turn-on and SCWT;
5. report manufacturability assumptions and dopant-profile tolerances.

The reported large `dV/dt` reductions remain thesis results until reproduced.

## Voltage-class and application constraints

- Compare switching at a declared fraction of BV; the thesis used `Vdc=0.6*BV` in its voltage-class study.
- Normalize current to active area and state whether termination/dead area is excluded.
- The thesis used a `300 W/cm2` packaging heat-removal limit to define study currents. This is an application constraint, not a material limit or Atlas boundary.
- Thick high-voltage drift layers reduce current density and increase termination area; die current also needs active-area fraction, termination width, yield and cooling assumptions.
- Positive temperature coefficient of `Vce(sat)` is required for stable parallel sharing. Co-adjust lifetime and emitter/collector injection for each voltage class.

## Minimum reusable study matrix

For a new Atlas SiC IGBT, branch from common conditioned states and run:

1. low-`Vce` transfer at several temperatures;
2. output curves at several `Vge` and pulse widths;
3. capacitance or charge validation for `Cge/Cgc/Cce` versus bias;
4. current-defined blocking/BV with termination and active-cell comparison;
5. inductive turn-off over current density, bus voltage, `Rg`, temperature and stray inductance;
6. false-turn-on bridge-leg test with channel-current confirmation;
7. short-circuit transient through and beyond turn-off with electrothermal maps;
8. mesh, timestep, precision, thermal-boundary and high-temperature-model sensitivity;
9. multi-objective `Von–Eoff–dV/dt–SCWT` comparison with identical normalization.

Label every result experimentally validated, interpolated inside the validation envelope, or extrapolated outside it.

## Sentaurus appendix values: translation warning

The appendix enabled Fermi statistics, doping/temperature-dependent SRH, Auger, Okuto–Crowell avalanche, anisotropic mobility/avalanche, high-field saturation, incomplete ionisation, thermodynamic heat flow, fixed charge, and near-conduction-band electron traps. Do not paste its coefficients into Atlas.

| Thesis physics | Atlas family to verify |
| --- | --- |
| Fermi statistics/effective intrinsic density | `FERMI`, `BGN`, material DOS/bandgap parameters |
| doping/temperature mobility and saturation | `ANALYTIC` or verified SiC mobility, `FLDMOB`, `MOBILITY` anisotropy |
| incomplete ionisation | `INCOMPLETE` plus species-appropriate activation parameters |
| SRH/Auger | `SRH`/`CONSRH`, `AUGER` with calibrated lifetime laws |
| anisotropic avalanche | verified `IMPACT ANISO` 4H-SiC form/orientation |
| thermodynamic heat flow | `LAT.TEMP`, heat-source selection, heat capacity/conductivity and `THERMCONTACT` |
| fixed/interface charge | `INTERFACE QF` and release-supported energy-resolved SiC interface traps |

Record the exact Atlas equation next to every translated coefficient. If equivalence cannot be shown, retain the number only as a sensitivity-range clue.

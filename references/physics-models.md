# Physical models for SiC power devices

## Selection principle

Enable the smallest physically sufficient model set, calibrate it, then add complexity one mechanism at a time. A model keyword and its coefficient set are inseparable.

## MODELS

```atlas
models srh fermi fldmob print temperature=300
```

- `SRH`: trap-assisted recombination/generation; controls lifetime-related leakage and stored charge.
- `FERMI`: Fermi–Dirac statistics; relevant in highly doped regions.
- Field-dependent mobility: limits drift velocity at high field.
- Doping-dependent mobility: captures impurity scattering.
- Incomplete ionization: important for SiC dopants; verify exact release keyword and activation-energy parameters.
- Bandgap narrowing: do not enable by silicon habit; justify and calibrate for the SiC regime.
- Lattice self-heating: solves heat flow coupled to electrical transport; requires thermal material data and `THERMCONTACT`.

Use `PRINT` to expose enabled models and parameter values in runtime output.

## MOBILITY

```atlas
mobility <low-field/doping/field/temperature coefficients>
```

Mobility determines on-resistance, channel current, JFET resistance, and temperature dependence. Bulk drift mobility and SiC MOS channel mobility are not the same calibration problem. Interface scattering/traps can dominate the channel.

Common mistake: fitting the entire MOSFET with one bulk mobility multiplier, which hides errors in interface charge, channel mobility, geometry, and contact resistance.

## Recombination and lifetime

SRH rate depends on electron/hole lifetimes, trap energy, statistics, and carrier densities. Auger recombination can matter at high injection. Radiative recombination is generally not the principal mechanism for ordinary SiC power switching but may be part of a complete high-injection model.

Calibrate lifetime using appropriate reverse recovery, carrier-lifetime, or bipolar-conduction data; leakage alone is often non-unique.

## IMPACT ionization

```atlas
impact <model-name> <electron-coefficients> <hole-coefficients>
```

Impact ionization produces avalanche generation. Coefficients depend on the selected law and may be direction- and temperature-dependent in 4H-SiC. Never paste coefficients from another formula. Resolve the peak-field region and state the breakdown definition, such as a current threshold or slope criterion.

Common mistakes:

- Enabling avalanche only after the voltage sweep was already generated.
- Coarse termination/corner mesh that changes breakdown voltage.
- Treating solver divergence as physical breakdown.
- Using a one-dimensional coefficient set for a differently oriented field.

## TRAP and interface defects

```atlas
trap acceptor e.level=<eV> density=<cm-3> sign=<cm2> sigp=<cm2> degeneracy=<n>
trap donor    e.level=<eV> density=<cm-3> sign=<cm2> sigp=<cm2>
```

Key parameters describe trap type, energy level/reference, density, degeneracy, and electron/hole capture cross-sections. Confirm whether energy is referenced to a band edge or intrinsic level in the chosen statement.

Traps affect charge, recombination-generation, transient capture/emission, leakage, threshold shift, and dynamic on-resistance. Use interface-specific statements for interface-state distributions.

## Self-heating

Self-heating requires:

1. lattice heat equation/model;
2. temperature-dependent electrical properties;
3. thermal conductivity and heat capacity;
4. thermal contacts or resistance;
5. a transient or steady-state condition consistent with the experiment.

Check energy conservation and peak-temperature mesh convergence. A fixed-temperature sweep only represents externally imposed temperature.


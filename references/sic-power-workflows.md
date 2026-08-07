# SiC power-device research workflows

## Universal calibration ladder

1. Material and equilibrium: band alignment, activation, carrier density.
2. Low-field transport: Hall/bulk mobility versus doping and temperature.
3. Contacts: ohmic resistance or Schottky barrier over temperature.
4. Recombination/traps: lifetime, leakage, transient response.
5. High-field transport and avalanche.
6. Electrothermal behavior.
7. Full-device validation against data not used in fitting.

Keep a parameter provenance table: parameter, equation/model, value, unit, orientation, temperature range, source, fitted dataset, uncertainty.

## Schottky/JBS diode

- Build drift layer, substrate, Schottky metal, guard/JBS p regions, and termination.
- Refine Schottky edge, p-n junctions, and surface termination.
- Calibrate work function/barrier and contact resistance with forward I-V(T).
- Calibrate leakage mechanisms with reverse I-V(T); do not force all leakage into barrier height.
- Add impact ionization for breakdown and verify peak-field location.
- Extract forward drop, differential/specific resistance, leakage, and breakdown criterion.

## PiN/MPS diode

- Include incomplete ionization and high-injection transport as justified.
- Calibrate SRH lifetime before reverse recovery.
- Verify conductivity modulation through carrier profiles.
- For switching, include an external circuit and realistic parasitics.
- Report stored charge and reverse-recovery integration bounds.

## Planar/trench SiC MOSFET

- Resolve oxide and channel-normal mesh, JFET neck, body diode, drift layer, and termination.
- Separate channel mobility, bulk mobility, contact resistance, and drift resistance.
- Calibrate fixed charge/interface traps to C-V and transfer characteristics.
- Validate output curves before breakdown.
- For trench devices refine corners and check oxide electric field.
- Add electrothermal coupling for high-current operation.

## Breakdown study

- Start from a stable equilibrium/low-voltage state.
- Ramp coarsely at low field and progressively reduce step size near current rise.
- Save spatial states before, during, and after the onset.
- Track terminal current, maximum field, ionization rate, and lattice temperature.
- Repeat with finer mesh and smaller steps.
- Confirm breakdown occurs in the intended active/termination region rather than a numerical corner.

## Publishable result checklist

- Atlas version/module and 2D/3D stated.
- Polytype and crystal orientation stated.
- Geometry, width/area normalization, and boundary conditions stated.
- Models and coefficient sources stated.
- Calibration and independent validation datasets separated.
- Mesh and bias-step convergence quantified.
- Extraction definitions and temperature stated.


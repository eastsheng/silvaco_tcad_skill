# Local Example Adaptation Checklist

Use this checklist when adapting local Silvaco examples from a discovered or user-provided examples directory such as `<SILVACO_EXAMPLES_DIR>` into a new SiC power-device research deck.

## Before Reusing an Example

- Confirm the original device: SBD, JBS, PiN, MOSFET, JFET, BJT, or process/implant example.
- Confirm material polytype: `4H-SiC`, `3C-SiC`, `6H-SiC`, silicon, GaN, or another material.
- Confirm dimensionality: 1D/2D/3D, cylindrical symmetry, layout-derived, or structure-file based.
- Confirm target quantity: breakdown voltage, on-resistance, threshold voltage, leakage, DLTS signal, capacitance, temperature rise, or electric field.
- Confirm whether the example is Atlas electrical simulation or Athena/process preprocessing.

## Parameters That Must Be Revalidated for Research

- 4H-SiC material parameters: affinity, bandgap, permittivity, carrier lifetime, intrinsic density handling.
- Mobility: low-field mobility, field saturation, channel mobility degradation, anisotropy angle, temperature dependence.
- Impact ionization: anisotropic model, orientation, coefficients, and breakdown criterion.
- Dopant ionization: incomplete ionization parameters for nitrogen, aluminum, boron, or other dopants.
- Contacts: Schottky work function, ohmic assumption, series/contact resistance, thermionic emission assumptions.
- Interface: fixed charge, interface trap energy distribution, density, capture cross sections.
- Thermal: lattice temperature, heat equation, thermal contacts, thermal conductivity, self-heating boundary conditions.
- Mesh: refinement around junction curvature, Schottky edge, trench corner, oxide corner, termination, and peak-field regions.

## Good Example-to-Research Transfer

- Copy the deck structure, not the calibration.
- Preserve the command order: mesh/structure, regions, electrodes, doping, material/contact/interface, models, method, solve, log/save/extract.
- Keep local example comments that document intent, but rewrite comments that imply measured agreement unless using the same calibration context.
- Run a mesh convergence study for breakdown and on-resistance.
- Run a bias-step convergence study for avalanche and snapback-like behavior.
- Save intermediate structures at equilibrium, operating point, and failure/breakdown point.

## Common Transfer Mistakes

- Moving a silicon `power` or `diode` example to SiC by only changing `material=Silicon` to `material=4H-SiC`.
- Keeping silicon mobility, lifetime, intrinsic density, or impact-ionization settings.
- Using 3C-SiC or 6H-SiC examples as if they were calibrated 4H-SiC examples.
- Forgetting that local examples may be demonstration decks, not publication-ready calibrated models.
- Comparing simulated and measured I-V curves without matching area normalization and electrode definitions.
- Letting electrode names drift between `electrode`, `contact`, `solve`, `log`, and `extract`.




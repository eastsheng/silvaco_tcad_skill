# Rules Derived from Installed Silvaco Decks

Use this reference when creating, adapting, or reviewing a deck from locally installed examples. These are vendor-example patterns observed in `D:\softwares\sedatools\examples\deckbuild\4.2.2.R` and `4.2.5.R`; they are not universal Atlas requirements or transferable calibration values.

## Evidence discipline

For every borrowed fragment, record: example ID and path, example release, simulator/module, device and polytype, dimensionality, target curve, copied statements, deliberately replaced parameters, and missing support files. Prefer the newest physically present deck, but use an older installed release when the newer index has no payload. Never claim a deck was run merely because it exists.

## High-voltage continuation

`sicex01`, `sicex07`, `sicex10`, `sicex11`, and `sicex14` consistently avoid a single large reverse-bias step:

1. Solve equilibrium and one or more small biases.
2. Increase the voltage step in stages through the low-field region.
3. Reduce the step near the expected knee when resolution is needed.
4. Where avalanche continuation is required, use voltage compliance, change the terminal to current control, then ramp current geometrically (`imult`).
5. Save a pre-breakdown and final spatial solution and inspect electric field plus impact generation before extracting breakdown.

This is a continuation strategy, not a breakdown definition. State the independent criterion (for example a current-density threshold) and test bias-step and mesh sensitivity. Do not copy example compliance currents without reconciling `mesh width`, physical cell area, and current normalization.

## Precision is an experiment variable

The decks use `simflags="-80"`, `-128`, or `-160` for wide-bandgap off-state work. `sicex01` holds structure, physics, and bias trajectory fixed while comparing precision and extracts `clock.time`. Follow that controlled-comparison pattern when diagnosing precision. Select the lowest precision that gives stable observables and resolved leakage for the task; extended precision cannot repair bad geometry, mesh, or physics.

Never copy the artificial `NI.MIN` values used in the lower-precision branches of `sicex01` as physical 4H-SiC calibration. They are numerical comparison devices and change the leakage floor.

## Two-dimensional current normalization

`sicex07` and `sicex14` use very large `mesh width` values to map a two-dimensional slice to the current or current density used by a cited device. Treat `width` as part of the measurement definition:

- derive it from cell pitch, active area, symmetry, and desired current unit;
- document the conversion explicitly;
- keep it fixed when comparing structures; and
- convert current-based compliance and extraction thresholds consistently.

An I-V match with an undocumented width is not a validated calibration.

## MOSFET sequencing and interface separation

`sicex07` reinitializes before each gate-conditioned output curve instead of continuing from the preceding curve. Recreate each curve from equilibrium or a named saved state, ramp the gate to its target, and only then sweep the drain.

For SiC/oxide behavior, separate these calibration layers:

1. gate work function and oxide thickness;
2. fixed interface charge;
3. donor/acceptor interface-state distribution and capture parameters;
4. bulk and inversion-layer mobility; and
5. series, contact, drift, and JFET-region resistance.

`sicex13` disables individual `ALTCVT` scattering components (`COULOMB`, surface roughness, surface phonon) and probes interfacial field and electron mobility. Use the same one-factor-at-a-time structure for mechanism attribution, but verify caret-negation syntax and model availability in the installed release.

## Orientation and dimensionality

`sicex02` enables anisotropic mobility with a second `MOBILITY` statement carrying `N.ANGLE=90`/`P.ANGLE=90`. Breakdown decks use anisotropic impact forms, and `sicex11` distinguishes 2D orientation keywords from a 3D material-coordinate definition. Therefore record crystal axis relative to simulation axes and device surface; do not transplant a 2D orientation keyword into 3D without mapping the coordinates.

Use `sicex03` only as a 3C-SiC structural/mobility example. Use `sicex04`-`06` as process/implant examples, not Atlas electrical calibrations.

## Schottky and JBS controls

`sicex14` changes geometry and impact coefficients between its SBD and JBS branches and ties split JBS anodes with `COMMON`. When comparing SBD and JBS:

- keep active width and terminal convention equivalent;
- confirm all split metal segments are electrically common;
- isolate the effect of P+ shielding geometry from changes in material/model coefficients;
- treat metal work function, surface recombination/barrier options, and effective measured barrier as distinct quantities; and
- do not describe vendor-example measured agreement as validation of a modified device.

## Transient trap/DLTS rules

`sicex12` uses a DeckBuild temperature loop, rebuilds/solves each temperature point, saves the charged state, reloads it with `MASTER`, applies timed voltage pulses, and extracts capacitance at two specified times. For DLTS adaptation, keep temperature, trap energy/density/cross-sections, AC frequency, fill pulse, emission window, transient time-step limits, and capacitance sign convention in one documented experiment definition.

Do not replace this with a DC sweep or reuse a saved state from a different temperature.

## Minimum review report

Return three separate verdicts:

- **Syntax/version:** statements and support files are valid for the installed simulator and release.
- **Numerics:** equilibrium, continuation, mesh, step, tolerance, and precision studies are adequate.
- **Physics/calibration:** material, orientation, interfaces, contacts, traps, temperature, normalization, and validation data support the claim.

Passing one verdict does not imply the others.

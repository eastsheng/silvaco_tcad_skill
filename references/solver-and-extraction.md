# Numerical method, biasing, and extraction

For restart invariants, branch-independent conditioning, and failure classification, also read `atlas-numerics-and-bias-state-machine.md`.
For exact metric contracts and DeckBuild variable/range behavior, read `deckbuild-extract-and-sweeps.md`. For visual and spatial result audits, read `tonyplot-quantitative-audit.md`.

## Initialization and method

```atlas
method newton trap maxtrap=<n> autonr
solve init
```

`METHOD` controls nonlinear iteration, linear solution, convergence tolerances, iteration limits, damping/trapping, time integration, and equation coupling. Exact options vary by release.

- Gummel: robust decoupled initialization for some equilibrium/low-bias problems.
- Newton: fast coupled convergence near a good initial guess.
- Block: useful for selected coupled systems such as electrothermal or optical problems.
- Trap/cutback: reduces a failed bias or time step; it does not repair a wrong physical deck.

## DC ramp

```atlas
solve init
solve vgate=0
solve vdrain=0.1
log outf="transfer.log"
solve name=gate vgate=0 vstep=0.25 vfinal=15
log off
```

For breakdown:

```atlas
solve init
solve name=anode vanode=0
log outf="reverse.log"
solve name=anode vanode=-1 vstep=-1 vfinal=-50
solve name=anode vstep=-10 vfinal=<target>
```

Use smaller steps near abrupt current, field, temperature, or charge changes. Save intermediate states and restart from the closest converged solution.

## LOG, SAVE, LOAD, OUTPUT

- `LOG OUTF=<file>`: terminal I-V and related sweep data.
- `SAVE OUTF=<file>`: spatial structure/solution at the current state.
- `LOAD INFILE=<file>`: restore a compatible saved state.
- `OUTPUT <quantities>`: request additional spatial quantities for saved output.

Do not confuse a log file with a spatial solution file.
For `LAT.TEMP`, reissue `THERMCONTACT` after a restart; the Atlas 2018 manual states thermal contacts are not stored in solution files.

## Extraction

Use DeckBuild `EXTRACT` on the intended log or structure file. Define all criteria:

- breakdown voltage: current density/current threshold or derivative criterion;
- threshold voltage: constant-current, transconductance extrapolation, or another declared method;
- specific on-resistance: voltage range, area normalization, and contact resistance treatment;
- leakage: voltage and temperature;
- peak field/temperature: saved bias point and spatial domain;
- switching metrics: circuit, parasitics, time window, and integration definition.

Also declare the search or fit bounds, units, 2D width/area normalization, valid result range, multiple-crossing behavior, and an explicit results filename. Request every non-default spatial field with `OUTPUT` before saving the Atlas structure used by Extract or TonyPlot; Atlas `OUTPUT` keywords and Extract quantity names are not interchangeable.

## Convergence diagnosis

1. Confirm geometry, net doping, contacts, and equilibrium first.
2. Disable newly added complex physics and re-enable one model at a time.
3. Reduce bias/time step and load the nearest solution.
4. Inspect where residuals and fields concentrate.
5. Refine only physically important regions with smooth transitions.
6. Scale equations/tolerances only after verifying units and parameters.
7. Distinguish avalanche current growth from numerical failure.

Never delete a hard point from a curve without explaining the failed convergence region.


# TonyPlot Quantitative Audit and Reproducible Output

Read this when inspecting structures, comparing meshes/curves, locating field or thermal hot spots, or producing repeatable figures.

## Reproducible command patterns

```text
tonyplot <structure_or_log>
tonyplot -overlay <curve1.log> <curve2.log>
tonyplot <file> -set <plot.setx>
tonyplot <file> -set <plot.setx> -png <output.png> -geom <width>x<height>
```

In the 2018 manual, `-png`/`-jpg` render plots and normally exit; `-noexit` keeps TonyPlot open. `-set` applies to the files preceding it, not later files. For multiple plots, pair each input with its own `.setx` as required.

## Structure and mesh audit

For every Athena/DevEdit/Atlas structure inspect:

- material boundaries and region IDs;
- electrode labels/connectivity;
- mesh at gate oxide, junctions, trench corners, termination edges and thermal contacts;
- chemical/net/active doping where available;
- potential, field magnitude/components, current-density components, impact generation and lattice temperature at the exact saved bias;
- cell width/depth and coordinate orientation.

TonyPlot can reveal defects but does not establish mesh convergence. Compare numerical metrics across independently refined meshes.

## Cutline/cutplane contract

- Use keyboard-coordinate cutlines for repeatability; store start/end coordinates and source file.
- Use interface cutlines for along-interface quantities; they create one level per adjacent material, so identify which level is oxide and which is semiconductor.
- A cutline from an overlaid mesh produces an overlaid cross section. Keep identical coordinates and quantities across levels.
- A 3D cutplane must record plane, absolute position or three points, vector projection choice and export file.
- Never compare two cutlines that silently moved with geometry or surface displacement; define them relative to verified physical landmarks or extract the landmark first.

## Overlay contract

Overlay only comparable data:

| Item | Must match or be explicitly transformed |
| --- | --- |
| electrical curves | terminal convention, bias history, temperature, geometry, width/area normalization |
| spatial maps | coordinate system, dimensionality, material/region, saved bias and quantity definition |
| thermal maps | ambient, boundary resistance, time/steady state and temperature scale |
| measured data | units, sign, area normalization, series resistance and temperature |

Record input order because overlay levels follow loaded data. Use stable level names, axis limits and linear/log scale. Do not allow autoscaling to exaggerate or hide differences.

## Probe, marker and integration use

- A visual marker/probe is exploratory unless its coordinate and source state are recorded.
- Use DeckBuild `EXTRACT` or exported numeric data for reported scalar claims whenever possible.
- For integrated current, charge, generation or heat, state path/area, dimensional normalization, sign convention and units. Cross-check terminal conservation or power balance.
- Document every TonyPlot function/transform formula; transformed curves are not raw simulator outputs.

## Figure artifact manifest

For each exported plot retain:

```text
source file(s)
simulator/version and saved state
TonyPlot version
setx file(s)
overlay input order
cutline/cutplane coordinates
displayed quantity and transform
axis limits/scales and units
image format and pixel geometry
```

The `.setx` file and PNG are both required for a reproducible figure; neither replaces the underlying numeric log/structure.


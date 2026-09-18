# Athena Mesh, Deposition, and Etch

Read this for process-mesh design and complex geometry construction. The rules are derived from Chapters 2, 4 and 6 of the Athena 2015 manual.

## Mesh by future events

Place initial `LINE X/Y` from the complete future process, not only the starting wafer:

- `LINE X` at mask edges, gate/trench edges, implant window edges and final electrode separations;
- `LINE Y` at the surface, expected implant peaks/junctions, oxide interfaces, trench bottom and substrate/epi transitions;
- use smooth spacing transitions and keep fine mesh local;
- begin in 1D where laterally uniform and allow the first lateral operation to trigger 2D;
- retain enough nodes in deposited films for later transport, etch shape and device electrostatics.

An adaptive mesh is optional module behavior, not proof of adequacy. Preserve interfaces, dose and junctions across every adapt/smooth/relax step. `RELAX` refuses changes that create obtuse triangles and is most reliable on `LINE`-built meshes; use DevEdit for other structures when necessary.

## Deposition contract

```atlas
deposit oxide thickness=<um> divisions=<n>
deposit polysilicon thickness=<um> divisions=<n> c.<dopant>=<cm-3>
```

- Without Elite, deposition is 100% conformal.
- `THICKNESS` is in micrometres.
- `DIVISIONS` defaults to 1 in the 2015 manual and usually must be increased. Athena may increase it to preserve grid integrity; capture runtime output.
- `DY`, `YDY`, `MIN.DY`, and `MIN.SPACE` control film discretization; they are mesh settings, not physical deposition calibration.
- `C.<impurity>` sets bottom concentration and paired `F.<impurity>` sets a linear grade to the top.
- Use several layers through gate oxide, barriers and spacer films; verify the saved physical thickness after later process steps.

For a nonconformal profile, step coverage, void or physical etch/deposition, require a supported Elite model or replace it with explicitly labeled calibrated geometry. Do not claim conformal `DEPOSIT` predicts a real CVD/PVD profile.

## Etch contract

Athena separates framework geometric etch from Elite physical etch:

- `ALL` removes the selected material;
- `DRY THICKNESS=<um>` lowers the exposed surface; `ANGLE` defaults to a vertical 90-degree wall and `UNDERCUT` defaults to zero in this manual;
- `LEFT/RIGHT/ABOVE/BELOW` with P1/P2 defines a trapezoidal half-plane;
- `START/CONTINUE/DONE X/Y` defines a polygon;
- `INFILE` imports a closed profile from coordinate pairs;
- `TOP.LAYER` limits removal to the top occurrence of the material;
- `NOEXPOSE` prevents a newly cut bottom/side surface from becoming an exposed process surface.

After each complex etch, save a checkpoint and measure trench width/depth, sidewall angle, bottom shape, remaining masks, exposed boundaries and triangle quality. A polygon encodes a target geometry, not calibrated plasma physics.

## Oxidation mesh safeguards

Set oxide model and grid controls before the oxidizing `DIFFUSE` step. The 2015 manual documents `GRID.OXIDE` and `GRIDINIT.OX` on `METHOD`, while `OXIDE INITIAL=<um>` controls native oxide insertion. Complex exposed surfaces can fail during automatic native-oxide deposition; use a deliberate initial oxide/deposit and inspect triple points.

For planar/trench power gates, extract oxide thickness separately at planar channel, sidewall, bottom and corners. Never infer equality from oxidation time alone.


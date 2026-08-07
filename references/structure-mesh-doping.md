# Structure, mesh, electrodes, and doping

## Mesh

```atlas
mesh space.mult=1.0
x.mesh location=0.0 spacing=0.10
x.mesh location=5.0 spacing=0.02
y.mesh location=0.0 spacing=0.01
y.mesh location=10.0 spacing=0.20
```

`LOCATION` is a coordinate in µm; `SPACING` is requested local spacing. Refine at SiC/oxide interfaces, Schottky edges, junction curvature, JFET constrictions, trench corners, termination rings, and high-field drift regions. Use gradual transitions and test mesh convergence.

## REGION

```atlas
region number=1 material=4H-SiC x.min=0 x.max=10 y.min=0 y.max=12
region number=2 material=SiO2 x.min=0 x.max=10 y.min=-0.05 y.max=0
```

Key parameters: `NUMBER`, `MATERIAL`, bounds, polygon/cylindrical geometry. A region maps cells to material equations.

## ELECTRODE

```atlas
electrode name=source x.min=0 x.max=3 y.min=0 y.max=0
electrode name=gate x.min=3 x.max=7 y.min=-0.05 y.max=-0.05
electrode name=drain bottom
```

Key parameters: `NAME`, bounds, boundary shortcut, optional region selection. `CONTACT` later assigns electrical behavior.

## DOPING

```atlas
doping uniform n.type concentration=8e15 region=1
doping uniform p.type concentration=1e18 x.min=0 x.max=3 y.min=0 y.max=1
doping gaussian n.type concentration=1e19 peak=0.05 char=0.10 x.min=0 x.max=3
doping infile="profile.dat"
```

Key parameters: donor/acceptor type, profile, `CONCENTRATION`, `REGION`, bounds, peak/junction/characteristic length, input file. In 4H-SiC, incomplete ionization can make free-carrier density differ from chemical dopant density.

## Mistakes

- Missing mesh lines at boundaries and junctions.
- Abrupt cell-size jumps in high-field regions.
- Inconsistent electrode names in `SOLVE`.
- Unchecked overlapping doping profiles.
- Unit confusion: geometry uses µm, concentration commonly cm⁻³.
- Comparing normalized 2D current directly with measured amperes.


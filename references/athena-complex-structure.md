# Athena Complex Structure Construction

Read this reference first when a device should be built from a fabrication sequence rather than direct Atlas regions. It summarizes patterns internalized from local Athena 4.2.5 examples, especially power-device, implant, oxidation, and calibration decks. The skill should now use these bundled rules first; revisit local examples only for an unsupported process/module or failed syntax.

## What Athena adds

Athena can construct geometry and doping through process history:

- nonuniform process mesh with `LINE X/Y`;
- initialized substrate orientation and background doping;
- multilayer deposition with controlled divisions/vertical mesh;
- geometric, directional, isotropic, RIE, and polygonal etching;
- photoresist/barrier masking;
- analytic, Pearson, SVDP, BCA, and Monte Carlo implants;
- implant tilt/rotation and trench-sidewall implantation;
- oxidation, diffusion, activation and damage annealing;
- mirrored half-cell construction;
- electrode assignment and backside contacts;
- structural extraction and handoff to DevEdit/Atlas.

Atlas has priority over Athena. Use Athena only when process shape/profile history matters and cannot be represented adequately by direct Atlas regions and analytic doping. DevEdit has lower priority than both and is used only for necessary remeshing or geometry cleanup. Do not route to Victory Process when Athena lacks a process model; instead state the unsupported physics, use a calibrated Atlas geometry/profile approximation where scientifically acceptable, or report that the requested process cannot be represented faithfully.

## Tool-selection gate

Before writing an Athena deck, answer:

1. Can Atlas regions and analytic/imported doping reproduce the required final geometry and profiles?
2. Does the requested conclusion depend on fabrication history rather than only the final structure?
3. Is Athena process physics available and calibrated for the material/process?

If Atlas is sufficient, stop at Atlas. If Athena is required, build there and hand directly to Atlas when its mesh is adequate. Invoke DevEdit only after demonstrating a specific mesh or geometry deficiency.

## Process-coordinate contract

Before commands, define:

- surface position and positive depth direction;
- simulated half/full cell and symmetry plane;
- substrate orientation and rotation;
- every mask edge, trench wall/bottom and intended corner radius;
- final terminal positions; and
- coordinates that must remain stable across Athena, DevEdit and Atlas.

Athena process coordinates can shift after deposition, oxidation and etch. Do not assume the original surface remains `y=0`. Extract or inspect the final structure before assigning device-simulation probes and thermal boundaries.

## Process mesh rules

Place `LINE X` near mask edges, gate edges, trench walls, body/source implant edges, guard-ring windows and electrode endpoints. Place `LINE Y` near the original surface, gate oxide, shallow junctions, trench bottom, epi interfaces, buffer/collector transition and backside.

Mesh must support the process operation as well as the final electrical solution:

- oxidation requires fine oxide/interface grid (`METHOD GRID.OX`/`GRIDINIT.OX` where supported);
- high-gradient implant/diffusion profiles need fine depth mesh;
- angled trench implants need sidewall and corner resolution;
- long drift layers can be coarse away from junctions;
- deposition `DIV`, `DY`, and `YDY` control layer discretization;
- use DevEdit after Athena when the process mesh is unsuitable for field/current/thermal convergence.

Never infer final electrical mesh adequacy from a visually smooth process plot.

## Geometry operations

### Layer stack

```atlas
deposit oxide thickness=<tox> divisions=<n>
deposit polysilicon thickness=<tpoly> divisions=<n>
deposit photoresist thickness=<tpr> divisions=<n>
deposit aluminum thickness=<tmetal> divisions=<n>
```

Use explicit vertical divisions for thin oxide/inter-poly layers. Check final physical thickness after oxidation or subsequent etch.

### Simple mask-edge etch

```atlas
etch photoresist left p1.x=<xedge>
etch oxide left p1.x=<xedge>
etch polysilicon right p1.x=<xedge>
etch oxide all
```

Order matters: remove only the intended mask/material. A later implant sees the current exposed surface and remaining stopping layers.

### Polygonal/nonrectangular etch

```atlas
etch silicon start x=<x1> y=<y1>
etch continue x=<x2> y=<y2>
etch continue x=<x3> y=<y3>
etch done x=<x4> y=<y4>
```

Use for trench tapers, recessed contacts, field-plate openings, bevels and complex windows. Verify polygon orientation and closure; save a checkpoint immediately afterward.

### Directional/isotropic spacer or rounded profile

```atlas
rate.etch machine=<id> rie oxide dir=<directional_rate> iso=<isotropic_rate> u.m
etch machine=<id> time=<seconds> second dt.max=<step>
```

Directional/isotropic proportions determine spacer footing and corner rounding. These rates are tool/process calibration parameters, not universal material etch rates.

### Mirror a half-cell

```atlas
structure mirror right
```

Use only when geometry, doping, implant rotation and intended terminal layout are symmetric. Inspect merged centerline nodes and duplicate electrodes after mirroring.

## Implant and diffusion

### Analytic implant

```atlas
implant boron dose=<cm-2> energy=<keV> pearson
implant arsenic dose=<cm-2> energy=<keV>
```

### Angled/crystal-aware implant

```atlas
implant <species> dose=<cm-2> energy=<keV> \
  tilt=<deg> rotation=<deg> crystal
```

### BCA/Monte Carlo implant

```atlas
implant <species> dose=<cm-2> energy=<keV> \
  tilt=<deg> rotation=<deg> bca n.ion=<particles>
```

For 4H-SiC aluminum implantation, define the correct material/orientation and use SiC-specific BCA/MC settings and activation data. A silicon implant model is not transferable by changing the substrate name.

### Anneal/oxidation

```atlas
method fermi compress
diffuse time=<min> temp=<C> nitro
diffuse time=<min> temp=<C> dryo2
diffuse time=<min> temp=<C> wet
```

Choose diffusion, activation, clustering/damage and oxidation models appropriate to material and process. SiC dopant diffusion/activation and oxidation differ radically from silicon; treat local SiC implant examples as profile syntax, not a full calibrated SiC MOS process.

## Complex structure patterns internalized

| Pattern | Athena construction logic | Key risk |
| --- | --- | --- |
| Vertical DMOS | substrate -> gate oxide/poly stack -> body implant/diffusion -> source implant -> contact opening -> metal -> backside drain | source/body short and gate overlap |
| LDMOS | sacrificial oxide -> gate oxide -> channel adjust -> poly gate -> drift implant -> source/drain implant -> metal | asymmetric drift mesh and field plate geometry |
| Guard rings/field plates | repeated oxide windows -> junction implant/diffusion -> repeated poly/metal plates -> named electrodes | ring spacing, floating/tied plates, edge mesh |
| Low-voltage power MOSFET | thin split deposition mesh -> self-aligned body/source implants -> metal -> DevEdit remesh | nanometer oxide mesh and current normalization |
| MPS/JBS-like diode | repeated masked tilted implants -> drive-in -> surface implant -> anode metal -> backside cathode | implant overlap, cell symmetry and Schottky/P+ area ratio |
| Superjunction/CoolMOS abstraction | process-built MOS top cell plus inserted alternating drift charge regions or process columns | charge balance; direct Atlas doping is not a process prediction |
| Trench MOS/IGBT | polygon trench -> orientation-aware oxidation -> gate fill -> body/source implants -> contacts | bottom radius, sidewall oxide and angled implant shadowing |
| Spacer | conformal deposition -> directional/isotropic calibrated etch | spacer width/footing and mesh loss |

## Extraction and checkpoints

Save after every high-risk irreversible stage:

```atlas
structure outfile=<stage_name>.str
```

Extract or measure:

- oxide thickness at channel, field and trench-sidewall/bottom locations;
- junction depths and lateral diffusion;
- peak/active concentration and dose conservation;
- trench width/depth/sidewall angle/bottom radius;
- spacer and field-plate dimensions;
- guard-ring spacing and junction curvature; and
- electrode-to-semiconductor/oxide connectivity.

Use `EXTRACT ... THICKNESS`, junction/profile curves, and TonyPlot inspection as appropriate. Geometry checkpoints are evidence; comments stating a target thickness are not.

## Electrode assignment and handoff

Assign electrodes only after final contact-opening and metal geometry:

```atlas
electrode name=source x=<point_on_source_metal>
electrode name=gate x=<point_on_gate> y=<point_on_gate>
electrode name=drain backside
structure outfile=<device>.str
```

Then optionally remesh:

```atlas
go devedit
init infile=<device>.str
<impurity/interface/local mesh constraints>
structure outfile=<device_remeshed>.str

go atlas
mesh infile=<device_remeshed>.str
```

After handoff, verify region/material IDs, electrode names and positions, net doping, oxide thickness, interface shape, cell width and backside orientation. Remeshing must not erase narrow layers, merge contacts or smooth critical corners unintentionally.

## Required process review output

Return:

1. chronological process table;
2. mask/etch/deposition geometry table;
3. implant/anneal table with model and calibration status;
4. checkpoint and extraction plan;
5. final region/electrode/connectivity audit;
6. Athena-to-device coordinate and mesh mapping; and
7. separate process-physics, geometry, electrical-mesh and device-model verdicts.

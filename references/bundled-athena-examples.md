# Bundled Athena Complex-Structure Examples

These templates are now the first source for process-built structures. Replace placeholders and validate material-specific process physics.

## Vertical power MOSFET/IGBT top-cell flow

```atlas
go athena

line x location=0 spacing=<symmetry_dx>
line x location=<gate_edge> spacing=<gate_dx>
line x location=<source_edge> spacing=<source_dx>
line x location=<half_pitch> spacing=<boundary_dx>
line y location=0 spacing=<surface_dy>
line y location=<body_depth> spacing=<junction_dy>
line y location=<epi_depth> spacing=<epi_dy>

init <substrate_material> orientation=<orientation> \
  c.<background_dopant>=<substrate_concentration>

deposit oxide thickness=<gate_oxide> divisions=<oxide_divisions>
deposit polysilicon thickness=<gate_poly> divisions=<poly_divisions>
deposit photoresist thickness=<mask_thickness> divisions=<mask_divisions>

etch photoresist <left_or_right> p1.x=<gate_mask_edge>
etch polysilicon <left_or_right> p1.x=<gate_mask_edge>

implant <body_species> dose=<body_dose> energy=<body_energy> <implant_model>
diffuse time=<body_drive_time> temp=<body_drive_temp> <ambient>

implant <source_species> dose=<source_dose> energy=<source_energy> <implant_model>
diffuse time=<source_anneal_time> temp=<source_anneal_temp> <ambient>

deposit oxide thickness=<ild_thickness> divisions=<n>
etch oxide start x=<x1> y=<y1>
etch continue x=<x2> y=<y2>
etch continue x=<x3> y=<y3>
etch done x=<x4> y=<y4>

deposit aluminum thickness=<metal_thickness> divisions=<n>
etch aluminum right p1.x=<source_gate_isolation_edge>

electrode name=emitter x=<emitter_metal_point>
electrode name=gate x=<gate_point> y=<gate_y>
electrode name=collector backside
structure outfile=power_cell_process.str
```

For an IGBT, the collector/buffer/field-stop stack must be present in the initialized/imported substrate or added by an appropriate epitaxy/process flow. Do not create a MOSFET drain backside and merely rename it collector.

## Polygon trench plus mirrored cell

```atlas
go athena
<process mesh and substrate initialization>

etch <semiconductor> start x=<wall_x> y=<surface_y>
etch continue x=<wall_x> y=<straight_bottom_start>
etch continue x=<rounded_or_taper_point_1> y=<y1>
etch continue x=<center_x> y=<bottom_y>
etch done x=<center_x> y=<surface_y>

structure outfile=trench_half.str
structure mirror right
structure outfile=trench_full.str
```

For sidewall implantation:

```atlas
implant <species> dose=<dose> energy=<energy> \
  tilt=<tilt> rotation=<rotation> bca n.ion=<particles>
```

Run complementary rotations when both sidewalls must receive equivalent dose. Inspect shadowing and bottom dose separately.

## Trench oxidation and thickness extraction

```atlas
method gridinit.ox=<initial_oxide_grid> grid.ox=<oxide_grid>
diffuse time=<oxidation_time> temp=<oxidation_temp> wet

extract name="tox_planar" thickness oxide mat.occno=1 x.val=<planar_x>
extract name="tox_sidewall" thickness oxide mat.occno=1 y.val=<sidewall_y>
structure outfile=trench_oxidized.str
```

Repeat for the intended substrate rotation/orientation. Do not assume planar and sidewall oxide thickness are equal.

## Spacer formation with mixed etch

```atlas
deposit oxide thick=<conformal_oxide> div=<n>
rate.etch machine=spacer rie oxide \
  dir=<directional_rate> iso=<isotropic_rate> u.m
etch machine=spacer time=<seconds> second dt.max=<time_step>
structure outfile=spacer_final.str
```

Calibrate directional and isotropic rates against spacer width, height and footing; save pre/post-etch structures.

## Repeated guard-ring/field-plate windows

```atlas
deposit oxide thick=<mask_oxide>

etch oxide start x=<r1_left> y=<top>
etch oxide continue x=<r1_left> y=<surface>
etch oxide continue x=<r1_right> y=<surface>
etch oxide done x=<r1_right> y=<top>

# Repeat polygon window for each ring.
implant <junction_species> dose=<dose> energy=<energy>
diffuse time=<drive_time> temp=<drive_temp> <ambient>

deposit polysilicon thick=<field_plate_thickness> c.<dopant>=<poly_doping>
# Pattern individual plates and assign unique or common electrode names.
```

Generate ring coordinates from a documented spacing table. Audit whether each plate is floating, independently biased, or electrically common.

## Athena -> DevEdit -> Atlas handoff

```atlas
structure outfile=athena_raw.str

go devedit
init infile=athena_raw.str
imp.refine imp="Net Doping" scale=log transition=<transition>
imp.refine min.spacing=<minimum_spacing>
<local interface/junction/trench constraints>
structure outfile=device_mesh.str

go atlas
mesh infile=device_mesh.str
<materials, contacts, models, method and solve sequence>
```

Compare Athena and DevEdit structures before device simulation: total dopant dose, junction positions, gate oxide, narrow regions, trench geometry and electrode labels must be preserved.

# IGBT and MOSFET Structure, Mesh, Gate Oxide, and Electrodes

Read this reference first for planar or trench IGBT/MOSFET construction and review. It summarizes vendor-example patterns observed in local Silvaco releases `4.2.2.R` and `4.2.5.R`. Numerical coordinates from those decks illustrate syntax and topology only; do not reuse them as a new device design.

## Required structure specification

Before writing commands, define a coordinate contract:

| Item | Required information |
| --- | --- |
| Axes | lateral/cell-width axis, vertical transport axis, and depth axis in 3D |
| Origin | semiconductor surface, trench centerline, or cell symmetry plane |
| Cell | half/full cell, pitch, simulated width/depth, and symmetry boundaries |
| Vertical stack | source/emitter, body/base, JFET region, drift, buffer/field-stop, substrate/collector |
| Gate | planar or trench; gate length/depth/width; corner radius; gate material |
| Oxide | channel-sidewall thickness, trench-bottom thickness, field oxide, inter-poly oxide |
| Terminals | name, material, bounds, contacted semiconductor regions, and electrical ties |

Reject or flag any structure where an electrode overlaps the wrong region, stops short of its intended contact, shorts across oxide, floats unintentionally, or depends on an undocumented default boundary.

## Mesh rule: refine by physical feature

Do not choose a globally uniform fine mesh. Build a feature-to-mesh table and refine these locations independently:

1. Semiconductor/oxide interfaces along the inversion channel.
2. Gate-oxide top/bottom surfaces so the oxide contains multiple elements through its thickness.
3. Trench sidewalls and bottom corners, especially where curvature or a right-angle corner changes electric-field crowding.
4. Source/body and body/drift junctions, JFET constriction, collector/buffer junction, and termination curvature.
5. Electrode endpoints and metal/semiconductor/oxide triple points.
6. Implant gradients and every expected peak in electric field, impact generation, current density, or lattice temperature.

Use gradual size transitions; abrupt jumps in element size can create interpolation error and poor Newton behavior. Keep the drift-region bulk coarse only after confirming that depletion width and field gradient remain resolved.

For each critical feature report: coordinate bounds, requested local spacing/maximum element size, neighboring spacing ratio, and the observable used for convergence. Minimum convergence studies compare at least channel current/threshold, peak oxide field, on-resistance, and breakdown voltage as applicable.

### Patterns found in local examples

- `powerex03`/`powerex04` use explicit `X.MESH`/`Y.MESH` lines and place their finest vertical mesh at the oxide/semiconductor surface. Their deep drift is much coarser. This is a topology pattern, not a sufficient modern mesh-convergence study.
- `sicex02`/`powerex09` use DevEdit constraints: net-doping refinement, tighter p-base/n+ source limits, a thin refinement strip under polysilicon, narrow vertical boxes at trench sidewalls, and local boxes around upper junctions and the substrate transition.
- A local `sicex09` vendor deck demonstrates the general requirement that rounded and Manhattan trench variants use comparable interface/junction refinement for a fair field/BV comparison. Reproduce that principle with Athena geometry and DevEdit mesh constraints; do not require Victory Mesh.
- `sicex08` shows that in a 3D vertical device the surface-normal axis can be `Z`, not `Y`. Never infer “vertical” from command spelling; read the region bounds and electrode planes.

## Gate oxide construction and audit

### Planar gate

Define oxide as a region between the gate electrode and semiconductor surface. Confirm:

- oxide thickness from coordinate difference, not merely a comment;
- channel overlap and gate-to-drain/JFET overlap;
- gate electrode lies on the oxide outer boundary;
- source/emitter metal does not cross the gate oxide; and
- the mesh has enough nodes through the oxide to resolve potential and field.

In local Atlas IGBT examples `powerex03`/`powerex04`, the semiconductor surface is at `y=0`, oxide extends to negative `y`, and the gate electrode is placed along the outer/left boundary of the oxide. This is useful syntax evidence but is a simplified planar topology.

### Trench gate

Treat trench geometry, oxide lining, and gate fill as three separate objects. Specify:

- trench opening, depth, sidewall angle, bottom shape/radius, and alignment to body/source regions;
- sidewall gate-oxide thickness and bottom oxide thickness separately;
- polysilicon fill and the part electrically assigned to `gate`;
- any shield/field plate, inter-poly dielectric, and its electrical tie; and
- oxide and semiconductor mesh at both sidewall and bottom corner.

`sicex09` constructs Manhattan and rounded trench variants by changing the SiC etch and oxide etch to include rounded final segments, then applies identical interface/junction refinement concepts. Its field maximum near the trench bottom demonstrates why corner geometry and local mesh cannot be reviewed separately.

`sicex02`/`powerex09` use an approximately 800 Å gate oxide in a DevEdit trench MOSFET example. Treat that value as example geometry, not a recommended SiC oxide thickness.

### Oxide-field verification

Compute oxide thickness from the actual saved structure and inspect the oxide field spatially. For reliability or breakdown claims, report the maximum field location as well as magnitude; distinguish channel-sidewall, trench-bottom, and electrode-edge peaks. Repeat after mesh refinement because a single element at a corner can dominate the reported maximum.

## Electrode placement rules

Every electrode must have an explicit terminal contract:

| Terminal | MOSFET expectation | IGBT expectation | Geometry checks |
| --- | --- | --- | --- |
| Gate | metal/poly outside gate dielectric | same | no direct semiconductor short; complete intended channel overlap |
| Source/emitter | top contact to n+ source and usually body short where designed | top emitter/body topology | body short is intentional and geometrically connected; no oxide overlap |
| Drain | bottom or lateral drift/substrate contact | not normally named collector | covers intended substrate face and no insulating gap |
| Collector | not normally used | bottom p+ collector/substrate contact | covers collector face; buffer/field-stop remains semiconductor, not electrode |
| Body/pwell | optional separate diagnostic terminal | optional | if separate, do not silently tie it to source/emitter |
| Field plate/shield | optional, often tied to source | optional | declare `COMMON`/shared name or explicit circuit tie |

Use terminal names consistently across `ELECTRODE`, `CONTACT`, `SOLVE`, `LOG`, `PROBE`, and `EXTRACT`. Multiple geometric electrode statements may share one name, as in the 3D source and gate segments of `sicex08`; verify that all pieces are contiguous electrically or intentionally share the same terminal.

For 3D structures, specify all three coordinate bounds. A bottom electrode defined by a plane or a `bottom` shortcut must be checked after meshing to ensure it covers the intended face. In process-derived structures, inspect the electrode labels after remesh/export because material deposition alone does not always create the desired electrical terminal.

## IGBT-specific topology checks

In addition to MOS gate checks, confirm the parasitic thyristor path:

- emitter/body short geometry and lateral body resistance;
- p-body/n-drift/p-collector and n+ emitter placement;
- drift thickness and doping;
- n-buffer or field-stop position between drift and p+ collector;
- collector electrode on the p+ backside; and
- mesh refinement at emitter/body, body/drift, buffer/collector, and trench-bottom regions.

The silicon `powerex03`/`powerex04` decks show an Atlas-built IGBT with a top gate/emitter, long n-drift, n-buffer, p+ collector, and bottom collector electrode. Reuse only the structural ordering and terminal logic for SiC; replace material, ionization, mobility, lifetime, incomplete-ionization, thermal, and interface assumptions.

For trench SiC IGBTs, first attempt direct Atlas regions. If process-shaped trench/oxide/implant history is required, use the bundled Athena polygon-trench, oxidation, implant and mirror patterns. Add DevEdit only when the resulting mesh or geometry requires it. A Victory-based vendor deck may be consulted only as geometric evidence when explicitly needed; translate useful ideas into this Atlas-first workflow.

## MOSFET-specific topology checks

Confirm channel length along the SiC/oxide interface, body junction depth, source overlap, JFET width, drift thickness, substrate contact, and gate-to-drain overlap. For split-gate or shielded trench devices, keep the control gate and field plate as distinct conductors with an explicit dielectric separation and terminal tie.

For curve families, preserve the same geometry, mesh, area normalization, and contact layout. Structural comparisons must not unintentionally change cell pitch or electrode area.

## Required output for a structure review

Return:

1. A region table with material and coordinate bounds.
2. An electrode table with name, bounds, contacted material, and intended tie.
3. A gate-stack table with oxide type and thickness by location.
4. A mesh table mapping critical feature to local spacing/refinement rule.
5. A list of overlaps, gaps, floating conductors, ambiguous defaults, and symmetry/normalization assumptions.
6. Separate syntax, geometry, mesh-convergence, and physical-calibration verdicts.

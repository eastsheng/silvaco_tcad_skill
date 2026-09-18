# Athena Process Deck Contract

Read this before generating or auditing a complete Athena flow.

## Tool and module gate

1. Use Atlas direct construction if final geometry and analytic/imported profiles are sufficient.
2. Use Athena only when process history affects geometry, redistribution, damage, activation, stress, or interface shape.
3. Within Athena, distinguish framework geometry from module physics:
   - SSuprem4: diffusion, oxidation and implant/process physics;
   - Elite: physical etch/deposition, string geometry, reflow/CMP;
   - Optolith: imaging/exposure/development;
   - BCA/adaptive features: separately licensed or version-dependent.
4. Use DevEdit only after Athena when final device mesh/geometry needs repair or targeted refinement.

Never silently replace missing process physics with a similarly named command. State whether a step is physical simulation, calibrated geometry construction, or imported profile data.

## Ordered state machine

```text
GO ATHENA
LINE X/Y and optional REGION
INITIALIZE
model declarations needed before the affected operation
process operations in chronological order
checkpoint + extraction after every irreversible/high-risk operation
final contact opening and conductor deposition
ELECTRODE
STRUCTURE OUTFILE=<device.str>
optional DevEdit audit/remesh
GO ATLAS + imported mesh audit
```

Model ordering matters. Examples: set `POLY.DIFF` before polysilicon deposition; set implant-damage/cluster models before the implant that creates defects; set oxidation/grid controls before the oxidizing `DIFFUSE` step.

## Coordinate and dimensionality contract

- Athena uses +x to the right along the surface and +y downward into the substrate in the 2015 manual.
- Prefer automatic dimensionality: Athena can begin in 1D and switch to 2D at the first lateral-nonuniform operation. Force 2D only when required and document why.
- Deposition and oxidation can move the surface. Never reuse the initial `y=0` as the final semiconductor surface without inspecting/extracting it.
- Before `MIRROR`, prove geometry, profiles, implant rotations/miscut, stress and contacts are symmetric.
- `FLIP.Y` is a geometry transformation for backside processing; re-audit depth sign, gas/exposed boundaries and terminal placement afterward.

## Restart contract

`STRUCTURE` is a state checkpoint, not a complete process recipe. On restart:

1. initialize from the saved structure;
2. reissue every non-persistent model and machine declaration needed by subsequent steps;
3. record the installed Athena version and effective default files;
4. verify material names, active/net/chemical dopants, defects, stress fields and exposed boundaries;
5. run a short equivalence step where practical and compare with an uninterrupted flow.

## Electrode semantics

`ELECTRODE NAME=<name> X=<x> [Y=<y>]` selects and names the whole conductor region containing the point. It does not draw a bounded line segment. If `Y` is omitted, Athena searches at the structure top. `BACKSIDE` creates a flat bottom electrode only when bottom metal is absent; with backside metal, select that metal region by coordinates.

Therefore:

- isolate conductors geometrically before naming them;
- place the selector point strictly inside the intended metal/poly region;
- inspect whether disconnected conductor islands were unintentionally merged or separately selected;
- use Atlas-preferred terminal names consistently; and
- recheck labels after mirror/remesh/export.

## Handoff acceptance test

Before Atlas, verify final oxide/interface geometry, junction positions, active and chemical doping, narrow layers, material-name translation (`SIC_4H` versus Atlas material), electrode connectivity, backside direction, cell width/area normalization, and mesh suitability for electric field/current/temperature—not only process accuracy.


# Reusable Atlas deck patterns

These are templates, not calibrated devices. Replace every angle-bracket placeholder and verify exact model keywords against the installed release.
For reusable DeckBuild control-flow, extraction, overlay, and TonyPlot evidence patterns, read `bundled-deckbuild-tonyplot-examples.md`.

## Vertical SiC diode skeleton

```atlas
go atlas
title 4H-SiC vertical diode research template

mesh space.mult=1
x.mesh location=0 spacing=<edge_dx>
x.mesh location=<width> spacing=<edge_dx>
y.mesh location=0 spacing=<surface_dy>
y.mesh location=<drift_thickness> spacing=<bulk_dy>
y.mesh location=<total_thickness> spacing=<contact_dy>

region number=1 material=4H-SiC x.min=0 x.max=<width> y.min=0 y.max=<total_thickness>
electrode name=anode top
electrode name=cathode bottom

doping uniform <p.type-or-n.type> concentration=<top_doping> y.min=0 y.max=<junction_depth>
doping uniform n.type concentration=<drift_doping> y.min=<junction_depth> y.max=<drift_end>
doping uniform n.type concentration=<substrate_doping> y.min=<drift_end> y.max=<total_thickness>

material material=4H-SiC <verified_overrides>
contact name=anode <ohmic-or-workfunction>
contact name=cathode
models <verified_sic_models> print
mobility <verified_coefficients>
impact <verified_model_and_coefficients>
method newton trap

solve init
save outf="equilibrium.str"
log outf="iv.log"
solve name=anode vanode=<first_bias> vstep=<step> vfinal=<final_bias>
log off
save outf="final.str"
quit
```

## MOSFET bias sequence

```atlas
solve init
solve vdrain=0.05
log outf="transfer.log"
solve name=gate vgate=<start> vstep=<gate_step> vfinal=<gate_final>
log off

load infile="<converged_gate_state>.str"
log outf="output.log"
solve name=drain vdrain=<start> vstep=<drain_step> vfinal=<drain_final>
log off
```

Use a saved, converged gate state for each output curve. Do not accidentally continue from the previous drain sweep when constructing a curve family.

## Breakdown staging

```atlas
solve init
solve name=drain vdrain=<low_bias>
save outf="prebreakdown.str"
log outf="breakdown.log"
solve name=drain vstep=<coarse_step> vfinal=<mid_bias>
solve name=drain vstep=<fine_step> vfinal=<target_bias>
log off
save outf="breakdown_final.str"
```

Choose signs according to terminal convention. Add current compliance or curve tracing when available and appropriate. Extract breakdown only after checking the spatial ionization and field pattern.

## Parameter documentation block

```atlas
# Parameter: <name>
# Model/equation: <Atlas model>
# Value and unit: <value unit>
# Polytype/orientation: 4H-SiC, <direction>
# Valid range: <temperature/doping/field>
# Source/calibration dataset: <citation or experiment>
```


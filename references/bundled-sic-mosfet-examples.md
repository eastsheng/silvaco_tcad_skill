# Bundled 4H-SiC MOSFET Examples

These examples are templates. They intentionally expose structure and calibration placeholders instead of hiding assumptions.

## Planar vertical MOSFET cell skeleton

```atlas
go atlas simflags="-80"
title 4H-SiC planar vertical MOSFET cell

mesh width=<cell_width_normalization_um>
x.mesh location=0 spacing=<symmetry_dx>
x.mesh location=<gate_edge_x> spacing=<gate_edge_dx>
x.mesh location=<source_edge_x> spacing=<source_edge_dx>
x.mesh location=<half_pitch> spacing=<boundary_dx>
y.mesh location=-<tox_um> spacing=<oxide_dy>
y.mesh location=0 spacing=<interface_dy>
y.mesh location=<body_depth> spacing=<junction_dy>
y.mesh location=<drift_end> spacing=<drift_dy>
y.mesh location=<total_depth> spacing=<backside_dy>

region number=1 material=oxide y.min=-<tox_um> y.max=0
region number=2 material=4H-SiC y.min=0 y.max=<total_depth>

electrode name=gate y.min=-<tox_um> y.max=-<tox_um> x.min=0 x.max=<gate_edge_x>
electrode name=source y.min=0 y.max=0 x.min=<source_edge_x> x.max=<half_pitch>
electrode name=drain bottom

doping region=2 uniform n.type concentration=<drift_doping>
doping region=2 gaussian p.type concentration=<body_peak> junction=<body_depth> x.min=<body_xmin>
doping region=2 gaussian n.type concentration=<source_peak> junction=<source_depth> x.min=<source_xmin>
doping region=2 uniform n.type concentration=<substrate_doping> y.min=<drift_end>

contact name=gate workfunction=<calibrate_gate_workfunction>
interface qf=<calibrate_fixed_charge>
# intdefects/inttrap: add measured donor/acceptor distributions when available

models fermi analytic fldmob srh incomplete print
mobility material=4H-SiC <calibrate_bulk_and_channel_parameters>
method newton trap maxtrap=10
solve init
save outf=mos_eq.str
```

Geometry checks: the gate must be separated from SiC by oxide; source must contact the n+ source and intentional body-short area; drain must cover the backside substrate. Add local mesh points at oxide surfaces, channel/body junction, source/body junction, JFET constriction, gate edge, and backside transition.

## Transfer characteristic

```atlas
load infile=mos_eq.str master
solve previous
solve vdrain=0.01
solve vdrain=0.1
log outf=mos_idvg.log
solve vgate=<vg_start>
solve name=gate vstep=<vg_step> vfinal=<vg_stop>
log off

extract init infile="mos_idvg.log"
extract name="Vth_maxgm" xintercept(maxslope(curve(abs(v."gate"),abs(i."drain"))))
```

State the Vth definition. For constant-current Vth, use a current-density criterion normalized by the documented cell width/area instead of reusing `maxslope`.

## Output-family sequence

```atlas
load infile=mos_eq.str master
solve previous
solve name=gate vgate=<vg1> vstep=<gate_step> vfinal=<vg1>
save outf=mos_vg1.str master

load infile=mos_vg1.str master
log outf=mos_idvd_vg1.log
solve vdrain=0.01
solve name=drain vstep=<fine_step> vfinal=<linear_end>
solve name=drain vstep=<coarse_step> vfinal=<vd_stop>
log off
```

Repeat from `mos_eq.str` for every gate voltage. Do not continue the next curve from the previous high-drain solution.

## Trench MOSFET refinement fragment

For DevEdit meshing, apply independent controls to the channel-sidewall interface, trench bottom, gate oxide, source/body junction, JFET region, and drift/substrate transition:

```text
global bulk mesh: coarse
SiC/oxide interface: <fine interface size>
oxide thickness direction: multiple elements through tox
trench sidewall strip: <fine lateral size>
trench bottom/corner box: <fine isotropic size>
source/body and body/drift junctions: <fine junction size>
drift bulk: coarse with smooth grading
```

Compare peak oxide field, Vth, Id, Ron and BV after refinement. A rounded-trench comparison must keep equivalent refinement criteria in both geometries.

# Bundled HEMT/HFET, PHEMT, and GaN-FET Models and Examples

Read this reference before constructing or adapting a HEMT-family deck. These are Atlas-first patterns distilled from the locally installed `hemt` and `ganfet` families. Values remain placeholders unless explicitly identified as a vendor-example observation; none is a universal calibration.

## Structure contract

Return a layer table before syntax:

| Order | Material | Thickness | Composition/grade | Doping/trap | Purpose |
| --- | --- | --- | --- | --- | --- |
| top | passivation or gate dielectric | `<...>` | `<...>` | fixed/surface charge | surface and field plate |
| barrier | AlGaAs, AlGaN, InAlN, etc. | `<...>` | `x.composition=<...>` | intentional/background | heterojunction charge control |
| spacer/channel | GaAs, InGaAs, GaN, etc. | `<...>` | grade if any | background/traps | 2DEG/channel transport |
| buffer | material-specific | `<...>` | `<...>` | Fe/C traps if modeled | isolation and field control |
| substrate | material-specific | `<...>` | `<...>` | `<...>` | mechanical/electrical/thermal boundary |

Also state gate length, source-gate and gate-drain spacing, recess depth, field-plate length, source/drain access-region doping, current normalization, and whether the simulated cross-section represents one finger or unit gate width.

## Atlas-first mesh and geometry

Mesh lines must resolve:

- both sides of every heterointerface and the expected 2DEG centroid;
- barrier and spacer thickness with multiple elements, not one long cell;
- both gate edges, recess bottom/corners, field-plate edge and dielectric corners;
- source/drain contact edges and access regions;
- trap-profile gradients in buffer/surface regions; and
- peak-field and thermal bottleneck regions for breakdown/self-heating.

```atlas
go atlas
mesh width=<gate_width_normalization_um>
x.mesh location=<source_edge> spacing=<contact_edge_dx>
x.mesh location=<gate_left> spacing=<gate_edge_dx>
x.mesh location=<gate_right> spacing=<gate_edge_dx>
x.mesh location=<drain_edge> spacing=<contact_edge_dx>
y.mesh location=<surface> spacing=<surface_dy>
y.mesh location=<barrier_bottom> spacing=<heterointerface_dy>
y.mesh location=<channel_bottom> spacing=<channel_dy>
y.mesh location=<buffer_bottom> spacing=<bulk_dy>

region number=<n> material=<barrier> x.composition=<x> <bounds>
region number=<n> material=<channel> <bounds> substrate
region number=<n> material=<passivation> <bounds>
electrode name=source <bounds>
electrode name=gate <bounds>
electrode name=drain <bounds>
```

Use DevEdit only when a recessed/curved/imported geometry cannot be meshed adequately in Atlas. Local `hemtex05` and `hemtex06` are DevEdit patterns, not evidence that all HEMTs require DevEdit.

## Material and interface decisions

| Device/material | Required decisions | Usually calibrated |
| --- | --- | --- |
| AlGaAs/GaAs HEMT | Al composition/grade, band alignment, doping/spacer, Schottky gate, low/high-field mobility | band offset convention, mobility, gate barrier, interface charge, access/contact resistance |
| AlGaAs/InGaAs/GaAs PHEMT | every composition and grade, strained-channel material, recess geometry | channel mobility/velocity saturation, recess depth, Schottky barrier, sheet density |
| AlGaN/GaN HEMT | Al composition, strain state, spontaneous/piezoelectric polarization treatment, buffer traps, passivation/surface charge | polarization scale only if justified, 2DEG density, surface/buffer trap spectrum, contact resistance, mobility/velocity saturation |
| MIS-HEMT/MISFET | dielectric thickness/permittivity, dielectric/barrier offsets, fixed charge and Dit | dielectric charge, interface traps, gate leakage/tunneling parameters |
| p-GaN gate HEMT | p-GaN thickness/doping/activation, gate metal, junction/interface | activation, Mg ionization, gate leakage, interface charge |
| vertical GaN CAVET | aperture/current-blocking layer, drift/buffer, vertical contacts, area normalization | blocking-layer activation, traps, contact/series resistance, avalanche and thermal parameters |

Do not enable calculated polarization and also add an equivalent sheet charge unless the intended partition is documented. Local cases demonstrate both explicit `INTERFACE CHARGE=...` and region-based `POLARIZATION CALC.STRAIN POLAR.SCALE=...`; they are alternative calibration strategies, not automatically additive.

## Model governance

| Physics | Command family | Status rule |
| --- | --- | --- |
| heterojunction bands | `REGION ... X.COMPOSITION`, `MATERIAL ... ALIGN=...` | equation/default is `version-check`; alignment and composition are `must-calibrate` to the epitaxy |
| bulk/field mobility | `MOBILITY`, material-scoped `MODELS`, e.g. release-supported GaN saturation or III-V mobility | coefficients are `literature-start`/`must-calibrate` |
| recombination/statistics | `MODELS SRH FERMI` plus high-injection additions when relevant | lifetime/trap capture data are `must-calibrate` |
| polarization | region polarization flags or bounded `INTERFACE CHARGE` | implementation is `version-check`; magnitude/strain relaxation is `must-calibrate` |
| buffer/surface traps | `DOPING TRAP`, `TRAP`, bounded interface states/charge as supported | energy, density/profile, degeneracy, cross-sections are `must-calibrate` |
| hot carriers | energy-balance/nonlocal transport supported by installed module | use only for a stated observable; relaxation times are `must-calibrate` |
| avalanche | `IMPACT` with material-specific equation and coefficients | never borrow GaAs/GaN/Si/SiC coefficients across materials |
| heat flow | lattice-temperature model, material thermal properties, `THERMCONTACT` | bulk k, interface/package resistance and heat capacity require provenance/calibration |
| gate leakage | Schottky/tunneling model supported by installed release | barrier, effective mass and tunneling parameters require measured validation |

## Transfer and output templates

For transfer, establish drain bias before sweeping gate and state whether the sweep starts from normally-on or normally-off equilibrium:

```atlas
solve init
solve vdrain=<low_or_application_drain_bias>
log outf=<transfer.log>
solve name=gate vstep=<signed_step> vfinal=<gate_stop>
log off
```

For an output family, use an independent gate-conditioned state per curve. Do not let the previous high-drain state seed the next gate curve when trapping, heating, avalanche, or hysteresis is possible.

```atlas
solve init
solve name=gate vstep=<gate_step> vfinal=<gate_target>
save outf=<gate_state.str>
load inf=<gate_state.str> master
log outf=<output_for_this_gate.log>
solve name=drain vstep=<drain_step> vfinal=<drain_stop>
log off
```

Validate sheet density, threshold/pinch-off definition, gm, access/contact resistance and current per unit gate width before fitting saturation behavior.

## Breakdown template

Use an off-state gate bias, progressively increase drain step size only away from the knee, enable compliance, and switch to current continuation only when supported and necessary.

```atlas
solve init
solve name=gate vstep=<step> vfinal=<off_gate_bias>
log outf=<breakdown.log>
solve name=drain vstep=<fine_low_voltage_step> vfinal=<first_voltage>
solve name=drain vstep=<coarse_step> vfinal=<pre_breakdown> cname=drain compl=<limit>
contact name=drain current
solve name=drain imult istep=<factor> ifinal=<final_current>
```

Audit the peak field at gate/field-plate/passivation corners, surface charge, buffer traps, substrate boundary, impact model, leakage floor, mesh, precision and BV criterion. A converged terminal rise without physically located impact generation is not sufficient evidence of avalanche breakdown.

## Current-collapse and recovery state machine

DC Id-Vd cannot reproduce dynamic on-resistance. Define:

1. equilibrium and initial on-state reference;
2. quiescent drain/gate stress voltages and stress duration;
3. transition/rise and fall times;
4. measurement gate/drain point and delay after stress;
5. recovery dwell sequence; and
6. identical fresh/stressed extraction of `Rdyn`, current or charge.

Save trap occupancy/state at meaningful checkpoints. Run trap-density, capture-cross-section, mesh and time-step sensitivity separately. Do not infer a unique trap spectrum from one transient.

## AC/RF and large signal

- First converge the DC operating point used by the AC solve.
- State frequency, port/electrode convention and intrinsic versus extrinsic network.
- For `gm`, capacitance, Y/S parameters, `fT` or `fmax`, preserve parasitic/contact assumptions and de-embedding definition.
- Large-signal power requires the external circuit/waveform, period, settled-cycle criterion, load and power normalization; a DC output curve is insufficient.

## Electrothermal HEMT

Add heat flow only after isothermal electrical calibration. Define temperature-dependent mobility/saturation, thermal conductivity for every heat-carrying region, substrate thickness/truncation, heat capacity for transient work, and external thermal conductance/location. Compare isothermal and self-heated curves at the same bias state. Report peak temperature location and close electrical input power against boundary heat flow at steady state.

## Minimum HEMT answer

Return layer/composition/doping table; mesh hot spots; electrode and field-plate coordinates; polarization strategy; surface/buffer trap definitions; contact/barrier assumptions; material-scoped model/parameter table; DC/transient/AC bias state machine; current normalization; calibration order; and version/module uncertainties.

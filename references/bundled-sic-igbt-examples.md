# Bundled 4H-SiC IGBT Examples

Use these templates with `sic-igbt-electrothermal-models.md`. All lifetime, mobility, impact, interface and thermal values are calibration inputs.

## Electrothermal model block

```atlas
material material=4H-SiC \
  taun0=<calibrate_electron_lifetime> taup0=<calibrate_hole_lifetime> \
  tcon.power tc.const=<calibrate_k300> tc.npow=<calibrate_k_exponent> \
  hc.a=<calibrate_heat_capacity_A> hc.b=<calibrate_B> \
  hc.c=<calibrate_C> hc.d=<calibrate_D>

models fermi bgn analytic fldmob srh auger incomplete \
  lat.temp heat.full print

mobility material=4H-SiC <calibrate_1100_direction>
mobility material=4H-SiC n.angle=<crystal_axis_angle> p.angle=<crystal_axis_angle> \
  <calibrate_0001_direction>

impact aniso sic4h0001 <calibrate_or_confirm_impact_set>

thermcontact number=1 elec.num=<collector_electrode_number> \
  ext.temp=<ambient_K> alpha=<package_G_W_per_cm2K>
```

Do not omit a thermal boundary when `LAT.TEMP` is active. For transient work, provide heat capacity for every thermally active region and package layer.

## Ic-Vce family with self-heating

```atlas
solve init
solve previous
solve name=gate vgate=<vg_target> vstep=<vg_step> vfinal=<vg_target>
save outf=igbt_vg_state.str master

load infile=igbt_vg_state.str master
log outf=igbt_icvce.log
solve vcollector=0.01
solve vcollector=0.1
solve name=collector vstep=<fine_step> vfinal=<knee_voltage>
solve name=collector vstep=<coarse_step> vfinal=<stop_voltage>
log off
save outf=igbt_output_final.str
```

Save a separate gate-conditioned state per gate voltage. Validate Vce(sat), conductivity modulation, peak lattice temperature, heat-flux path and power balance.

## Short-circuit/latch-up transient

First create and save a converged blocking state at the DC bus voltage. Then:

```atlas
load infile=igbt_blocking_state.str master
solve previous
output flowlines jx.e jy.e jx.h jy.h
log outf=igbt_short_circuit.log
solve vgate=<on_voltage> ramptime=<gate_rise_s> \
  tstep=<initial_dt_s> tstop=<stop_time_s> t.compl=<current_limit>
log off
save outf=igbt_short_circuit_final.str
```

Evidence for latch-up must include electron/hole current-density maps, emitter/body potential drop, impact generation, lattice temperature, and terminal waveforms. Repeat with smaller time steps. Distinguish regenerative pnpn latch-up from purely thermal runaway.

## Electrothermal breakdown

```atlas
solve init
solve previous
solve vcollector=0.1
solve vcollector=1
log outf=igbt_breakdown.log
solve name=collector vstep=<coarse_step> vfinal=<pre_knee>
solve name=collector vstep=<fine_step> vfinal=<target> \
  compliance=<normalized_current_limit> cname=collector
save outf=igbt_prebreakdown.str

contact name=collector current
solve name=collector istep=<current_multiplier> imult ifinal=<final_current>
save outf=igbt_breakdown_final.str
extract name="BV" <explicit_current_or_current_density_criterion>
log off
```

Check crystal-axis mapping, field/impact peaks, emitter/body short, collector/buffer junction, trench corner and termination mesh. Repeat with `LAT.TEMP` disabled/enabled to separate isothermal and electrothermal BV.

## Turn-off/tail-current template

```atlas
load infile=igbt_on_state.str master
log outf=igbt_turnoff.log
solve vgate=<off_voltage> ramptime=<fall_time> \
  tstep=<initial_dt> tstop=<tail_stop_time>
log off
```

Tail current is primarily sensitive to stored charge, lifetime profile, buffer/collector injection and external circuit. Do not fit it by changing only mobility or thermal resistance.

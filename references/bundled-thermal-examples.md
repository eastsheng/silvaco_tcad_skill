# Bundled Thermal Examples

Use these patterns before searching the local examples/manual. See `thermal-properties-and-boundaries.md` for equations, units and limitations.

## Constant and temperature-dependent bulk conductivity

```atlas
models lat.temp print

material region=<sic_region> tcon.power \
  tc.const=<k300_W_per_cmK> tc.npow=<temperature_exponent>

material region=<oxide_region> tcon.const \
  tc.const=<koxide_W_per_cmK>
```

Convert SI data: `k[W/(cm K)] = k[W/(m K)] / 100`.

## Piecewise doping-dependent conductivity

```atlas
material region=<light_drift> tcon.power \
  tc.const=<k_light_300> tc.npow=<n_light>
material region=<heavy_substrate> tcon.power \
  tc.const=<k_heavy_300> tc.npow=<n_heavy>
material region=<p_collector> tcon.power \
  tc.const=<k_pplus_300> tc.npow=<n_pplus>
```

Use only when regions correspond to physically distinct layers and doping is approximately uniform within each layer.

## Continuous doping-dependent conductivity

```atlas
material region=<sic_region> f.tcond=<tcond_function_file>
```

The C-Interpreter function must implement the installed Atlas `TCOND()` template and return positive finite W/(cm K) as a smooth function of lattice temperature, position, doping and composition. Test known `(T,N)` points before running the device.

## SiC/SiO2 internal thermal boundary resistance

Represent a measured interface conductance `Gint` with an explicit thin region:

```text
tint_cm = tint_um * 1e-4
kint = Gint * tint_cm
```

```atlas
region number=<interface_region> material=<electrically_intentional_insulator> \
  <bounds of thin layer>
material region=<interface_region> tcon.const tc.const=<kint_W_per_cmK>
```

Change `tint` and scale `kint=Gint*tint`; the total thermal solution should remain invariant. Preserve the intended electrical oxide thickness and permittivity.

## Collector/backside cooling

Ideal isothermal collector:

```atlas
thermcontact number=1 elec.num=<collector_number> ext.temp=<ambient_K>
```

Finite package conductance:

```atlas
thermcontact number=1 elec.num=<collector_number> \
  ext.temp=<ambient_K> alpha=<Gext_W_per_cm2K>
```

Compute:

```text
R''total = sum(t_i/k_i) + sum(R''interface_i)
ALPHA = 1/R''total
```

If lateral heat spreading matters, create explicit substrate/metal/die-attach/package regions instead of collapsing them into one `ALPHA`.

## Thermal verification

For every example:

1. Integrate or otherwise compare electrical power and boundary heat flux.
2. Check peak temperature and its location.
3. Refine heat-source, oxide/interface-layer and thermal-contact mesh.
4. Compare fixed-temperature and finite-`ALPHA` boundaries.
5. For transients, calibrate heat capacity and compare `Zth(t)`, not only steady-state `Rth`.

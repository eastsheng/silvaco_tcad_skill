# Thermal Conductivity and Thermal Boundaries

Read this reference for lattice self-heating, doping-dependent thermal conductivity, gate-stack thermal boundary resistance, or collector/backside cooling. It is grounded in the installed Atlas 5.30 manual, especially Giga Chapter 8, and local DeckBuild thermal, SOI, ESD, and power examples. Verify aliases and module availability in the installed release.

For a complete 4H-SiC IGBT electrical-plus-thermal model audit, also read `sic-igbt-electrothermal-models.md`.

## Three different quantities

Do not conflate:

| Quantity | Physical meaning | Atlas mechanism | Units |
| --- | --- | --- | --- |
| Bulk thermal conductivity `k` | heat conduction inside a material region | `MATERIAL ... TCON.*` or `F.TCOND` | W/(cm K) |
| Internal thermal boundary resistance `R''int` | temperature discontinuity between two adjacent materials | no dedicated two-sided interface keyword was identified in the installed Atlas 5.30 manual; use an explicit thin interfacial region when needed | cm2 K/W |
| External/boundary conductance `Gext` | heat loss from a device boundary to an external reservoir at `EXT.TEMP` | `THERMCONTACT ... ALPHA=Gext` | W/(cm2 K) |

With no `THERMCONTACT` on an exterior boundary, the local examples/manual treat it as thermally insulating. A fixed-temperature `THERMCONTACT` and a finite-`ALPHA` thermal resistance boundary are not equivalent.

## Enable lattice heat flow

For an electrothermal device simulation:

```atlas
models <electrical models> lat.temp print
```

For a standalone Thermal3D calculation:

```atlas
models thermal
```

`PRINT` is strongly recommended to inspect the selected material thermal model and parameters. Define at least one physically justified thermal boundary condition.

## Bulk thermal conductivity

### Constant value

```atlas
material region=<n> tcon.const tc.const=<k_W_per_cmK>
```

`TC.CONST` is the thermal conductivity in W/(cm K). Convert published SI values using:

```text
1 W/(m K) = 0.01 W/(cm K)
```

For example, do not enter a value reported in W/(m K) directly without dividing by 100.

### Temperature-dependent models

The installed Atlas 5.30 manual lists these `MATERIAL` choices:

```atlas
material region=<n> tcon.power  tc.const=<k300> tc.npow=<nexp>
material region=<n> tcon.polynom tc.a=<a> tc.b=<b> tc.c=<c>
material region=<n> tcon.recipro tc.d=<d> tc.e=<e>
```

Manual and example spellings include `TCON.POLYN`, `TCON.POLYNOM`, `TCON.POLYNOM`, and the abbreviated `TCON.POLY`; confirm the accepted alias in the installed release. Local `thermalex03` uses:

```atlas
material region=1 tcon.polynom
material region=10 tcon.power tc.c0=1.0 tc.npow=1.2
```

The manual describes a power-law form based on `TC.CONST`, lattice temperature, 300 K, and `TC.NPOW`; polynomial and reciprocal forms use their corresponding coefficients. Preserve the exact equation and coefficient sign convention from the release manual when fitting data.

Do not add `TCON.POWER` merely because a simulation is non-isothermal: it overrides/selects a particular thermal-conductivity law. First inspect the built-in material model using `MODELS ... PRINT`.

### Anisotropic thermal conductivity

For 4H-SiC or another anisotropic material, identify the crystallographic heat-flow axes. The manual provides `TANI.CONST`, `TANI.POWER`, `TANI.POLYNOM`, or `TANI.RECIP` with `A.TC.*` parameters for the anisotropic component, plus axis/direction controls such as `YDIR.ANISO`, `ZDIR.ANISO`, coordinate vectors, and `TC.FULL.ANISO`.

Do not assume the device vertical axis is the anisotropic axis. In Giga2D the anisotropic component is applied in Y; in Giga3D it is Z by default unless changed. Record the crystal-to-device coordinate transformation.

## Doping-dependent thermal conductivity

The ordinary `TCON.CONST/POWER/POLYNOM/RECIP` models depend on temperature, not automatically on local doping. Two valid strategies are available.

### Strategy A: separate material regions

If the structure already has physically distinct, approximately uniform doping layers, assign each region its own thermal law:

```atlas
material region=<drift_region> tcon.power tc.const=<k_drift_300> tc.npow=<n_drift>
material region=<substrate_region> tcon.power tc.const=<k_sub_300> tc.npow=<n_sub>
material region=<collector_region> tcon.power tc.const=<k_col_300> tc.npow=<n_col>
```

This is transparent and robust, but creates stepwise `k` and cannot represent a continuously varying implant profile. Do not split regions solely by doping without checking that electrical interfaces and meshes remain correct.

### Strategy B: C-Interpreter `F.TCOND`

Atlas 5.30 explicitly supports thermal conductivity as a function of lattice temperature, position, doping, and composition:

```atlas
material region=<n> f.tcond=<tcond_function_file>
```

The file implements the Atlas `TCOND()` C-Interpreter template. Use it for a continuous relationship such as `k(T, Ntotal)` or separate donor/acceptor dependence when the template exposes those variables. Obtain the exact template/signature from the installed C-Interpreter documentation; do not invent a function prototype.

Implementation requirements:

1. Convert all input/output units explicitly.
2. Define whether concentration means net doping, total ionized impurity, or chemical donor plus acceptor concentration.
3. Bound or extrapolate the fit outside its measured doping/temperature range deliberately.
4. Guarantee positive finite `k` and smooth derivatives across mesh nodes.
5. Test several known `(T,N)` points independently before device simulation.
6. Run mesh and thermal-model sensitivity studies.

Thermal conductivity versus doping is material, polytype, isotope, defect, and temperature dependent. Treat every coefficient as `must-calibrate` or at least `literature-start`; never transfer silicon doping-degradation data to 4H-SiC.

## Gate oxide and SiC/SiO2 interface

### Explicit oxide, no additional interface resistance

If SiO2 is an explicit region, assign its bulk conductivity by material or region:

```atlas
material region=<oxide_region> tcon.const tc.const=<k_oxide>
```

Atlas then conducts heat through the adjacent semiconductor and oxide regions with the ordinary heat equation. This captures bulk oxide resistance `tox/kox`, but does not by itself introduce a finite thermal boundary resistance or temperature jump at the SiC/SiO2 interface.

### Add an internal interface resistance

No dedicated two-sided SiC/SiO2 interface thermal-conductance statement was identified in the installed Atlas 5.30 manual. Represent `R''int` with a thin explicit interfacial region of thickness `tint` and effective conductivity:

```text
kint = tint / R''int = Gint * tint
```

where `tint` is in cm, `R''int` in cm2 K/W, `Gint` in W/(cm2 K), and `kint` in W/(cm K).

```atlas
region number=<int_region> material=<user_insulator> <thin interface bounds>
material region=<int_region> tcon.const tc.const=<Gint_times_tint>
```

Requirements:

- mesh the interfacial layer through its thickness;
- keep its electrical permittivity/band treatment intentional so it does not accidentally change gate electrostatics;
- if adding a separate layer would alter the electrical oxide thickness, reduce the neighboring oxide thickness or use a thermally equivalent layer definition consistently;
- run a thickness-invariance test: change `tint` and scale `kint=Gint*tint`; the total thermal result should remain stable;
- distinguish SiC/SiO2 boundary resistance from the bulk oxide resistance and gate-metal/oxide boundary resistance.

### Why `THERMCONTACT` is usually wrong here

`THERMCONTACT` couples a selected boundary to an external reservoir `EXT.TEMP`; it is not a generic conservative heat-transfer law between two independently solved adjacent regions. Using it at the internal SiC/SiO2 interface can create an artificial heat sink/source. Only use an internal `THERMCONTACT ... ^BOUNDARY` if the intended model truly treats that surface as coupled to a prescribed external thermal reservoir.

## Collector/backside thermal boundary

### Ideal isothermal collector

If the collector electrode is assumed perfectly clamped to ambient:

```atlas
thermcontact num=1 elec.num=<collector_electrode_number> ext.temp=<Tamb_K>
```

Omitting `ALPHA` selects a fixed-temperature boundary according to the manual. This is an idealization and normally underestimates device temperature rise.

### Finite backside/package conductance

```atlas
thermcontact num=1 elec.num=<collector_electrode_number> \
  ext.temp=<Tamb_K> alpha=<Gext_W_per_cm2K>
```

The manual defines:

```text
R''th = 1 / ALPHA
heat flux = ALPHA * (Tlattice - Text)
```

For a one-dimensional layer stack:

```text
R''total = sum(ti/ki) + sum(R''interface,i)
ALPHA = 1/R''total
```

Use thickness `ti` in cm and `ki` in W/(cm K). Include substrate thinning, backside metal, die attach, solder, TIM, and package/heatsink spreading only to the fidelity represented by the boundary. If lateral spreading matters, model the corresponding regions geometrically instead of collapsing everything into one `ALPHA`.

Local examples demonstrate both coordinate and electrode placement:

```atlas
thermcontact num=1 elec.num=3 ext.temp=300
thermcontact num=1 y.min=<backside> y.max=<backside> ext.temp=300 alpha=1000
```

Example `ALPHA` values are demonstrations, not package data.

### Internal or extended collector electrodes

By default, `BOUNDARY` applies the condition only on the outside surface. If an electrode/contact extends internally and the condition must apply to its interior-facing surfaces, the manual provides:

```atlas
thermcontact num=1 elec.num=<n> ^boundary ext.temp=<Tamb> alpha=<G>
```

Use this cautiously: it can apply heat loss on more faces than a real backside package contact. Inspect the selected faces in the saved structure.

## Calibration and verification checklist

- Confirm `LAT.TEMP` is active and output lattice temperature/heat flux.
- Use `MODELS ... PRINT` to record the active thermal model and constants.
- Audit W/(m K) versus W/(cm K), m versus cm, and K m2/W versus K cm2/W.
- Separate bulk semiconductor, oxide, internal TBR, and external package resistance.
- Verify energy balance: generated electrical power versus integrated boundary heat flux.
- Refine mesh at heat-generation peaks, thin oxides/interface layers, trench corners, and thermal contacts.
- Compare fixed-temperature and realistic finite-`ALPHA` boundaries to quantify boundary sensitivity.
- Calibrate steady-state thermal resistance and transient thermal impedance separately; transient work also requires heat capacity and may use `THERMCONTACT BETA`.
- Do not alter a thermal resistor inside a `SOLVE` sequence unless using the release-supported `THERMCONTACT ... MODIFY` workflow; rerun when comparing boundary resistances.

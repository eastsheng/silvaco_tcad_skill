# 4H-SiC materials, interfaces, and contacts

Verify the installed material token; do not assume `SiC` and `4H-SiC` are interchangeable.

```atlas
region number=1 material=4H-SiC ...
material material=4H-SiC <parameter>=<value>
```

`MATERIAL` can override bandgap and temperature law, affinity, permittivity, density of states, effective masses, mobility, saturation velocity, lifetime, thermal conductivity, and heat capacity.

4H-SiC is wide-bandgap and anisotropic. Record crystal orientation, temperature and doping range, formula, and source for transport and avalanche coefficients. Changing affinity also changes band alignment; changing bandgap changes intrinsic density; lifetime changes leakage and bipolar conduction.

## Contacts

```atlas
contact name=source
contact name=drain
contact name=anode workfunction=<metal_work_function_eV>
contact name=source resistance=<value>
```

Work function sets ideal Schottky alignment. Interface states, image-force lowering, tunnelling, barrier inhomogeneity, and damage affect measured behavior. Calibrate against temperature-dependent I-V/C-V. Check resistance dimensional conventions and 2D normalization.

## Interface

```atlas
interface qf=<cm-2> x.min=<um> x.max=<um> y.min=<um> y.max=<um>
```

`QF` is fixed sheet charge, not an energy-distributed interface-trap model. Distinguish fixed charge, interface states, near-interface oxide traps, bulk charge, and mobile charge.

## Thermal boundary

```atlas
thermcontact name=drain temperature=300
```

Use `THERMCONTACT` with self-heating to define heat sinking or thermal resistance.

## Mistakes

- Silicon defaults used for SiC transport or avalanche.
- Coefficients mixed across formulas or orientations.
- Schottky leakage fitted only through work function.
- Unbounded `QF` applied to unintended interfaces.
- Self-heating enabled without physical thermal boundaries.


# Local SiC Example Patterns

These notes summarize patterns observed in Silvaco SiC example decks, typically found under a discovered examples directory such as `<SILVACO_EXAMPLES_DIR>\sic`. They are intended for expert guidance when adapting vendor examples to SiC power-device research decks.

## 4H-SiC Material Blocks

Common pattern:

```atlas
region number=1 material=4H-SiC
material material=4H-SiC ...
models srh ...
```

Physical meaning:

- `region ... material=4H-SiC` selects the semiconductor material and enables SiC material handling.
- `material material=4H-SiC` overrides or supplements properties such as carrier lifetime, affinity, permittivity, band parameters, or ionization-related coefficients.
- `models srh` enables Shockley-Read-Hall recombination, usually required for leakage, lifetime, and transient defect work.

Common mistakes:

- Using a silicon example without replacing `Silicon` material assumptions.
- Treating a 3C-SiC example as a 4H-SiC calibration source.
- Changing material constants to force curve fitting without recording the physical source.

## Anisotropic Impact Ionization

Observed pattern:

```atlas
impact aniso sic4h0001 e.side
```

or coefficient-specific forms such as:

```atlas
impact aniso e.side ...
```

Physical meaning:

- SiC avalanche behavior is orientation dependent; anisotropic impact ionization is often essential for 4H-SiC breakdown studies.
- `sic4h0001` indicates a 4H-SiC orientation-oriented model choice in the example.
- `e.side` uses the electron-side contribution form in the example setup.

Common mistakes:

- Running reverse breakdown with no impact model and interpreting leakage divergence as breakdown.
- Reusing silicon impact coefficients for 4H-SiC.
- Forgetting to state the breakdown criterion, such as current density threshold or solver snapback point.
- Using a coarse mesh near Schottky edges, P+ junction corners, trench corners, or oxide corners.

## Extended Precision and High-Voltage Sweeps

Observed pattern:

```atlas
go atlas simflags="-80"
go atlas simflags="-128"
go atlas simflags="-160"
```

Physical meaning:

- High-voltage SiC simulations can involve very small carrier densities, large electric fields, and stiff nonlinear systems.
- Extended precision may improve numerical robustness or allow comparison of breakdown-voltage stability across arithmetic precision.

Common mistakes:

- Assuming extended precision fixes a physically bad mesh or bad model set.
- Starting the reverse sweep with huge voltage steps.
- Comparing precision results without holding mesh, bias sequence, model stack, and extraction criterion fixed.

## MOSFET Interface and Mobility

Observed patterns:

```atlas
region ... material=oxide
mobility material=4H-SiC ...
models srh fldmob ...
interface charge=...
inttrap acceptor ...
inttrap donor ...
```

Physical meaning:

- SiC MOSFET behavior is strongly affected by the SiC/oxide interface.
- `interface charge` represents fixed interface charge.
- `inttrap` describes interface trap states; these can shift threshold voltage and degrade channel mobility.
- `fldmob`, `conmob`, and custom mobility parameters control field- and concentration-dependent transport behavior.

Common mistakes:

- Fitting threshold voltage using fixed charge alone while ignoring trap distribution.
- Forgetting temperature dependence for channel mobility and incomplete ionization.
- Extracting on-resistance before verifying current spreading, contact resistance assumptions, and channel mobility calibration.

## Schottky and JBS Diodes

Observed patterns:

```atlas
electrode name=anode material=...
contact name=anode workfunction=...
models Temp=300 BGN Analytic SRH ...
models ... incomplete inc.ion
impact aniso ...
log outfile=...
save outfile=...
```

Physical meaning:

- `contact ... workfunction=...` controls the Schottky barrier setup.
- `incomplete` / `inc.ion` are important in wide-bandgap SiC because dopant ionization can be incomplete at room temperature and below.
- JBS examples add P+ regions to shield the Schottky contact under reverse bias.

Common mistakes:

- Confusing metal work function with the final effective barrier height.
- Omitting image-force lowering, interface states, or barrier inhomogeneity when trying to match measured leakage.
- Comparing SBD and JBS reverse I-V without checking the anode electrode naming and P+ shielding geometry.
- Not saving the high-voltage structure at breakdown, which makes field-crowding diagnosis difficult.

## DLTS and Trap Transients

Observed patterns:

```atlas
trap region=1 acceptor e.level=... density=...
models print temp=...
log outfile=...
extract name=...
```

Physical meaning:

- DLTS examples model capacitance transient response from electrically active defects.
- Trap energy, density, cross sections, temperature, and transient timing all affect the extracted signal.

Common mistakes:

- Treating a DLTS trap level as a universal SiC defect without verifying measurement conditions.
- Mixing bulk traps and interface traps.
- Using DC-only solve logic for a transient trap-emission problem.




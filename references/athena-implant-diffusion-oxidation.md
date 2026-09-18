# Athena Implant, Diffusion, Activation, and Oxidation

Read this for process physics and calibration. Commands below establish syntax; no numeric example is a transferable process recipe.

## Implant decision contract

```atlas
implant <species> dose=<cm-2> energy=<keV> \
  <gauss|pearson|full.lat|bca> <crystal|amorphous> \
  tilt=<deg> rotation=<deg>
```

- The 2015 manual defaults to `CRYSTAL`, `TILT=7`, and `ROTATION=30`; always state these explicitly in reproducible work.
- Dose is defined in the plane normal to the beam. `FULL.DOSE` compensates dose by `1/cos(tilt)`; declare whether this convention matches fabrication data.
- Analytical models use release tables/moments. `S.OXIDE` is an implant-model screen-oxide input and is not inferred from the structure; keep it synchronized with the actual screen stack or document why not.
- Use `PROFILE` with measured/extracted SIMS when calibrated data are stronger than an analytic model.
- BCA/Monte Carlo requires convergence in ion count/seed/smoothing as applicable. The 2015 defaults cited for `N.ION` are 1,000 in 1D and 10,000 in 2D without sampling; treat them as syntax baselines, not research-quality convergence.
- Damage, activation and diffusion are separate models. An implanted chemical profile is not an active-dopant profile.

## 4H-SiC implant orientation

Athena uses `SIC_4H` in this release. For BCA SiC work, record `ROT.SUB`, beam `TILT/ROTATION`, and wafer `MISCUT.TH/MISCUT.PH`. The manual states that miscut angles are measured in the internal crystallographic coordinate system, not the laboratory frame defined by `ROT.SUB`.

Built-in syntax example:

```atlas
init sic_4h rot.sub=<0_or_90>
implant aluminum dose=<dose> energy=<keV> bca \
  n.ion=<converged_count> tilt=<beam_tilt> rotation=<beam_rotation> \
  miscut.th=<wafer_miscut> miscut.ph=<miscut_azimuth>
```

Use complementary beam rotations for both trench sidewalls where required. Do not reuse the manual's demonstration dose/energy as a device design. Calibrate depth/lateral profiles, channeling, damage and activation against SiC-specific data.

## Diffusion/anneal contract

```atlas
method <material-and-process-appropriate model>
diffuse time=<value> <seconds|minutes|hours> temperature=<C> \
  <nitrogen|inert|dryo2|weto2>
```

- `TIME` defaults to minutes and ambient pressure defaults to 1 atmosphere in the 2015 manual; state both explicitly.
- The manual warns that its standard diffusion coefficients may be inaccurate outside 700–1200 °C. That range is silicon-centric and does not validate SiC anneals.
- `METHOD FERMI/TWO.DIM/STEADY/FULL.CPL` selects point-defect coupling complexity. `FERMI` is the 2015 default.
- Advanced `PLS/IC/VC/DDC/SS` models are documented only for B/P/As in silicon and have restrictions with simultaneous oxidation/silicidation. Do not apply them to SiC.
- Reproduce temperature ramps explicitly with start/final/rate; checkpoint long anneals using supported dump controls.
- Material-specific diffusivity, segregation, clustering, activation, damage recovery and interface dose loss are `must-calibrate`.

## Oxidation contract

`DIFFUSE ... DRYO2/WETO2` performs oxidation using the chosen `METHOD` and `OXIDE` parameters. In the 2015 manual, `COMPRESS` is the default moving-boundary oxidation model; `VISCOUS` adds incompressible flow/stress behavior; ERF variants are restricted analytic bird's-beak approximations.

For SiC, do not treat silicon Deal–Grove defaults as calibrated. Verify installed SiC support, face dependence, ambient, pressure and interface consumption. If physical SiC oxidation cannot be calibrated, construct the measured oxide geometry explicitly and label it as geometry—not predicted oxidation.

## Calibration sequence

1. Fit implant depth/lateral profiles and dose conservation before anneal.
2. Fit activation and redistribution versus thermal budget.
3. Fit oxide thickness/consumption by face and feature.
4. Validate junction depth and active concentration after the complete sequence.
5. Only then use the exported structure for Atlas electrical calibration.

Report chemical and active concentrations separately and save pre/post implant, anneal and oxidation checkpoints.

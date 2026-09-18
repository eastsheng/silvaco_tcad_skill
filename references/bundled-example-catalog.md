# Bundled Example Catalog

Use these examples before searching the local Silvaco installation or manual. They are compact research templates assembled from the bundled rules and verified vendor patterns. They are not calibrated production devices.

| Request | Read first | Built-in pattern |
| --- | --- | --- |
| MOSFET geometry, gate oxide, electrodes, mesh | `bundled-sic-mosfet-examples.md` | planar-cell structure and trench refinement |
| MOSFET transfer/output | `bundled-sic-mosfet-examples.md` | independent state initialization and extraction |
| 4H-SiC IGBT output/self-heating | `bundled-sic-igbt-examples.md` | gate-conditioned Ic-Vce with finite backside thermal conductance |
| IGBT short-circuit/latch-up | `bundled-sic-igbt-examples.md` | blocking-state load, transient gate ramp, full heat sources |
| IGBT/MOSFET breakdown | `bundled-sic-igbt-examples.md` | staged voltage sweep, compliance, current continuation |
| Constant/T-dependent/doping-dependent k | `bundled-thermal-examples.md` | `TCON.*`, region split, `F.TCOND` |
| SiC/SiO2 TBR | `bundled-thermal-examples.md` | explicit thin thermal-interface layer |
| Collector/package cooling | `bundled-thermal-examples.md` | fixed-temperature versus finite-`ALPHA` boundary |
| Process-built MOSFET/IGBT/diode/termination | `bundled-athena-examples.md` | substrate, multilayer mask, etch, implant, anneal, oxide, metal and handoff |
| Trench, spacer, guard ring, field plate | `bundled-athena-examples.md` | polygon etch, directional/isotropic etch, mirrored cell and repeated windows |
| Reproduce/adapt an installed MOSFET, IGBT or HEMT case | `local-mosfet-igbt-hemt-reproduction.md` | exhaustive source-availability map, run graph, dependencies and family-specific contracts |
| HEMT/HFET/PHEMT/GaN FET structure and characteristics | `bundled-hemt-models-and-examples.md` | layers, heterojunctions, polarization, traps, DC, breakdown, collapse, RF and electrothermal routes |

## Adaptation contract

Before copying a template, replace every `<...>` placeholder and document:

- coordinate axes, cell pitch/width, current normalization, and terminals;
- 4H-SiC crystal orientation;
- source of every explicit material/model coefficient;
- temperature and doping validity range;
- thermal boundary and package assumptions; and
- target extraction criterion.

Use local examples only if no bundled pattern covers the needed simulator flow, syntax is rejected, a version-dependent default must be confirmed, or a convergence/physics failure remains unexplained. Use the installed manual only after the example fallback cannot answer the exact equation, unit, parameter, default, or compatibility question.

## Safety labels

- `<geometry>`: device-design input; never infer it from a generic example.
- `<calibrate>`: must be obtained from measurement or a cited material/device dataset.
- `<version-check>`: verify only if the installed simulator rejects or materially changes this feature.
- Values explicitly described as Atlas 5.30 manual baselines are initialization references, not measured calibration.

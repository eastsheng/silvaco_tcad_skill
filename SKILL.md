---
name: sic-power-device-tcad-research-skill
description: Silvaco power-device modeling with the priority Atlas, then Athena, then DevEdit, for reproducible MOSFET, IGBT, HEMT/HFET, PHEMT, GaN FET, and complex SiC device decks. Use for local-example reproduction, direct or process-based structures, mesh, gate oxide, electrodes, doping, heterojunctions, polarization, traps, electrothermal models, electrical characteristics, convergence, or nonphysical results, without requiring Victory Process.
---

# SiC Power Device TCAD Research

Solve from the bundled references and examples first. Distinguish bundled template behavior, manual-defined behavior, engineering recommendations, vendor example patterns, and calibration assumptions.

## Workflow

1. Identify device, planar/trench topology, dimensionality, symmetry/cell pitch, target quantity, temperature, and operating mode.
   - Apply the modeling-tool priority strictly: **Atlas first, Athena second, DevEdit third**.
   - Use Atlas direct geometry whenever `MESH`, `REGION`, `ELECTRODE`, and `DOPING` can represent the intended structure and the task does not require process-history prediction.
   - Escalate to Athena only when deposition/etch/oxidation/implant/diffusion history, lateral straggle, activation, or process-shaped geometry affects the result.
   - Use DevEdit only after Atlas or Athena when imported/process mesh quality, local interface/junction refinement, or complex geometry cleanup cannot be handled adequately in the originating tool.
2. Route to the bundled knowledge and examples before searching outside the skill:
   - Example catalog and selection: `references/bundled-example-catalog.md`
   - MOSFET built-in examples: `references/bundled-sic-mosfet-examples.md`
   - IGBT electrothermal/latch-up/breakdown built-in examples: `references/bundled-sic-igbt-examples.md`
   - Thermal conductivity/interface/boundary built-in examples: `references/bundled-thermal-examples.md`
   - Athena complex-process built-in examples: `references/bundled-athena-examples.md`
   - Complete local MOSFET/IGBT/HEMT inventory and reproduction map: `references/local-mosfet-igbt-hemt-reproduction.md` (read first for reproducing or adapting any local transistor example)
3. Read the relevant bundled references:
   - IGBT/MOSFET geometry, mesh, oxide, and electrodes: `references/igbt-mosfet-structure.md` (read first for any IGBT or MOSFET structure task)
   - Transfer/output/latch-up/breakdown model and parameter matrix: `references/device-characteristics-model-matrix.md` (read for any electrical-characteristic task)
   - Bulk/doping-dependent thermal conductivity and gate-oxide/collector thermal boundaries: `references/thermal-properties-and-boundaries.md` (read for any self-heating or thermal-interface task)
   - Complete 4H-SiC IGBT electrothermal model stack and Atlas-default audit: `references/sic-igbt-electrothermal-models.md` (read first for SiC IGBT electrothermal simulations)
   - Athena process construction, geometry, mesh, and simulator handoff: `references/athena-complex-structure.md` (read first for process-built structures)
   - Language and commands: `references/atlas-command-index.md`
   - Mesh, regions, electrodes, doping: `references/structure-mesh-doping.md`
   - SiC properties and contacts: `references/sic-materials-contacts.md`
   - Physical models: `references/physics-models.md`
   - Solver and extraction: `references/solver-and-extraction.md`
   - Device procedures: `references/sic-power-workflows.md`
   - Diagnosis: `references/common-mistakes.md`
   - Deck patterns: `references/deck-examples.md`
4. Search the local TCAD example library or installed manual only when the bundled material cannot resolve the request, a command/default is version-dependent or unsupported, the generated deck fails, or the user explicitly requests local/manual evidence:
   - Prefer a path explicitly provided by the user.
   - Check `SILVACO_EXAMPLES_DIR`, `TCAD_EXAMPLES_DIR`, `SILVACO_HOME`, and `SEDATOOLS_HOME`.
   - On Windows, run `scripts/find-silvaco-examples.ps1 -Json`. Treat `DeckCount`, not index text, as evidence that decks are installed.
   - For MOSFET/IGBT/HEMT source inventory, run `scripts/index-mosfet-igbt-hemt-examples.ps1 -Root <version-root> -Format Json`. Treat a main `.in` as source evidence; HTML/index-only cases are documentation-only.
   - Read `references/tcad-example-discovery.md`, then as needed: `references/local-silvaco-examples-index.md`, `references/local-sic-example-patterns.md`, `references/local-deck-derived-rules.md`, and `references/local-example-adaptation-checklist.md`.
   - Consult the installed manual after bundled examples and local vendor decks still leave syntax, equation, unit, default, or version behavior unresolved.
   - State what bundled route failed or remained uncertain before using the fallback source.
5. Follow the selected route:
   - Atlas-only: coordinate contract -> mesh -> regions/gate oxide -> electrodes -> doping -> material/contact/interface -> models -> method -> solve -> log/save/extract.
   - Atlas + DevEdit: create/export the direct structure -> use DevEdit only for necessary mesh/geometry refinement -> return to Atlas.
   - Athena + Atlas: process coordinate contract -> process mesh -> substrate/epitaxy -> mask/deposit/etch -> implant/diffusion/oxidation -> contacts/electrodes -> structure audit -> Atlas.
   - Athena + DevEdit + Atlas: use only when the Athena structure needs device-oriented remeshing or cleanup before Atlas.
6. State units and never silently transfer silicon defaults or literature coefficients to 4H-SiC.
7. Separate syntax validity, numerical convergence, and physical calibration.
8. For breakdown, ramp progressively and state the breakdown criterion. For self-heating, define thermal boundaries.
9. Verify version-, polytype-, orientation-, and model-dependent parameters against the installed Atlas release only when they affect the requested result; use fallback discovery rather than browsing the manual preemptively.
10. Do not require or recommend Victory Process unless the user explicitly asks for it. Keep every default solution compatible with the priority `Atlas -> Athena -> DevEdit`. When inspecting a vendor deck that happens to use Victory, extract transferable geometry/mesh ideas only and provide an Atlas-first compatible route.
11. When adapting a vendor deck, report its simulator, required modules, installed example version, and whether every referenced support file is present.
12. Select physics per characteristic and material, not by copying one universal `MODELS` line. Classify every explicit parameter as `keep-default`, `version-check`, `literature-start`, or `must-calibrate`.
13. Distinguish bulk thermal conductivity (`MATERIAL`), adjacent-region interface resistance, and heat-sink boundary conductance (`THERMCONTACT`). Never use one as an undocumented substitute for another.
14. For 4H-SiC IGBT electrothermal work, list every enabled model, every controlling parameter, its unit, Atlas release/default source, override status, and calibration evidence. Treat absent, conflicting, or unprinted defaults as unknown—not zero and not trustworthy.
15. For a reproduction request, inspect the complete example directory and return the main/auxiliary run graph. Never copy only one `.in`, mistake generated checkpoints for startup dependencies, or claim a documentation-only index entry is executable.
16. For HEMT/HFET work, preserve the heterostructure layer/composition table, band alignment, polarization method, interface/surface charge and traps, Schottky/ohmic contact assumptions, transport model, stress history, and DC/AC/transient initialization. Do not transfer GaAs, GaN, Si, or SiC parameters across materials.

## Output expectations

- Explain syntax, parameter role, physical meaning, and likely failure mode.
- For IGBT/MOSFET structures, return a coordinate table for every region and electrode, oxide thickness at the channel and trench bottom/corner, and a mesh-refinement table tied to physical features.
- For Athena process flows, return a chronological process table with purpose, command, geometry/material change, mesh consequence, calibration requirement, and saved checkpoint.
- For local reproduction, return source version/path, module requirements, all startup dependencies, simulator/run graph, generated checkpoints and the exact state used to begin each characteristic.
- For electrical characteristics, return the bias protocol, required/optional models, exact command family, parameter-modification table, extraction definition, and validation data needed for that material.
- Give minimal fragments with explicit placeholders.
- Preserve electrode names across `ELECTRODE`, `CONTACT`, `SOLVE`, and extraction.
- Require mesh and bias convergence studies for research claims.
- When using local examples, cite the discovered path and example name.
- Label facts as one of: `manual-defined`, `vendor-example pattern`, `engineering recommendation`, or `calibration assumption`.
- Never invent calibration data, measured agreement, module availability, or local example paths.

## Source scope

Derived from *Atlas User Manual*, Silvaco, June 1, 2020, especially Chapters 2-3, 8, 21-22 and Appendix B.7. Mistake notes are engineering interpretations.

Local example notes are vendor-pattern summaries from Silvaco example decks, especially the `sic` directory. Do not assume any fixed local path. On each computer, rediscover the installed Silvaco examples before relying on local files.



---
name: silvaco-tcad-skill
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
   - HEMT/HFET, PHEMT, GaN polarization/trap/breakdown/RF/electrothermal examples: `references/bundled-hemt-models-and-examples.md`
   - Complete local MOSFET/IGBT/HEMT inventory and reproduction map: `references/local-mosfet-igbt-hemt-reproduction.md` (read first for reproducing or adapting any local transistor example)
3. Read the relevant bundled references:
   - IGBT/MOSFET geometry, mesh, oxide, and electrodes: `references/igbt-mosfet-structure.md` (read first for any IGBT or MOSFET structure task)
   - Transfer/output/latch-up/breakdown model and parameter matrix: `references/device-characteristics-model-matrix.md` (read for any electrical-characteristic task)
   - Bulk/doping-dependent thermal conductivity and gate-oxide/collector thermal boundaries: `references/thermal-properties-and-boundaries.md` (read for any self-heating or thermal-interface task)
   - Complete 4H-SiC IGBT electrothermal model stack and Atlas-default audit: `references/sic-igbt-electrothermal-models.md` (read first for SiC IGBT electrothermal simulations)
   - Almpanis 2024 high-voltage SiC IGBT research lessons: `references/almpanis-2024-sic-igbt-research.md` (read for calibration order, false turn-on, short circuit/latch-up, collector-side optimisation, or 10-40 kV scaling)
   - HEMT layer, polarization, trap, contact, transport and bias protocols: `references/bundled-hemt-models-and-examples.md` (read first for any HEMT/HFET/PHEMT/GaN-FET task)
   - Athena process construction, geometry, mesh, and simulator handoff: `references/athena-complex-structure.md` (read first for process-built structures)
   - Athena 2015 source/version map: `references/athena-2015-manual-map.md` (read for manual provenance, module boundaries, or release-default checks)
   - Athena deck/restart/electrode contract: `references/athena-process-deck-contract.md` (read before generating or restarting a complete Athena flow)
   - Athena process mesh, deposition, etch, and oxide-grid rules: `references/athena-mesh-deposition-etch.md` (read for complex geometry and process mesh)
   - Athena implant, diffusion, activation, and oxidation: `references/athena-implant-diffusion-oxidation.md` (read for process-model selection and calibration)
   - Language and commands: `references/atlas-command-index.md`
   - Atlas 2018 source/version map: `references/atlas-2018-manual-map.md` (read when a bundled rule needs manual provenance or release comparison)
   - Atlas syntax, ordering, and state invariants: `references/atlas-language-and-deck-contract.md` (read before generating or auditing any complete deck)
   - Model/parameter evidence rules: `references/atlas-model-selection-and-parameter-evidence.md` (read when selecting models, defaults, coefficients, or overrides)
   - Numerical and bias state machine: `references/atlas-numerics-and-bias-state-machine.md` (read for sweeps, restart, breakdown, latch-up, or convergence work)
   - DeckBuild 2018 source map: `references/deckbuild-2018-manual-map.md` (read for command provenance and release behavior)
   - DeckBuild run graph, variables, loops, batch and source files: `references/deckbuild-run-orchestration.md` (read for multi-simulator or parameterized runs)
   - DeckBuild extraction and sweep governance: `references/deckbuild-extract-and-sweeps.md` (read for every reported scalar/curve or extract-driven branch)
   - TonyPlot 2018 source map: `references/tonyplot-2018-manual-map.md` (read for command-line, set-file and overlay provenance)
   - TonyPlot quantitative audit: `references/tonyplot-quantitative-audit.md` (read for mesh/field/thermal inspection, cutlines, overlays or figures)
   - Bundled DeckBuild/TonyPlot patterns: `references/bundled-deckbuild-tonyplot-examples.md`
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
   - Athena + Atlas: process coordinate contract -> process mesh -> substrate/verified epitaxy or imported stack -> mask/deposit/etch -> implant/diffusion/oxidation -> contacts/electrodes -> structure audit -> Atlas.
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
17. Treat a deck as an ordered state machine. Record inherited electrode biases, reload a common conditioning state for every curve-family branch, and reissue thermal contacts after every Atlas restart because they are not stored in solution files.
18. Do not use `INTDEFECTS` as a generic SiC MOS interface-state command: the Atlas 2018 manual documents it for TFT band-gap interface defects. Require installed-release evidence for the intended SiC equation before enabling it.
19. Treat Athena `STRUCTURE` files as geometry/mesh/solution checkpoints, not complete process recipes. Reissue non-persistent model and machine definitions after restart and verify equivalence with the uninterrupted flow.
20. In the Athena 2015 source, `EPITAXY` is silicon-on-silicon and inherently 1D; never present it as SiC epitaxy physics. Without Elite, `DEPOSIT` is conformal geometry. Label every Athena step as physical model, calibrated geometry, or imported profile.
21. In reproducible implant decks, state `CRYSTAL/AMORPHOUS`, tilt, rotation, dose convention, screen stack, model/table source, damage, activation, and statistical convergence. Never accept the 2015 implicit implant angles as intentional settings.
22. Model a DeckBuild workflow as a serial process chain followed by independent device-characteristic branches. Do not let transfer, output, breakdown, latch-up, or electrothermal branches inherit unintended state from one another.
23. Every extracted metric must declare its source state, mathematical criterion, search window, coordinate/material scope, unit, normalization, valid range and failure behavior. Ensure required spatial fields are requested with Atlas `OUTPUT` before `SAVE`.
24. A TonyPlot image is not sufficient evidence by itself. Preserve numeric source files, simulator and plot versions, `.setx`, overlay order, cutline/cutplane coordinates, transforms, axes/units and export geometry.
25. When applying research produced in another TCAD simulator, transfer physical relationships and validation logic first. Translate commands or coefficients only after proving equation, units, carrier order, orientation and temperature-law equivalence in the installed Atlas release.
26. For SiC IGBT short-circuit claims, continue beyond gate turn-off until post-turn-off leakage and temperature clearly decay or a declared failure criterion is met. Classify high-temperature results as validated, interpolated or extrapolated; do not call predictions above the source model's validation ceiling experimentally validated.

## Output expectations

- Explain syntax, parameter role, physical meaning, and likely failure mode.
- For IGBT/MOSFET structures, return a coordinate table for every region and electrode, oxide thickness at the channel and trench bottom/corner, and a mesh-refinement table tied to physical features.
- For Athena process flows, return a chronological process table with purpose, command, geometry/material change, mesh consequence, calibration requirement, and saved checkpoint.
- For every Athena operation, classify it as `physical process model`, `calibrated geometry construction`, or `imported measured/profile data`, and state the required module.
- For local reproduction, return source version/path, module requirements, all startup dependencies, simulator/run graph, generated checkpoints and the exact state used to begin each characteristic.
- For electrical characteristics, return the bias protocol, required/optional models, exact command family, parameter-modification table, extraction definition, and validation data needed for that material.
- For a multi-run study, return the DeckBuild run graph, common checkpoints, branch-specific declarations, source-file manifest, deterministic filenames and results-file schema.
- For figures, return the TonyPlot artifact manifest and pair visual hot-spot claims with numeric extraction or exported data.
- Give minimal fragments with explicit placeholders.
- Preserve electrode names across `ELECTRODE`, `CONTACT`, `SOLVE`, and extraction.
- Require mesh and bias convergence studies for research claims.
- When using local examples, cite the discovered path and example name.
- Label facts as one of: `manual-defined`, `vendor-example pattern`, `engineering recommendation`, or `calibration assumption`.
- Never invent calibration data, measured agreement, module availability, or local example paths.

## Source scope

Derived from *Atlas User Manual*, Silvaco, June 1, 2020, and expanded from the local manuals: *Atlas User's Manual* (April 10, 2018, 1776 pages), *Athena User's Manual* (August 13, 2015, 444 pages), *DeckBuild User's Manual* (February 5, 2018, 241 pages), and *TonyPlot User's Manual* (February 16, 2018, 183 pages). Release-specific defaults and command behavior must be verified against the installed tools. Mistake notes are engineering interpretations.

Local example notes are vendor-pattern summaries from Silvaco example decks, especially the `sic` directory. Do not assume any fixed local path. On each computer, rediscover the installed Silvaco examples before relying on local files.

High-voltage SiC IGBT calibration, false-turn-on, short-circuit and collector-side optimisation guidance also distils Ioannis Almpanis, *Silicon Carbide (SiC) Insulated Gate Bipolar Transistors (IGBTs) for High Voltage Applications*, PhD thesis, University of Nottingham, April 2024. The thesis used Sentaurus; its values are research evidence rather than Atlas syntax or defaults.



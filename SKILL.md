---
name: sic-power-device-tcad-research-skill
description: Silvaco Atlas knowledge and research workflow for 4H-SiC power devices. Use for creating, explaining, reviewing, or debugging Atlas decks for SiC MOSFETs, Schottky and PiN diodes, JBS/MPS diodes, JFETs, and related structures; selecting mesh, material, mobility, recombination, impact-ionization, trap, thermal, contact, solver, bias-ramp, and extraction settings; locating local Silvaco/DeckBuild example decks across different computers; or diagnosing convergence and nonphysical results.
---

# SiC Power Device TCAD Research

Base every answer on the bundled references. Distinguish manual-defined behavior from engineering recommendations, vendor example patterns, and calibration assumptions.

## Workflow

1. Identify device, dimensionality, target quantity, temperature, and operating mode.
2. If the task needs local Silvaco examples, locate them for the current computer before using path-specific notes:
   - Prefer a path explicitly provided by the user.
   - Check `SILVACO_EXAMPLES_DIR`, `TCAD_EXAMPLES_DIR`, `SILVACO_HOME`, and `SEDATOOLS_HOME`.
   - On Windows, run `scripts/find-silvaco-examples.ps1` from this skill folder when tool access permits.
   - Read `references/tcad-example-discovery.md` for discovery rules and common locations.
3. Read the relevant references:
   - Language and commands: `references/atlas-command-index.md`
   - Mesh, regions, electrodes, doping: `references/structure-mesh-doping.md`
   - SiC properties and contacts: `references/sic-materials-contacts.md`
   - Physical models: `references/physics-models.md`
   - Solver and extraction: `references/solver-and-extraction.md`
   - Device procedures: `references/sic-power-workflows.md`
   - Diagnosis: `references/common-mistakes.md`
   - Deck patterns: `references/deck-examples.md`
   - TCAD example discovery: `references/tcad-example-discovery.md`
   - Local Silvaco example index: `references/local-silvaco-examples-index.md`
   - Local SiC example patterns: `references/local-sic-example-patterns.md`
   - Local example adaptation checklist: `references/local-example-adaptation-checklist.md`
4. Build decks in order: mesh -> regions -> electrodes -> doping -> material/contact/interface -> models -> method -> solve -> log/save/extract.
5. State units and never silently transfer silicon defaults or literature coefficients to 4H-SiC.
6. Separate syntax validity, numerical convergence, and physical calibration.
7. For breakdown, ramp progressively and state the breakdown criterion. For self-heating, define thermal boundaries.
8. Verify version-, polytype-, orientation-, and model-dependent parameters against the installed Atlas release.

## Output expectations

- Explain syntax, parameter role, physical meaning, and likely failure mode.
- Give minimal fragments with explicit placeholders.
- Preserve electrode names across `ELECTRODE`, `CONTACT`, `SOLVE`, and extraction.
- Require mesh and bias convergence studies for research claims.
- When using local examples, cite the discovered path and example name.
- Never invent calibration data, measured agreement, module availability, or local example paths.

## Source scope

Derived from *Atlas User Manual*, Silvaco, June 1, 2020, especially Chapters 2-3, 8, 21-22 and Appendix B.7. Mistake notes are engineering interpretations.

Local example notes are vendor-pattern summaries from Silvaco example decks, especially the `sic` directory. Do not assume any fixed local path. On each computer, rediscover the installed Silvaco examples before relying on local files.



# Atlas 2018 Manual Evidence Map

Use this reference when a bundled rule needs its manual basis, a command is version-sensitive, or the installed release differs from the examples. The source is *Atlas User's Manual*, Silvaco, April 10, 2018 (`atlas_users1.pdf`, 1776 pages). It supplements, rather than replaces, newer installed-manual evidence already represented in this skill.

## Evidence policy

- Prefer the focused bundled references for ordinary deck generation.
- Label facts from this source `manual-defined (Atlas manual, 2018)`.
- Treat a documented default as release-specific. Confirm it with `MODELS ... PRINT`, runtime output, or the installed manual before relying on it in another release.
- Do not copy a parameter table from PDF text extraction when its columns are shifted. Verify the rendered manual page or installed help instead.
- An example proves syntax and workflow for its release; it does not prove that its material coefficients fit a new device.

## High-value chapter map

| Chapter | Topic | Use in this skill |
| --- | --- | --- |
| 2 | Getting Started | syntax, command ordering, files, structure/model/method/solve workflow |
| 3 | Physics | statistics, incomplete ionization, mobility, recombination, avalanche, tunneling, traps |
| 4 | Material Database | built-in material scope and parameter inspection |
| 5 | S-Pisces | silicon MOSFET/IGBT physics; never transfer coefficients blindly to SiC |
| 6 | Blaze | compound/WBG materials and heterojunction behavior |
| 8 | Giga | lattice heat flow, conductivity, heat capacity, heat generation and thermal boundaries |
| 21 | Numerics | Gummel/Newton/block coupling, initial guesses, precision and convergence |
| 22 | Statements | exact statement syntax, units, flags and release defaults |

## Statement lookup map

For an exact syntax audit, go directly to Chapter 22 sections: `CONTACT` 22.12, `DOPING` 22.14, `ELECTRODE` 22.15, `IMPACT` 22.23, `INTDEFECTS` 22.26, `INTERFACE` 22.27, `LOAD` 22.35, `LOG` 22.36, `MATERIAL` 22.38, `MESH` 22.40, `METHOD` 22.41, `MOBILITY` 22.42, `MODELS` 22.43, `OUTPUT` 22.47, `PROBE` 22.50, `REGION` 22.54, `SAVE` 22.57, `SOLVE` 22.60, `THERMCONTACT` 22.63, and `TRAP` 22.66.

## Manual-derived invariants

- Atlas statements are generally case-insensitive; DeckBuild commands including `EXTRACT`, `SET`, `GO`, and `SYSTEM` are case-sensitive in this manual.
- The statement keyword comes first; parameter order on one statement is not significant.
- Abbreviate only to an unambiguous spelling. Use full names in generated decks unless adapting a verified vendor deck.
- Prefix a logical flag with `^` to clear it. `#` begins a comment. A trailing `\` continues a line. The 2018 manual states a 256-character line limit.
- Run vendor examples inside DeckBuild; the manual warns that standard examples may not run correctly in standalone Atlas.
- Avoid legacy `NODE`-indexed mesh construction and routine `REGRID`; the manual recommends location/spacing mesh syntax and identifies obtuse triangles as a `REGRID` risk.

## Version boundaries that matter

- `INTDEFECTS` is documented here as a TFT band-gap interface-defect model. Do not infer that it is the correct 4H-SiC MOS interface-state model.
- `SIC4H0001` and `SIC4H1120` occur in the 4H-SiC impact orientation controls, with `0001` described as the 2018 default. Confirm the device/crystal axis mapping and installed-release behavior before use.
- `LAT.TEMP` requires Giga in this manual. Licensing/module packaging may differ by installation.
- Thermal contacts are not stored in Atlas solution files; redefine them in every restarted Atlas run that solves lattice heat flow.

# Athena 2015 Manual Evidence Map

Use this reference when an Athena rule needs provenance, a command/default is release-sensitive, or a generated process deck fails. Source: *Athena User's Manual*, Silvaco, August 13, 2015 (`athena_users1.pdf`, 444 pages). This is a versioned source, not authority for a different installed release.

## High-value chapter map

| Chapter | Topic | Use here |
| --- | --- | --- |
| 1 | Introduction | Athena modules and capability boundaries |
| 2 | Tutorial | structure construction, grid, model choice, calibration, adaptive mesh |
| 3 | SSuprem4 models | diffusion, defects, oxidation, implant, deposition/etch, compounds, stress |
| 4 | Elite | string geometry, physical deposition/etch, reflow and CMP |
| 5 | Optolith | retain only when lithographic imaging materially sets the mask profile |
| 6 | Statements | exact command syntax, units, defaults and module restrictions |
| A | C-Interpreter | release-generated templates for custom process models |
| B/C | material/compatibility data | naming and legacy-deck interpretation |

## Statement lookup

Chapter 6 sections used most often: `DEPOSIT` 6.13, `DIFFUSE` 6.15, `ELECTRODE` 6.17, `EPITAXY` 6.18, `ETCH` 6.19, `IMPLANT` 6.28, `INITIALIZE` 6.30, `LINE` 6.33, `MATERIAL` 6.35, `METHOD` 6.36, `OXIDE` 6.40, `REGION` 6.53, `RELAX` 6.54, and `STRUCTURE` 6.63.

## Provenance rules

- Athena loads release defaults from `athenamod` at startup. Implant tables and advanced diffusion model files are also external release data. A manual example does not freeze those effective values.
- Use runtime output, `HELP`, the installed `athenamod`, and the installed manual to verify a release-sensitive default.
- PDF text extraction can shift table columns. Do not copy a numeric default unless the surrounding prose or rendered page confirms its parameter mapping.
- Label facts from this source `manual-defined (Athena manual, 2015)` and model coefficients from vendor decks `vendor-example pattern`.
- The manual describes multiple licensed modules. A documented statement does not prove that Elite, Optolith, adaptive meshing, BCA/Monte Carlo implant, or another module is installed.

## Important version boundaries

- In Athena, the 2015 material identifiers are `SIC_4H`, `SIC_6H`, and `SIC_3C`; Atlas/TonyPlot use their own standard display/material names. Audit the material mapping after export.
- The 2015 `EPITAXY` statement is limited to silicon on silicon, is inherently one-dimensional, and is unsuitable for selective epitaxy. Do not use it as a SiC epitaxy physics model.
- Without Elite, Athena deposition is 100% conformal with unit step coverage.
- The manual states a 20,000-node Athena limit for that release; treat it as historical/version-specific, not a current universal limit.
- `STRUCTURE` saves mesh and solution data but not model/machine definitions. A restarted process deck must reissue the required `METHOD`, `IMPURITY`, `MATERIAL`, `OXIDE`, rate-machine, and related statements.


# DeckBuild 2018 Manual Evidence Map

Use this reference for DeckBuild command provenance, batch behavior, extraction syntax, or release-sensitive orchestration. Source: *DeckBuild User's Manual*, Silvaco, February 5, 2018 (`deckbuild_users1.pdf`, 241 pages).

## High-value map

| Section | Topic | Use here |
| --- | --- | --- |
| Ch. 1 | execution and auto-interface concepts | serial process flow and device-test branches |
| Ch. 3 | batch, run controls, history, tracking | reproducible execution and diagnostics |
| Ch. 4 | DeckBuild statements | `GO`, `SET`, `ASSIGN`, conditionals, loops, `SOURCE`, `SYSTEM`, `TONYPLOT` |
| Ch. 5 | Extract | process/device extraction, curves, units, limits and Atlas output mapping |
| Ch. 6 | Optimizer | calibration parameters and targets; use only with identifiability safeguards |

## Evidence rules

- DeckBuild statements and simulator statements are different languages in one deck. Preserve the documented spelling/case requirements for the installed release.
- A GUI-generated deck is syntax assistance, not physical-model validation.
- A History restart is an interactive convenience. Publication/reproduction requires explicit named `STRUCTURE`/`SAVE` checkpoints and the declarations needed to reconstruct each simulator state.
- `SYSTEM` is blocking, disabled unless explicitly enabled, platform-dependent, and can mutate/delete files. Do not require it for the scientific workflow; use it only with explicit authorization and exact targets.
- `EXTRACT` built-ins and custom expressions can have different unit reporting. Record the unit and normalization independently.

## Statement lookup

Chapter 4: `ASSIGN` 4.2, `DEFINE/UNDEFINE` 4.4, `EXTRACT` 4.5, `GO` 4.6, `IF/ELSE/IF.END` 4.7, `LOOP/L.END/L.MODIFY` 4.8, `SET` 4.11, `SOURCE` 4.12, `STMT` 4.13, `SYSTEM` 4.14, and `TONYPLOT` 4.15. Chapter 5 contains the extraction language and Atlas quantity-name mapping.


# TCAD Example Discovery

Use this reference when the user asks to reuse local Silvaco examples, when the local example path is unknown, or when this skill is copied to a different computer.

## Discovery Priority

1. Use a path explicitly provided by the user.
2. Use environment variables when present:
   - `SILVACO_EXAMPLES_DIR`
   - `TCAD_EXAMPLES_DIR`
   - `SILVACO_HOME`
   - `SEDATOOLS_HOME`
3. Run `scripts/find-silvaco-examples.ps1` from the skill folder on Windows.
4. Search generic installation roots if the script cannot run.
5. Ask the user for the install/example path only after safe local discovery fails.

## Windows Helper

From the skill folder:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\find-silvaco-examples.ps1
```

With an explicit root:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\find-silvaco-examples.ps1 -Root "<path-to-silvaco-or-sedatools-root>"
```

JSON output:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\find-silvaco-examples.ps1 -Json
```

The JSON contains `DeckCount`, `DeclaredExamples`, `SupportFileCount`, and `Decks`. An index may describe examples whose payload was not installed. Route only to a deck listed in `Decks`; use index-only entries as documentation, not as locally runnable examples.

## Generic Locations To Consider

Check paths derived from these sources rather than committing machine-specific paths:

- `SILVACO_EXAMPLES_DIR`
- `TCAD_EXAMPLES_DIR`
- `SILVACO_HOME`
- `SEDATOOLS_HOME`
- `%ProgramFiles%`
- `%ProgramFiles(x86)%`
- File-system drive roots containing directory names such as `Silvaco`, `sedatools`, `softwares\sedatools`, or `examples\deckbuild`

## What To Look For

Prioritize directories with these names:

- `sic`: SiC-specific examples; usually highest value for this skill.
- `power`: general power-device examples.
- `diode`: diode and breakdown examples.
- `mos1`, `mos2`: MOS and MOSFET examples.
- `ganfet`, `mesfet`: wide-bandgap or compound FET patterns.
- `bjt`: bipolar examples.

Useful file types:

- `*.in`, `*.cmd`: DeckBuild input decks.
- `*.html`, `*examples.index`: vendor explanations and example index text.
- `*.dat`, `*.exp`: measured or comparison data.
- `*.set`, `*.setx`: TonyPlot settings.

Before adapting a deck, also confirm that files named by `mesh infile`, `load infile`, `tfile`, `doping infile`, or plotting commands exist in that example folder. A deck without its structure/data/support files may be useful as syntax evidence but is not necessarily runnable.

## Cross-Computer Behavior

Never assume local examples exist at any previously used path. When generating or reviewing decks, state whether the answer is based on bundled notes only or also on examples discovered on the user's current machine.

When a path is discovered, cite the discovered path in the response and prefer examples from that machine over stale paths from another installation.

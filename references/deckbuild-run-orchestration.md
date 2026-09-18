# DeckBuild Run Orchestration

Read this before generating a multi-simulator deck, batch study, loop, conditional branch, or restart workflow.

## Run graph contract

Represent the deck as a directed state graph before writing commands:

```text
process chain (serial): Athena checkpoints -> optional DevEdit -> final device structure
device branches (parallel concept):
  final/common state -> transfer
  final/common state -> output family
  final/common state -> breakdown
  final/common state -> transient/latch-up/electrothermal
```

Do not run these device branches as one accidental continuation. Each branch must explicitly load the intended common structure/solution and redeclare non-persistent contacts, interfaces, thermal boundaries, models and numerical settings.

## `GO` and auto-interface

```text
go athena
go devedit
go atlas
go atlas noauto
go <simulator> simflags="<flags with spaces>"
```

`GO` shuts down the current simulator and starts the named one. Default auto-interface passes the preceding process result using tool-specific save/load flags. `NOAUTO` disables that transfer. Never assume what was transferred: audit structure path, mesh, materials, dopants and electrodes after every simulator transition.

Use `simflags` only for a documented version/module/parallel setting and record it in provenance. Do not rely on a machine-specific MaskViews cutline path for portable or distributed runs.

## Variables, conditions and loops

```text
set gate_step=0.25
set "target current"=1e-6
solve name=gate vstep=$gate_step vfinal=<stop>

if cond=($gate_step > 0)
  <commands>
else
  <safe alternative>
if.end

loop steps=<n>
  stmt gate_bias=<start>:<increment>
  <commands using $gate_bias>
l.end
```

- `$name` or `@name` substitutes a DeckBuild variable; use `$"name with spaces"` for names containing spaces.
- `SET CLEAR` removes all variables, including `DEFINE` substitutions.
- A loop must have a matching `L.END`; `L.MODIFY` can change/skip/break the current or an enclosing loop.
- Prefer explicit finite loop counts and deterministic filenames containing the swept variable/index.
- Never let a loop overwrite the same log/structure file unless overwrite is explicitly intended.
- Before using an extracted value in a later command, define its expected unit/range and fail safely when extraction did not succeed. A `SET ... NOMINAL` fallback must be disclosed; it must not silently replace failed calibration data.

## `SOURCE` modularity

`SOURCE file` inserts and executes the referenced file as part of the current input buffer; sourced files may source other files. Relative paths resolve from the current directory in the 2018 manual.

For reproducibility, return a manifest of all sourced files, their purpose and checksum/version. Avoid hidden global files. A source file may contain simulator and DeckBuild commands, so review it as executable deck content.

## Batch and checkpoint rules

- Run under DeckBuild when using variables, extraction, auto-interface or TonyPlot commands.
- Capture runtime output, simulator version, working directory, deck, source manifest, model/default printout, logs, named checkpoints and extracted results.
- Use explicit filenames rather than `.historyNN.str` for durable evidence.
- A successful process exit is insufficient: scan runtime output for warnings, failed extraction, range errors and unconverged bias points.
- Resume only from a checkpoint whose generating deck and declarations are known.


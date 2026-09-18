# DeckBuild Extraction and Sweep Governance

Read this whenever defining Vth, breakdown, on-resistance, peak field/temperature, process dimensions, or using extracted values in later commands.

## Extraction contract

Every reported scalar or curve must define:

1. input file/state and bias history;
2. source quantity and whether Atlas `OUTPUT` explicitly saved it;
3. mathematical criterion and search window;
4. terminal/region/material and coordinate scope;
5. unit and 2D width/area normalization;
6. expected range and failure behavior;
7. output name and results file.

Name almost every extract:

```text
extract name="<metric>" <expression> datafile="<results_file>"
```

The default results file in the 2018 manual is `results.final`. Prefer a run-specific explicit file. Built-in extracts report units; custom expressions may not, so record units beside the deck.

## Variable chaining and range guards

```text
extract name="xj1" <first expression>
extract name="xj2" <second expression>
extract name="delta xj" abs($xj1-$xj2) min.val=<lo> max.val=<hi>

set cutline=<um>
extract name="gate oxide thickness" oxide thickness x.val=$cutline
```

Use `$"delta xj"` for names containing spaces. `MIN.VAL`/`MAX.VAL` apply to scalar results and append an error when the value is out of range; they do not validate curves. Range guards detect invalid results but do not prove physical correctness.

## Atlas spatial extraction prerequisite

Atlas can extract only quantities available in the saved structure. Request non-default fields before `SAVE`, for example:

```atlas
output e.field impact recomb j.total <other_required_fields>
save outf=<state.str>
```

DeckBuild extraction names can differ from Atlas `OUTPUT` keywords. Verify the installed mapping rather than constructing names mechanically. Distinguish a terminal log curve from a spatial structure file.

## Characteristic definitions

| Metric | Required declaration |
| --- | --- |
| Vth | constant-current or transconductance/extrapolation method, drain bias, current normalization, fit/search range |
| breakdown voltage | current/current-density or ionization criterion, compliance, interpolation rule, sweep direction and temperature |
| Ron,sp | voltage/current fit interval, cell width/area, contact contribution and temperature |
| peak field | saved bias point, field component/magnitude, material/region and exclusion of singular contact corners if justified |
| peak temperature | saved electrothermal state, domain, ambient/boundary and steady/transient time |
| oxide thickness | material occurrence, coordinate/cutline, conversion because process thickness may be returned in angstroms |
| junction depth | impurity/active/net definition, material occurrence, lateral coordinate and temperature if activation-dependent |

Never accept an intercept/maxslope result without bounding the curve region; multiple crossings, noise and snapback can select the wrong occurrence.

## Sweep-family template

```text
set curve_index=0
loop steps=<number_of_gate_biases>
  stmt gate_bias=<start>:<increment>
  <load common conditioning state>
  <ramp gate to $gate_bias>
  log outf="output_<index_or_bias>.log"
  <sweep drain/collector>
  log off
  <extract guarded scalar/curve metrics>
l.end
```

DeckBuild interpolation/substitution syntax and filename quoting vary by release; validate the emitted filenames with a two-iteration dry run before a long study.


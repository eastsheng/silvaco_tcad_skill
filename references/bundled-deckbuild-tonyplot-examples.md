# Bundled DeckBuild and TonyPlot Patterns

Use these templates before consulting local manuals. Replace placeholders and verify release spelling.

## Independent Atlas characteristic branches

```text
# Common structure and model declarations are emitted for each Atlas run.
go atlas noauto
mesh infile=<device.str>
<materials contacts interfaces models thermal contacts method>
solve init
<condition to common state>
save outf=<common_state.str>

# Transfer branch
load inf=<common_state.str>
log outf=transfer.log
<gate sweep>
log off
save outf=transfer_final.str

# Use a fresh Atlas run or fully reconstructed state for breakdown/electrothermal branches.
```

Do not assume `LOAD` restores thermal contacts or every declaration. A new `GO ATLAS` branch must reconstruct its run contract.

## Guarded extraction

```text
extract init infile="transfer.log"
extract name="Vth constant current" <declared_expression> \
  min.val=<physical_lower_bound> max.val=<physical_upper_bound> \
  datafile="transfer_results.final"
```

Keep the exact criterion in the deck comment/report. Never replace `<declared_expression>` with an undocumented generic max-slope shortcut.

## Reproducible overlay export

```text
tonyplot -overlay <baseline.log> <candidate.log>

# After configuring and saving comparison.setx:
tonyplot -overlay <baseline.log> <candidate.log> \
  -set <comparison.setx> -png <comparison.png> -geom <width>x<height>
```

Because `.setx` does not preserve overlay creation actions, retain this command and input order in the artifact manifest. Verify the installed TonyPlot release accepts the combined ordering before batch generation.

## Spatial hot-spot package

```atlas
output e.field impact j.total recomb lattice.temp
save outf=<operating_point.str>
```

Then create a `.setx` containing the intended quantity, fixed limits and keyboard-coordinate cutline. Retain the structure, `.setx`, exported PNG and a DeckBuild extraction of the reported peak/integral.

# TonyPlot 2018 Manual Evidence Map

Use this for TonyPlot command-line, `.setx`, overlay, cutline, data-file or export provenance. Source: *TonyPlot User's Manual*, Silvaco, February 16, 2018 (`tonyplot_users1.pdf`, 183 pages).

## High-value map

| Section | Topic | Use here |
| --- | --- | --- |
| 2.1 | command line | deterministic load/overlay/set/export |
| 2.6 | image export | PNG/JPEG artifacts and geometry |
| 2.7 | tools | cutline/cutplane, markers, probe, ruler, integrate |
| 2.8 | functions | derived plotted quantities; document formulas |
| Ch. 3–6 | mesh/XY/cross section | field, mesh and curve audits |
| Ch. 10 | overlays | same-condition comparisons and level identification |
| 13.2 | set files | reproducible plot configuration and limitations |
| App. A | data files | imported/measured data formatting |

## Version rules

- TonyPlot 5+ uses XML `.setx`; it can read legacy `.set` but saves `.setx`.
- The 2018 manual specifies one `.setx` per plot. Apply it immediately after the file(s) it should affect on the command line.
- A set file stores display state and can recreate cutlines, but does not record the actions that created an overlay. Preserve the overlay command/input order separately.
- A plot is evidence only when its source files, set file, transforms, cut coordinates, labels, units and export dimensions are known.


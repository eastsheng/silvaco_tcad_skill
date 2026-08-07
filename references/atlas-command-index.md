# Atlas command index

Atlas is statement-oriented. Parameters may be logical, integer, real, character, or list values. Abbreviations must remain unambiguous.

## Required order

```text
MESH / X.MESH / Y.MESH / Z.MESH
REGION
ELECTRODE
DOPING
MATERIAL / CONTACT / INTERFACE
MODELS / MOBILITY / IMPACT / TRAP
METHOD
SOLVE
LOG / SAVE / OUTPUT / EXTRACT
```

## Statement map

| Group | Statements | Meaning |
|---|---|---|
| Mesh | `MESH`, `X.MESH`, `Y.MESH`, `Z.MESH`, `REGRID`, `ELIMINATE`, `SPREAD` | numerical grid |
| Geometry | `REGION`, `ELECTRODE` | materials and terminals |
| Profiles | `DOPING`, `DOSEXTRACT` | impurity profiles |
| Properties | `MATERIAL`, `CONTACT`, `INTERFACE`, `THERMCONTACT` | bulk, interface, electrical, thermal data |
| Physics | `MODELS`, `MOBILITY`, `IMPACT`, `TRAP`, `DEFECTS`, `INTDEFECTS` | transport, recombination, avalanche, defects |
| Numerics | `METHOD`, `OPTIONS`, `SYMBOLIC` | nonlinear/linear solver control |
| Bias | `SOLVE`, `CURVETRACE`, `LOAD` | initialize and sweep |
| Results | `LOG`, `SAVE`, `OUTPUT`, `PROBE`, `EXTRACT`, `MEASURE` | record and post-process |

## SiC-priority syntax

| Command | Pattern | Principal parameters |
|---|---|---|
| `MESH` | `mesh space.mult=<n> width=<um>` | global spacing, 2D width |
| `X.MESH` | `x.mesh location=<um> spacing=<um>` | coordinate, local spacing |
| `REGION` | `region number=<n> material=<name> ...` | ID, material, bounds |
| `ELECTRODE` | `electrode name=<id> ...` | name, bounds |
| `DOPING` | `doping <type> <profile> concentration=<cm-3> ...` | type, profile, concentration |
| `MATERIAL` | `material material=<name> <parameter>=<value>` | material properties |
| `CONTACT` | `contact name=<id> workfunction=<eV>` | barrier/contact properties |
| `MODELS` | `models <flags> temperature=<K>` | enabled physics |
| `MOBILITY` | `mobility <parameter>=<value>` | mobility coefficients |
| `IMPACT` | `impact <model> <coefficient>=<value>` | ionization model |
| `TRAP` | `trap <donor|acceptor> e.level=<eV> density=<cm-3> ...` | energy, density, cross-sections |
| `METHOD` | `method <newton|gummel|block> ...` | scheme and tolerances |
| `SOLVE` | `solve init`; `solve v<name>=... vstep=... vfinal=... name=<name>` | bias ramp |
| `LOG` | `log outf=<file>` | terminal output |
| `SAVE` | `save outf=<file>` | spatial solution |

Verify uncommon parameters, units, defaults, compatibility, and licensing in the installed Atlas version.


# Cursor Adapter

Use this adapter when using the TCAD skill in Cursor.

## Recommended Setup

1. Create `.cursor/rules/silvaco-tcad.mdc`.
2. Paste the contents of `PROMPT.md` into that rule file.
3. Put the `references/` and `scripts/` folders somewhere inside the project, for example `tools/silvaco_tcad_skill/`.

Example frontmatter for `.cursor/rules/silvaco-tcad.mdc`:

```markdown
---
description: Silvaco Atlas and 4H-SiC power device TCAD assistant
globs:
  - "**/*.in"
  - "**/*.cmd"
  - "**/*.log"
  - "**/*.str"
alwaysApply: false
---
```

Then paste `PROMPT.md` below the frontmatter and update reference paths:

```markdown
Use `tools/silvaco_tcad_skill/references/` as the TCAD knowledge base.
```

## Usage Examples

```text
@silvaco-tcad Review this Atlas deck for SiC breakdown convergence issues.
```

```text
@silvaco-tcad Use the local example discovery script and compare my deck with SiC SBD/JBS patterns.
```

## Notes

- Cursor rules are not the same as Codex skills; `SKILL.md` is not automatically triggered.
- Keep `PROMPT.md` short enough for rules, and rely on `references/*.md` for details.
- If Cursor cannot run PowerShell scripts, manually set or provide the Silvaco example path.

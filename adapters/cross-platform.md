# Cross-Platform Packaging Guide

This package supports two modes:

- Codex native skill: use `SKILL.md`, `references/`, `scripts/`, and optional `agents/openai.yaml`.
- Platform-neutral knowledge package: use `PROMPT.md`, `references/`, `scripts/`, and the adapter files in this folder.

## What To Keep

Keep these files for all platforms:

```text
PROMPT.md
README.md
references/
scripts/find-silvaco-examples.ps1
```

Keep these for Codex:

```text
SKILL.md
agents/openai.yaml
```

## What To Ignore Outside Codex

Non-Codex tools usually ignore:

```text
SKILL.md frontmatter
agents/openai.yaml
```

Do not delete them if the package is still used in Codex.

## Porting Checklist

1. Put `PROMPT.md` into the target tool's system prompt, project instruction, or rule file.
2. Upload or attach `references/*.md`.
3. Confirm how the target tool accesses local files.
4. If local file access is unavailable, run `scripts/find-silvaco-examples.ps1` manually and paste the discovered path.
5. Test with one syntax question, one deck-review question, and one local-example question.

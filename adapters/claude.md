# Claude / Claude Code Adapter

Use this adapter when using the TCAD skill outside Codex with Claude or Claude Code.

## Recommended Setup

1. Copy `PROMPT.md` into the project as `CLAUDE.md`, or paste its contents into project instructions.
2. Keep the `references/` folder in the same project or attach the needed markdown files to the conversation.
3. Keep `scripts/find-silvaco-examples.ps1` available if Claude Code has shell access on Windows.

## Suggested Project Layout

```text
project/
├── CLAUDE.md
└── tcad-knowledge/
    ├── references/
    └── scripts/
```

Add this note to `CLAUDE.md` if references are stored under `tcad-knowledge/`:

```markdown
Use `tcad-knowledge/references/` as the TCAD knowledge base.
Use `tcad-knowledge/scripts/find-silvaco-examples.ps1` to locate local Silvaco examples when needed.
```

## Usage Examples

```text
Use the TCAD knowledge base to review this 4H-SiC JBS reverse breakdown deck.
```

```text
Find local Silvaco examples on this computer, then use the closest SiC SBD/JBS example pattern.
```

## Notes

- Claude will not automatically understand Codex `SKILL.md` triggering. Use `PROMPT.md` or `CLAUDE.md` as the active instruction.
- `agents/openai.yaml` is not needed for Claude.
- If Claude cannot access the filesystem, paste the relevant reference files into the chat or upload them as context.

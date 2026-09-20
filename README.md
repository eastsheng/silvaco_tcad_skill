# SiC Power Device TCAD Research Skill

This package is both a Codex skill and a cross-platform TCAD knowledge package for Silvaco Atlas / DeckBuild workflows focused on 4H-SiC power devices.

## What It Can Do

- Explain Atlas command syntax, parameters, physical meaning, examples, and common mistakes.
- Help create, review, and debug decks for 4H-SiC MOSFET, SBD, JBS/MPS, PiN diode, and related power devices.
- Guide mesh, region, electrode, doping, material, contact, interface, model, method, solve, log, save, and extract setup.
- Use local Silvaco examples when available, especially `sic`, `power`, `diode`, and `mos*` examples.
- Adapt to different computers by discovering local Silvaco/DeckBuild example paths instead of assuming one fixed install path.

## Core Files

```text
silvaco_tcad_skill/
├── SKILL.md                 # Codex native skill entry
├── PROMPT.md                # Platform-neutral expert prompt
├── README.md                # Human install/use guide
├── agents/                  # Codex UI metadata
├── adapters/                # Claude, Cursor, DeepSeek, RAG adapter guides
├── references/              # TCAD knowledge base
└── scripts/                 # Local helper scripts
```

## Codex Installation

Ask Codex to install this skill directly from the GitHub repository:

```text
Install this Codex skill:
https://github.com/eastsheng/silvaco_tcad_skill.git
```

```text
帮我安装这个 Codex skill：
https://github.com/eastsheng/silvaco_tcad_skill.git
```

## Cross-Platform Use

For Claude, DeepSeek, Cursor, RAGFlow, Dify, AnythingLLM, or local LLM tools:

1. Use `PROMPT.md` as the system prompt, project instruction, or rule file.
2. Upload or attach `references/*.md` as the knowledge base.
3. Keep `scripts/find-silvaco-examples.ps1` available for Windows local Silvaco example discovery.
4. Use the relevant file under `adapters/` for platform-specific setup.

Recommended mapping:

| Platform | Use |
| --- | --- |
| Codex | `SKILL.md` + `references/` + `scripts/` |
| Claude / Claude Code | `PROMPT.md` as `CLAUDE.md`; attach or include `references/` |
| Cursor | Convert `PROMPT.md` into `.cursor/rules/silvaco-tcad.mdc` |
| DeepSeek / local LLM | `PROMPT.md` as system prompt; `references/*.md` as RAG docs |
| RAGFlow / Dify / AnythingLLM | Upload `references/*.md`; use `PROMPT.md` as app instruction |

## Local Silvaco Example Discovery

The skill does not require one fixed TCAD install path. On each computer, use one of these methods:

1. Provide the Silvaco examples path in the prompt.
2. Set an environment variable such as `SILVACO_EXAMPLES_DIR`.
3. Run the helper script:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\find-silvaco-examples.ps1
```

With a known root:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\find-silvaco-examples.ps1 -Root "<path-to-silvaco-or-sedatools-root>"
```

Supported variables:

```text
SILVACO_EXAMPLES_DIR
TCAD_EXAMPLES_DIR
SILVACO_HOME
SEDATOOLS_HOME
```

## Example Prompts

```text
用 $silvaco-tcad-skill 参考本机 Silvaco sic 示例，写一个 4H-SiC SBD 反向击穿 deck。
```

```text
基于 PROMPT.md 和 references，解释 4H-SiC MOSFET 中 interface trap 对阈值电压和沟道迁移率的影响。
```

```text
使用 TCAD 知识库检查我的 Atlas deck，重点看 mesh、impact ionization、incomplete ionization 和 solve ramp。
```

## Notes

- Keep `agents/openai.yaml` for Codex. Other tools usually ignore it.
- Keep `SKILL.md` for Codex automatic triggering.
- Use `PROMPT.md` for platform-neutral behavior.
- Treat bundled local example notes as vendor example patterns, not calibrated recipes.
- Do not commit local proprietary Silvaco installation files or user-specific paths.

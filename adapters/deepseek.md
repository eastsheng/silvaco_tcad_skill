# DeepSeek / Local LLM Adapter

Use this adapter for DeepSeek, OpenWebUI, LM Studio, Ollama frontends, or similar local-model workflows.

## Recommended Setup

1. Use `PROMPT.md` as the system prompt or assistant instruction.
2. Add `references/*.md` to the RAG/document collection if the frontend supports retrieval.
3. Keep `scripts/find-silvaco-examples.ps1` outside the RAG corpus and run it manually when local example discovery is needed.

## RAG Indexing

Recommended documents to upload:

- All files under `references/`
- Optionally `README.md` for user-facing install/use instructions

Do not rely on RAG alone for strict behavior. The system prompt should still include the workflow rules from `PROMPT.md`.

## Usage Examples

```text
基于知识库，帮我解释 4H-SiC Schottky 接触 workfunction 和 barrier height 的区别。
```

```text
参考 SiC 示例模式，帮我生成一个 4H-SiC SBD 反向击穿 deck 框架。
```

## Notes

- Local models may hallucinate command names more easily; require answers to cite which reference file or example pattern they used.
- Keep calibration coefficients as placeholders unless the source is explicitly provided.
- If the model has no filesystem tools, provide the local Silvaco example path and relevant deck text manually.

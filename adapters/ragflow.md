# RAGFlow / Dify / AnythingLLM Adapter

Use this adapter for knowledge-base applications where files are uploaded and queried through RAG.

## Recommended Setup

1. Create a knowledge base named something like `SiC Power Device TCAD`.
2. Upload all `references/*.md` files.
3. Use `PROMPT.md` as the application system prompt.
4. Keep `README.md` as human documentation, not as the primary retrieval source unless users ask installation questions.

## Chunking Guidance

- Use markdown-aware chunking if available.
- Keep headings as metadata when possible.
- Prefer medium chunks, around 500-1200 tokens, so command syntax, physical meaning, and common mistakes stay together.
- Disable aggressive overlap if it causes repeated deck fragments.

## Retrieval Guidance

For user questions:

- Retrieve `atlas-command-index.md` for command syntax.
- Retrieve `physics-models.md` for mobility, SRH, incomplete ionization, traps, thermal, and impact-ionization questions.
- Retrieve `solver-and-extraction.md` for convergence, bias ramp, logging, and extraction questions.
- Retrieve `local-sic-example-patterns.md` and `local-silvaco-examples-index.md` for example-driven answers.
- Retrieve `tcad-example-discovery.md` when the user asks about local examples on a different computer.

## Notes

- RAGFlow/Dify/AnythingLLM will not execute `scripts/find-silvaco-examples.ps1`; run it outside the app and paste the discovered path back into the conversation.
- Ask users to paste relevant Atlas deck fragments for debugging.
- Do not let the app present bundled vendor example patterns as calibrated results.

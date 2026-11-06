# agent-rules

Personal agent behavior rules and per-language conventions, shipped as an APM package and as a plugin.
The [README.md](README.md) compatibility table says which manifest and `rules/` format each runtime reads.
Read it before changing a manifest or a frontmatter key.

## Where things go

- A rule file is `.apm/instructions/<name>.instructions.md`, the only file to edit.
- `rules/<name>.md` (Antigravity, Devin) and `rules/<name>.mdc` (Cursor) are relative symlinks to it.
- A new rule file gets both symlinks and a line in the README "Instructions" list.
- Behavior for every task goes in `global.instructions.md`, a rule for every code file in `code.instructions.md`, and a file-type rule in its own file.

## Frontmatter

Each runtime reads its own keys, so every rule file carries all of them.
Copy a sibling's frontmatter.

- Antigravity silently drops a rule whose `trigger` is missing or unknown, so keep `always_on` or `glob`.

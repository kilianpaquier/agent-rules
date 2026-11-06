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

Each runtime reads its own keys, so every rule file carries all of them:

- `paths` for Claude Code, `applyTo` for Copilot, `globs` and `alwaysApply` for Cursor, `trigger` and `globs` for Antigravity.
- `applyTo`, `globs` and `paths` match the same files, with `applyTo` as one comma-separated string and the other two as arrays.
- `global.instructions.md` has no glob key, because a rule without one loads at session start.
- Antigravity silently drops a rule whose `trigger` is missing or unknown, so keep `always_on` or `glob`.

## Writing a rule

- A rule reaches every runtime, so name a runtime-only mechanism (*e.g.* a skill, plan mode) only next to a neutral fallback.
- Refer to another rule file by its role ("the language rule files"), never by filename, since each runtime installs it under another name.
- When an agent or the user finds a rule that reads two ways, reword that rule, not only the case at hand.
- Check every edited rule against the global Prose rules before finishing.

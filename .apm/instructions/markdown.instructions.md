---
alwaysApply: false
applyTo: "**/*.md"
description: Markdown file conventions
globs: ["**/*.md"]
paths: ["**/*.md"]
trigger: glob
---

# Markdown

## Structure

- Write one `#` heading per doc.
- Never skip a heading level (`##` directly under `#`, not `###`).
- Leave a blank line before and after every heading, code block, list, and table.

## Prose

- When editing a doc, match its existing format (bullet length, line breaks, heading style).
- Before adding a line, review the lines around it. Merge the new fact into the paragraph it belongs to, and remove duplicates and obsolete lines.
- In docs for humans, connect related facts in one sentence (since, so, unless, which) rather than chaining short sentences.
- Reword the user's input to fit the doc, never paste it raw.
- Cover what the reader needs. Never impose fixed section names or decoration (badges, TOC) unless the doc already uses them.
- In agent instruction files (`AGENTS.md`, rules, skills), keep only what the agent can't read from the code.
- Leave out what the global and language rules already say.
- Link the README and CONTRIBUTING with the task that calls for reading each, rather than restating them.
- Keep cross-language guidance language-neutral.

## Lists

- Use `-` for unordered lists, not `*` or `+`.
- Use `1.` for ordered lists.

## Code blocks

- Always specify the language:

```sh
echo hello
```

## Tables

- Align `|` vertically.
- Pad cell content to align columns.
- Repeat `-` in the header separator row to match the column width.

Example:

| Column A     | Column B       |
| ------------ | -------------- |
| short        | a longer value |
| longer value | another value  |

## Links

- Write inline links as `[text](url)`.
- Never leave a bare URL in prose. Wrap it in `<>` or use inline link syntax.

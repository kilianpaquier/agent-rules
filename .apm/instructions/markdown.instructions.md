---
alwaysApply: false
applyTo: "**/*.md"
description: Markdown file conventions
globs: ["**/*.md"]
paths: ["**/*.md"]
---
# Markdown

## Structure

- One `#` heading per doc.
- No skip heading level (e.g. `##` direct under `#`, not `###`).
- Blank line before, after heading, code block, list, table.

## Lists

- Use `-` unordered, not `*`/`+`.
- Use `1.` ordered.

## Code blocks

- Always specify language:
```sh
echo hello
```

## Tables

- Align `|` vertically (no language for this).
- Pad cell content, align columns.
- Header separator row: `-` repeated matching column width.

Example:

| Column A     | Column B                  |
| ------------ | ------------------------- |
| short        | a longer value            |
| longer value | another value             |

## Links

- Inline: `[text](url)`.
- No bare URL in prose. Wrap `<url>` or use inline link syntax.

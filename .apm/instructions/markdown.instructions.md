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

- One `#` heading per doc.
- Never skip a heading level (`##` directly under `#`, not `###`).
- Blank line before and after every heading, code block, list, and table.

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
- Header separator row: `-` repeated to match column width.

Example:

| Column A     | Column B       |
| ------------ | -------------- |
| short        | a longer value |
| longer value | another value  |

## Links

- Inline links: `[text](url)`.
- No bare URL in prose. Wrap it in `<>` or use inline link syntax.

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

---
alwaysApply: false
applyTo: "**/*.md"
description: Markdown file conventions
globs: ["**/*.md"]
paths: ["**/*.md"]
trigger: glob
---

# Markdown

Follow the default [**markdownlint** rules](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md) alongside these rules.
These rules override them on any conflict.

## Prose

- When editing a doc, match its existing format (bullet length, line breaks, heading style).
- Cover what the reader needs. Never impose fixed section names or decoration (badges, TOC) unless the doc already uses them.
- Keep cross-language guidance language-neutral.

## Lists

- Use `-` for unordered lists, not `*` or `+`.
- Number ordered lists `1.`, `2.`, `3.`.

## Tables

- Align `|` vertically.
- Pad cell content to align columns.
- Repeat `-` in the header separator row to match the column width.

| Column A     | Column B       |
| ------------ | -------------- |
| short        | a longer value |
| longer value | another value  |

## Links

- Write inline links as `[text](url)`.

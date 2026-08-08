---
alwaysApply: false
applyTo: "**/Makefile,**/*.mk"
description: Makefile conventions
globs: ["**/Makefile", "**/*.mk"]
paths: ["**/Makefile", "**/*.mk"]
---
# Makefile

## Targets

- `.PHONY` before every non-file target.
- Prefix command `@`, suppress echo.
- Names: `kebab-case`.
- Prereqs after `:` (*e.g.*, `dev: build`).

## Variables

- Name: `SCREAMING_SNAKE_CASE`.
- Optional defaults: `?=`.
- Align values, spaces, same block multi-var.
- `$(ARGS)` forward extra args.

---
description: My own personal global AI agent behavior rules and per-language coding conventions.
title: My own rules
---

My own personal global AI agent behavior rules and per-language coding conventions, shipped as an Open Plugin, Agent Package Manager package, and marketplace.

## Installation

> [!warning]
> Prefer **APM** installation, broader [agents compatibility](https://microsoft.github.io/apm/consumer/install-packages/#where-files-land) than
> **Open Plugin** on [rules](https://open-plugins.com/agent-builders/components/rules).

**Native plugin**:
```sh
my-agent plugin marketplace add kilianpaquier/agent-rules
my-agent plugin install agent-rules@agent-rules
```

**APM package (recommended)**:
```sh
apm install kilianpaquier/agent-rules -g --target <claude|copilot|...>
```

**APM plugin**:
```sh
apm marketplace add kilianpaquier/agent-rules
apm install agent-rules@agent-rules -g --target <claude|copilot|...>
```

## Instructions

This plugin ships an **Agent Package Manager** and **Open Plugin** standard rules (or instructions):

- Global AI agent behavior (response style, scope, process, code review, code style, design, testing)
- Docker
- Docker Compose
- GitLab CI
- Go
- Go tests
- Makefile
- Markdown
- Shell
- Terraform / OpenTofu
- TypeScript / JavaScript

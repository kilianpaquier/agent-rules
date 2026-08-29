# agent-rules <!-- omit in toc -->

<div align="center">
  <img alt="GitLab Release" src="https://img.shields.io/gitlab/v/release/kilianpaquier%2Fagent-rules?gitlab_url=https%3A%2F%2Fgitlab.com&include_prereleases&sort=semver&style=for-the-badge">
  <img alt="GitLab Issues" src="https://img.shields.io/gitlab/issues/open/kilianpaquier%2Fagent-rules?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge">
  <img alt="GitLab License" src="https://img.shields.io/gitlab/license/kilianpaquier%2Fagent-rules?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge">
  <img alt="GitLab CICD" src="https://img.shields.io/gitlab/pipeline-status/kilianpaquier%2Fagent-rules?gitlab_url=https%3A%2F%2Fgitlab.com&branch=main&style=for-the-badge">
</div>

---

My own personal global AI agent behavior rules and per-language coding conventions,
shipped as a plugin (various runtimes supported)
and an [**Agent Package Manager**](https://microsoft.github.io/apm/producer/author-primitives/) package.

## Instructions

- Global AI agent behavior (scope, safety, process, tools, responses, prose, code style, commits, environment)
- Code (language-neutral design, safety, dependencies, style, testing)
- Code review
- Docker
- Docker Compose
- GitLab CI
- Go
- Go Cobra CLI
- Go tests
- Markdown
- Shell
- Terraform / OpenTofu
- TypeScript / JavaScript

## Installation

**Native plugin (limited compatibility)**:
```sh
my-agent plugin install agent-rules@<importing marketplace>
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

## Compatibility table

> [!note]
> A plugin's `rules/` component is only defined in the **Cursor**, **Antigravity** and **Devin** formats.
>
> Use the **APM package** install for the other runtimes instead, it writes each runtime's own instruction file(s) in the right place.

| Agent Runtime    | Manifest                     | Native `rules/` component             |
| ---------------- | ---------------------------- | ------------------------------------- |
| **APM**          | `apm.yml`                    | `.apm/instructions/*.instructions.md` |
| **Antigravity**  | `plugin.json`                | `rules/*.md`                          |
| **Claude Code**  | `.claude-plugin/plugin.json` | -                                     |
| **Codex**        | `.codex-plugin/plugin.json`  | -                                     |
| **Copilot**      | `plugin.json`                | -                                     |
| **Cursor**       | `.cursor-plugin/plugin.json` | `rules/*.mdc`                         |
| **Devin**        | `.claude-plugin/plugin.json` | `rules/*.md`                          |
| **Hermes Agent** | `plugin.yaml`                | -                                     |

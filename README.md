# agent-rules <!-- omit in toc -->

<div align="center">
  <img alt="GitLab Release" src="https://img.shields.io/gitlab/v/release/kilianpaquier%2Fagent-rules?gitlab_url=https%3A%2F%2Fgitlab.com&include_prereleases&sort=semver&style=for-the-badge">
  <img alt="GitLab Issues" src="https://img.shields.io/gitlab/issues/open/kilianpaquier%2Fagent-rules?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge">
  <img alt="GitLab License" src="https://img.shields.io/gitlab/license/kilianpaquier%2Fagent-rules?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge">
  <img alt="GitLab CICD" src="https://img.shields.io/gitlab/pipeline-status/kilianpaquier%2Fagent-rules?gitlab_url=https%3A%2F%2Fgitlab.com&branch=main&style=for-the-badge">
</div>

---

My own personal global AI agent behavior rules and per-language coding conventions,
shipped as an [**Agent Plugins**](https://agent-plugins.org/specification) plugin,
[**Agent Package Manager**](https://microsoft.github.io/apm/producer/author-primitives/) package,
and marketplace (**Claude Code**, **Copilot** and **Agent Plugins** formats).

## Installation

> [!warning]
> [**Agent Plugins**](https://agent-plugins.org/specification) does not yet define rules component,
> so a native plugin install ships nothing.

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

## Instructions

This plugin ships an **Agent Package Manager** and **Agent Plugins** standard rules (or instructions):

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

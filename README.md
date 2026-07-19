# agent-rules <!-- omit in toc -->

<div align="center">
  <img alt="GitLab Release" src="https://img.shields.io/gitlab/v/release/kilianpaquier%2Fagent-rules?gitlab_url=https%3A%2F%2Fgitlab.com&include_prereleases&sort=semver&style=for-the-badge">
  <img alt="GitLab Issues" src="https://img.shields.io/gitlab/issues/open/kilianpaquier%2Fagent-rules?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge">
  <img alt="GitLab License" src="https://img.shields.io/gitlab/license/kilianpaquier%2Fagent-rules?gitlab_url=https%3A%2F%2Fgitlab.com&style=for-the-badge">
  <img alt="GitLab CICD" src="https://img.shields.io/gitlab/pipeline-status/kilianpaquier%2Fagent-rules?gitlab_url=https%3A%2F%2Fgitlab.com&branch=main&style=for-the-badge">
</div>

---

My own personal global AI agent behavior rules and per-language coding conventions,
shipped as an [**Open Plugin**](https://open-plugins.com/plugin-builders/specification) Spec plugin,
[**Agent Package Manager**](https://microsoft.github.io/apm/producer/author-primitives/) package,
and marketplace (**Claude Code**, **Copilot** and **Open Plugin** formats).

## Installation

> [!warning]
> Prefer **APM** installation: it offers broader [agent compatibility](https://microsoft.github.io/apm/consumer/install-packages/#where-files-land) than
> **Open Plugin** for [rules](https://open-plugins.com/agent-builders/components/rules).

**Native plugin (limited compatibility)**:
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

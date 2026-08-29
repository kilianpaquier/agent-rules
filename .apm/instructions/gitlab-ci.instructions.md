---
alwaysApply: false
applyTo: "**/.gitlab-ci.{yml,yaml},**/.gitlab/**/*.{yml,yaml}"
description: GitLab CI conventions
globs: ["**/.gitlab-ci.{yml,yaml}", "**/.gitlab/**/*.{yml,yaml}"]
paths: ["**/.gitlab-ci.{yml,yaml}", "**/.gitlab/**/*.{yml,yaml}"]
trigger: glob
---

# GitLab CI

## To Be Continuous

Use [To Be Continuous](https://gitlab.com/to-be-continuous) components when a tool or workflow is needed.
Each component's `inputs` are in its template file.

Template URL: `https://gitlab.com/to-be-continuous/{component}/-/raw/main/templates/gitlab-ci-{component}.yml`

Exception: `semantic-release` is aliased to `semrel`.

Components: `ansible`, `aws`, `azure`, `bash`, `docker`, `gcloud`, `golang`, `gradle`, `helm`, `maven`, `node`, `pre-commit`, `python`, `renovate`, `rust`, `semantic-release`, `sonar`, `terraform`.

## Includes

- `include: - component:` for external templates, over `project:`, `remote:`, and `template:`.
- `inputs:` passes params to the component.
- Pin refs to a tag:

```yaml
- component: gitlab.com/org/template/job@1.5.0
  inputs:
    some-input: value
```

- `include: - local:` only for pipeline files in the same repo.

## Job key ordering

Order (omit unneeded):

1. `extends`
2. `stage`
3. `image`
4. `environment`
5. `needs`
6. `dependencies`
7. `rules`
8. `variables`
9. `before_script`
10. `script`
11. `after_script`
12. `artifacts`
13. `cache`
14. `allow_failure`
15. `interruptible`

## Jobs

- Names `kebab-case`, with `:` as namespace separator (*e.g.* `semantic-release:dry-run`).
- `needs: []` for jobs that must run immediately without waiting for prior stages.
- `interruptible: true` globally via `default:`. Override with `interruptible: false` on release jobs.

## Variables

- Names `SCREAMING_SNAKE_CASE`.
- Never hardcode secrets. Use masked or protected CI/CD variables.

## Rules

- `rules:` with `if`/`when` pairs, over `only:`/`except:`.
- Explicit `when: never` for blocked cases. End with a `when: on_success` fallback:

```yaml
rules:
  - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    when: never
  - when: on_success
```

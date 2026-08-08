---
alwaysApply: false
applyTo: "**/.gitlab-ci.{yml,yaml},**/.gitlab/**/*.{yml,yaml}"
description: GitLab CI conventions
globs: ["**/.gitlab-ci.{yml,yaml}", "**/.gitlab/**/*.{yml,yaml}"]
paths: ["**/.gitlab-ci.{yml,yaml}", "**/.gitlab/**/*.{yml,yaml}"]
---
# GitLab CI

## To Be Continuous

Use [To Be Continuous](https://gitlab.com/to-be-continuous) components when tool/workflow needed. Each component's `inputs` in template file.

Template URL: `https://gitlab.com/to-be-continuous/{component}/-/raw/main/templates/gitlab-ci-{component}.yml`

Exception: `semantic-release` alias `semrel` → `gitlab-ci-semrel.yml`.

Components: `ansible`, `aws`, `azure`, `bash`, `docker`, `gcloud`, `golang`, `gradle`, `helm`, `maven`, `node`, `pre-commit`, `python`, `renovate`, `rust`, `semantic-release`, `sonar`, `terraform`.

## Includes

- `include: - component:` for external templates. Over `project:`, `remote:`, `template:`.
- `inputs:` pass params to component.
- Pin refs to tag:
```yaml
- component: gitlab.com/org/template/job@1.5.0
  inputs:
    some-input: value
```
- `include: - local:` only local pipeline files same repo.

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

- Names `kebab-case`. `:` namespace separator (*e.g.*, `semantic-release:dry-run`).
- `needs: []` jobs must run immediate, no wait prior stages.
- `interruptible: true` global via `default:`. Override `interruptible: false` release jobs.

## Variables

- Names `SCREAMING_SNAKE_CASE`.

## Rules

- `rules:` with `if/when` pairs. Over `rules:` `only:/except:`.
- Explicit `when: never` block cases. End `when: on_success` fallback:

```yaml
rules:
  - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    when: never
  - when: on_success
```

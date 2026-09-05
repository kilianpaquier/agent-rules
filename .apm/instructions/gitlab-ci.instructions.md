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

Build the template URL as `https://gitlab.com/to-be-continuous/{component}/-/raw/main/templates/gitlab-ci-{component}.yml`.

One exception, `semantic-release` is aliased to `semrel`.

Components: `ansible`, `aws`, `azure`, `bash`, `docker`, `gcloud`, `golang`, `gradle`, `helm`, `maven`, `node`, `pre-commit`, `python`, `renovate`, `rust`, `semantic-release`, `sonar`, `terraform`.

## Includes

- Use `include: - component:` for external templates, over `project:`, `remote:`, and `template:`.
- Pass params to the component through `inputs:`.
- Pin refs to a tag:

```yaml
- component: gitlab.com/org/template/job@1.5.0
  inputs:
    some-input: value
```

- Use `include: - local:` only for pipeline files in the same repo.

## Job key ordering

Order the keys like this, omitting the ones you don't need:

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

- Name jobs `kebab-case`, using `:` as the namespace separator (*e.g.* `semantic-release:dry-run`).
- Set `needs: []` on jobs that must run immediately without waiting for prior stages.
- Set `interruptible: true` globally through `default:`. Override it with `interruptible: false` on release jobs.

## Variables

- Name variables `SCREAMING_SNAKE_CASE`.
- Never hardcode secrets. Use masked or protected CI/CD variables.

## Rules

- Write `rules:` with `if`/`when` pairs, over `only:`/`except:`.
- Block a case with an explicit `when: never`.
- End with `when: on_success` only when the job should run in every remaining context.
- End with `when: never` for an opt-in job (deploy, release), so it stays off in unmatched pipelines.

Always-on job, blocked on merge requests:

```yaml
rules:
  - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
    when: never
  - when: on_success
```

Opt-in job, running only on the default branch:

```yaml
rules:
  - if: '$CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH'
    when: on_success
  - when: never
```

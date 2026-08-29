---
alwaysApply: false
applyTo: "**/*.tf,**/*.tofu,**/*.tfvars"
description: Terraform / OpenTofu conventions
globs: ["**/*.tf", "**/*.tofu", "**/*.tfvars"]
paths: ["**/*.tf", "**/*.tofu", "**/*.tfvars"]
trigger: glob
---

# Terraform / OpenTofu

## Module file layout

Standard files per module: `versions.tf`, `providers.tf`, `variables.tf`, `main.tf`, `outputs.tf`.
Add `data_and_locals.tf` (not `locals.tf`) only when there are many data sources or locals, otherwise keep them in `main.tf`.
Add `imports.tf` for Terraform import blocks.

## Naming

- Single resource of a type in a module: use `"default"` as the resource label.
- Variables, locals, and outputs `snake_case`.

## Block ordering

- `for_each` and `count` first in resource and module blocks.
- `source` first in module blocks.
- Remaining args alphabetical.

## Provider blocks

- Add the registry doc URL as a comment above each `provider` block.
- Pin `required_version` and every provider `version` in `versions.tf`.

## Variables & outputs

- Every `variable` needs a `type` and a `description`.
- Every `output` needs a `description`.
- Field order in `variable`: `type`, `default`, `description` (then optional: `nullable`, `sensitive`, `validation`).
- No hardcoded values that belong in variables (account IDs, regions, CIDR blocks, domain names).
- Mark sensitive inputs with `sensitive = true`.

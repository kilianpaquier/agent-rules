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

- Give a root module these standard files: `versions.tf`, `providers.tf`, `variables.tf`, `main.tf`, `outputs.tf`.
- Give a child module the same set minus `providers.tf`, it inherits provider config from its caller.
- Declare `required_providers` in a child module's `versions.tf`.
- Add `data_and_locals.tf` (not `locals.tf`) only when data sources and locals together outgrow the resources in `main.tf`, otherwise keep them there.
- Add `imports.tf` for Terraform import blocks.

## Naming

- When a module holds a single resource of a type, label it `"default"`.
- Name variables, locals, and outputs `snake_case`.

## Block ordering

- Put `for_each` or `count` first in resource and module blocks.
- Put `source` next in module blocks, right after `for_each` or `count`.
- Keep the remaining args alphabetical.

## Provider blocks

- Add the registry doc URL as a comment above each `provider` block.
- Pin `required_version` and every provider `version` in `versions.tf`.

## Variables & outputs

- Every `variable` needs a `type` and a `description`.
- Every `output` needs a `description`.
- Order the fields in a `variable`: `type`, `default`, `description` (then optional: `nullable`, `sensitive`, `validation`).
- Never hardcode a value that belongs in a variable (account IDs, regions, CIDR blocks, domain names).
- Mark sensitive inputs with `sensitive = true`.

## Example

A root module, split across the standard files.

`versions.tf`:

```hcl
terraform {
  required_version = "1.9.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.60.0"
    }
  }
}
```

`providers.tf`:

```hcl
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  region = var.region
}
```

`variables.tf`:

```hcl
variable "region" {
  type        = string
  description = "AWS region hosting the module's resources."
}

variable "subnet_cidrs" {
  type        = map(string)
  default     = {}
  description = "CIDR block per subnet name."
  nullable    = false
}
```

`main.tf`:

```hcl
module "network" {
  source = "./modules/network"

  region       = var.region
  subnet_cidrs = var.subnet_cidrs
}

resource "aws_subnet" "default" {
  for_each = var.subnet_cidrs

  availability_zone = each.key
  cidr_block        = each.value
  vpc_id            = module.network.vpc_id
}
```

`outputs.tf`:

```hcl
output "subnet_ids" {
  description = "Subnet ID per subnet name."
  value       = { for k, v in aws_subnet.default : k => v.id }
}
```

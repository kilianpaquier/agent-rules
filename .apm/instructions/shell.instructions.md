---
alwaysApply: false
applyTo: "**/*.sh,**/*.bash,**/*.zsh"
description: Shell script conventions
globs: ["**/*.sh", "**/*.bash", "**/*.zsh"]
paths: ["**/*.sh", "**/*.bash", "**/*.zsh"]
trigger: glob
---

# Shell

## Shebang & portability

- Default `#!/bin/sh` (POSIX). Use `#!/bin/bash` or `#!/bin/zsh` only for a feature POSIX sh lacks.
- POSIX sh: `[ ]` tests, `$()` substitution, no `local`, no `[[ ]]`, no `((...))`.

## Error handling

Bash scripts, add at the top:

```sh
set -euo pipefail
```

POSIX scripts, add at the top:

```sh
set -e
```

## Style

- Quote every variable expansion. Leave one unquoted only for deliberate word splitting, with a comment saying so.
- Early exit from a function: `return <code>`. From a script: `exit <code>`. Non-zero signals failure.
- Function names `snake_case()`. No `function` keyword.
- `mktemp` for temp files, never a fixed `/tmp` path.
- `trap 'rm -rf "$tmpdir"' EXIT` when the script creates temp state.
- Run shellcheck on every script. Fix all warnings before finishing.
- Suppress a warning only with a targeted directive: `# shellcheck disable=SCxxxx`. Never bare `# shellcheck disable`.

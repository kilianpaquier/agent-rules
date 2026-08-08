---
alwaysApply: false
applyTo: "**/*.sh,**/*.bash,**/*.zsh"
description: Shell script conventions
globs: ["**/*.sh", "**/*.bash", "**/*.zsh"]
paths: ["**/*.sh", "**/*.bash", "**/*.zsh"]
---
# Shell

## Shebang & portability

- Default `#!/bin/sh` (POSIX). `#!/bin/bash`/`#!/bin/zsh` only when need feature POSIX sh lack.
- POSIX sh: `[ ]` tests, `$()` substitution, no `local`, no `[[ ]]`, no `((...))`.

## Error handling

Bash scripts, top add:
```sh
set -euo pipefail
```

POSIX scripts, top add:
```sh
set -e
```

## Style

- Early exit function: `return <code>`. Early exit script: `exit <code>`. Non-zero codes signal failure.
- Function names: `snake_case()`. No `function` keyword.
- Run shellcheck every script. Fix all warnings before finish.
- Quote variables when shellcheck require.
- Suppress warning only targeted directive: `# shellcheck disable=SCxxxx`. Never bare `# shellcheck disable`.

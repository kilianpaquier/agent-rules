---
alwaysApply: false
applyTo: "**/*.*sh"
description: Shell script conventions
globs: ["**/*.*sh"]
paths: ["**/*.*sh"]
trigger: glob
---

# Shell

Rules for a script run as its own process.

## Portability

- Default `#!/bin/sh` (POSIX): `[ ]` tests, `$()` substitution, no `local`, no `[[ ]]`, no `((...))`, no `function`.
- `#!/bin/bash` or `#!/bin/zsh` only for a feature POSIX sh lacks.
- First line after the shebang: `set -e` (POSIX), `set -euo pipefail` (bash).

## Traps

- `mktemp` for temp files, never a fixed `/tmp` path.
- The `EXIT` handler only cleans, no `$?` and no `exit`, the shell already carries the right status.
- `INT` and `TERM` need a trap each, otherwise the signal does not stop the script, it resumes and cleans twice.

## CLI

- `while`/`case` loop, not `getopts`, which has no `--long-option`.
- `-h` prints usage and succeeds, a parse error prints it and returns 2.
- `exit` only at top level, functions `return`.

## Style

- Quote every expansion, unquoted only for deliberate word splitting, with a comment saying so.
- Name functions `snake_case()`.
- Non-zero signals failure, whether it comes from a `return` or an `exit`.
- Run shellcheck on every script, fix all warnings before finishing.
- Suppress a warning only as `# shellcheck disable=SCxxxx`, never bare.

## Example

```sh
#!/bin/sh
set -e

# shellcheck disable=SC3040
(set -o pipefail >/dev/null 2>&1) && set -o pipefail

red='\033[0;31m'
no_color='\033[0m'

error() {
  printf "${red}ERROR${no_color} %s\n" "$1" >&2
  return 1
}

usage() {
  cat <<EOF >&2
Usage: <name> [-v|--verbose] [--out=FILE]
EOF
}

tmpdir=$(mktemp -d)
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

help=
verbose=
out=

parse_arguments() {
  while [ $# -gt 0 ]; do
    case $1 in
    -h | --help) usage; help=1; return 0 ;;
    -v | --verbose) verbose=1; shift ;;
    --out) out=$2; shift 2 ;;
    --out=*) out=${1#*=}; shift ;;
    *) usage; error "Unknown argument: $1"; return 2 ;;
    esac
  done
}

main() {
  parse_arguments "$@" || return $?
  [ -z "$help" ] || return 0
}

main "$@"
```

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

- Default to `#!/bin/sh` (POSIX). Use `[ ]` tests and `$()` substitution, never `local`, `[[ ]]`, `((...))`, or `function`.
- Use `#!/bin/bash` or `#!/bin/zsh` only for a feature POSIX sh lacks.
- Make `set -eu` (POSIX) or `set -euo pipefail` (bash) the first statement after the shebang.
- With `-u`, expand an optional positional or variable as `${2:-}`, never bare.

## Traps

- Use `mktemp` for temp files, never a fixed `/tmp` path.
- Keep the `EXIT` handler to cleanup only, with no `$?` and no `exit`. The shell already carries the right status.
- Trap `INT` and `TERM` each with an `exit`. Otherwise the signal doesn't stop the script, it resumes and cleans twice.

## CLI

- Parse arguments with a `while`/`case` loop, not `getopts`, which has no `--long-option`.
- Make `-h` print usage and succeed. Make a parse error print usage and return 2.
- Call `exit` only at top level. Functions `return`.

## Style

- Quote every expansion. Leave one unquoted only for deliberate word splitting, with a comment saying so.
- Name functions `snake_case()`.
- Signal failure with a non-zero status, whether from a `return` or an `exit`.
- Run shellcheck on every script and fix all warnings before finishing.
- Suppress a warning only as `# shellcheck disable=SCxxxx`, never bare.

## Example

```sh
#!/bin/sh

set -eu

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
Usage: <name> [-q|--quiet] [-x|--verbose] [--name=NAME]
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
name=world

parse_arguments() {
  while [ $# -gt 0 ]; do
    case $1 in
    -h | --help) usage; help=1; return 0 ;;
    -x | --verbose) set -x; shift ;;
    --name) name=$2; shift 2 ;;
    --name=*) name=${1#*=}; shift ;;
    *) usage; error "Unknown argument: $1"; return 2 ;;
    esac
  done
}

main() {
  parse_arguments "$@" || return $?
  [ -z "$help" ] || return 0

  echo "Hello, $name"
}

main "$@"
```

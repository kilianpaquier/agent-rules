---
alwaysApply: false
applyTo: "**/*.*sh,**/bin/*"
description: Shell script conventions
globs: ["**/*.*sh", "**/bin/*"]
paths: ["**/*.*sh", "**/bin/*"]
trigger: glob
# Keep the three glob keys identical.
---

# Shell

Rules for a script run as its own process. Skip them for a sourced file (zsh plugin, rc file).

## Layout

- Split the script into banner-commented sections (see the example): `Logging`, one section per domain, `CLI arguments`, `Main`.
- Declare each section's globals at its top.
- Keep cleanup, traps, `required_command` and `main` in `Main`.
- Write `main` as the steps of a run, one call per step.
- Write one function per unit (a tool, a platform) with a `case` on the action, called as `<unit> <action> [args]` (*e.g.* `github release <repo> <tag>`).
- Never write one function per action with a `case` on the units, which spreads each unit over every function.

## Portability

- Default to `#!/bin/sh` (POSIX). Use `[ ]` tests and `$()` substitution, never `local`, `[[ ]]`, `((...))`, or `function`.
- Use `#!/bin/bash` or `#!/bin/zsh` only for a feature POSIX sh lacks.
- Make `set -eu` (POSIX) or `set -euo pipefail` (bash) the first statement after the shebang.
- In POSIX sh, add `pipefail` only when the shell has it, as in the example.
- With `-u`, expand an optional positional or variable as `${2:-}`, never bare.

## Errors

- Signal failure with a non-zero status, whether from a `return` or an `exit`.
- Call `exit` only at top level. Functions `return`.
- `set -e` is off inside a function called from `if`, `while`, `!`, `||` or `&&`. Check each command that can fail there with `|| { error "..."; return 1; }`.
- Make `error` print to stderr and return 1, so `error "..." || failed=1` records a failure without stopping a loop.

## Traps

- Use `mktemp` for temp files, never a fixed `/tmp` path.
- Keep the `EXIT` handler to cleanup only, with no `$?` and no `exit`. The shell already carries the right status.
- Trap `INT` with `exit 130` and `TERM` with `exit 143`, so Ctrl-C or `kill` stops the script and runs the `EXIT` cleanup once.
- Create a temp file a background job (`&`) uses before starting the job. A subshell doesn't inherit the traps, so it can't clean the file.

## CLI

- Parse arguments with a `while`/`case` loop, not `getopts`, which has no `--long-option`.
- Make `-h` print usage and succeed. Make a parse error print usage and return 2.
- Check an option has a value before `shift 2`. Shifting past the last argument aborts a POSIX sh.
- Check external commands with `required_command` (see the example) at the start of `main`.
- Offer `-n, --dry-run` on a command that changes remote or shared state. Run every read step, skip only the writes.

## Usage

- Write the usage for the user, not for the implementation.
- Order it as `Usage:` line, one or two lines on what the command does for the user, `Arguments:`, `Examples:`, `Options:`, `Requirements:`.
- Keep an option description to one short clause. Give its default and environment variable in that clause, never in a separate paragraph.
- List each command `main` checks on its own `Requirements:` line, as `- '<command>' command for <purpose>`.

## Comments

- Write a header on every function that isn't both obvious and short ([Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html#function-comments)).
- Start with the description, then `Globals:`, `Arguments:`, `Outputs:` and `Returns:`, each only when relevant.
- Separate the description and each field with an empty `#` line, and indent field entries by 2 spaces.
- Document a unit action contract once, above the dispatcher or the first unit function.
- Skip the header on unit functions that contract already covers.

## Style

- Quote every expansion. Leave one unquoted only for deliberate word splitting, with a comment saying so.
- Name functions `snake_case()`.
- Run shellcheck on every script and fix all warnings before finishing.
- Suppress a warning only as `# shellcheck disable=SCxxxx`, never bare.

## Example

```sh
#!/bin/sh

set -eu

# shellcheck disable=SC3040
(set -o pipefail >/dev/null 2>&1) && set -o pipefail

#####################################################################
#
# Logging
#
#####################################################################

red='\033[0;31m'
no_color='\033[0m'

error() {
  printf "${red}ERROR${no_color} %s\n" "$1" >&2
  return 1
}

#####################################################################
#
# CLI arguments
#
#####################################################################

dry_run=
file=
help=
name=world

usage() {
  cat << 'EOF'
Usage: greet [-h] [-n] [--name <name>] <file>

Write a greeting into a file.

Arguments:
  file  File to write the greeting into

Examples:
  # Greet Alice in hello.txt
  greet --name Alice hello.txt

Options:
  -n, --dry-run    Show the greeting, write nothing.
  -h, --help       Show this help.
  --name <name>    Name to greet (default: world).

Requirements:
  - 'dirname' command for the file directory
  - 'mktemp' command for the temporary file
  - 'mv' command to replace the file
EOF
}

value_required() {
  [ $# -ge 2 ] || {
    usage
    error "Missing value for '$1'."
    return 2
  }
}

# Parses the CLI arguments.
#
# Globals:
#   dry_run, file, help, name (set)
#
# Returns:
#   2 on invalid arguments.
parse_arguments() {
  while [ $# -gt 0 ]; do
    case "$1" in
    -h | --help) usage; help=1; return 0 ;;
    -n | --dry-run) dry_run=1; shift ;;
    --name) value_required "$@" || return $?; name=$2; shift 2 ;;
    --name=*) name=${1#*=}; shift ;;
    -*) usage; error "Unknown argument '$1'."; return 2 ;;
    *) file=$1; shift ;;
    esac
  done

  [ -n "$file" ] || {
    usage
    error "Missing required file argument."
    return 2
  }
}

#####################################################################
#
# Main
#
#####################################################################

tmpfile=

cleanup() {
  [ -z "$tmpfile" ] || rm -f "$tmpfile"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

required_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    error "Required command '$1' wasn't found. Please install it."
    return 1
  fi
}

# Writes the greeting into the file, or only prints it in dry run.
main() {
  parse_arguments "$@" || return $?
  [ -z "$help" ] || return 0
  for cmd in dirname mktemp mv; do required_command "$cmd" || return $?; done

  if [ -n "$dry_run" ]; then
    echo "Hello, $name"
    return 0
  fi

  # Same directory as the file, so the final mv is atomic.
  tmpfile=$(mktemp "$(dirname "$file")/.greet.XXXXXX")
  echo "Hello, $name" > "$tmpfile"
  mv -f "$tmpfile" "$file"
}

main "$@"
```

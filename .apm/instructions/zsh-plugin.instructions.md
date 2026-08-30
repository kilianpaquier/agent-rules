---
alwaysApply: false
applyTo: "**/*.zsh"
description: ZSH plugin conventions
globs: ["**/*.zsh"]
paths: ["**/*.zsh"]
trigger: glob
---

# ZSH plugin

Covers `*.zsh` and any file a plugin sources or autoloads, whatever its extension or shebang.
Such files are functions in the user's interactive shell, not a process,
those specific rules regarding traps and `exit` override default shell instructions.

## Never exit

- No `exit`, anywhere, trap included, it kills the user's shell and closes the terminal.
- `trap 'exit 130' INT` and `trap 'exit 143' TERM` belong to standalone scripts, here they close the terminal on Ctrl-C.
- Ctrl-C already aborts the function and returns 130, only the cleanup is left to handle.

## Contain shell state

- Options and traps set in the body leak into the caller's shell, `setopt localoptions localtraps` reverts both on return.
- Guard that on `$ZSH_VERSION`, so the file still runs standalone under `sh`, which has no `setopt`.
- Variables leak with no such fix, POSIX sh has no `local`. Keep them few and prefixed.

## Cleanup

- `trap cleanup EXIT` fires on function return, but zsh skips it when Ctrl-C aborts the function.
- Clean on interrupt in a `TRAPINT` ending with `return $((128 + $1))` to return the initial status.
- `cleanup` unsets every function the file defines, itself included.
- `localtraps` is what drops `TRAPINT` on return, without it it stays global and hijacks every later Ctrl-C.

## Example

```sh
#!/bin/sh

# zsh autoloads this file as a function, keep option and trap changes out of the caller's shell
[ -z "$ZSH_VERSION" ] || setopt localoptions localtraps

tmpdir=

cleanup() {
  [ -z "$tmpdir" ] || rm -rf "$tmpdir"
  unset -f cleanup main
}
trap cleanup EXIT

# zsh aborts the function on Ctrl-C without running the EXIT trap
if [ -n "$ZSH_VERSION" ]; then
  TRAPINT() {
    cleanup
    return $((128 + $1))
  }
fi

main() {
  tmpdir=$(mktemp -d)
}

main "$@"
```

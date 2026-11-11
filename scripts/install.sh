#!/bin/sh

set -e

dir="$(realpath "$(dirname "$0")")"

for target in .claude/rules .copilot/instructions .devin/rules; do
  # Skip agents that aren't installed.
  [ -d "$HOME/${target%%/*}" ] || continue

  target="$HOME/$target"
  mkdir -p "$target"

  # Remove old instructions, other files in the directory are left alone.
  rm -f "$target/"*.instructions.md

  # Replace with new instructions.
  cp "$dir/../.apm/instructions/"*.instructions.md "$target/"
done

---
alwaysApply: false
applyTo: "**/*.{go,ts,tsx,js,jsx,mjs,py,rs,java,tf,tofu},**/*.*sh"
description: Language-neutral code conventions
globs: ["**/*.{go,ts,tsx,js,jsx,mjs,py,rs,java,tf,tofu}", "**/*.*sh"]
paths: ["**/*.{go,ts,tsx,js,jsx,mjs,py,rs,java,tf,tofu}", "**/*.*sh"]
trigger: glob
# Keep the three glob keys identical.
---

# Code

Language-neutral rules. A language instruction file overrides these where they conflict.

## Design

- Never write a defensive check for a structurally impossible input or state. Handle only the errors a function's signature can return.
- Never keep a backwards-compat shim or stub for removed code.
- Never abstract prematurely. Reach for a concrete type first, and add an interface only when two or more implementations exist.

## Safety

- Validate input crossing a trust boundary (user input, network payload, file content), meaning untrusted data rather than the internal invariants under Design.
- Use parameterized queries only. Never build SQL, shell, or path strings by concatenation.

## Dependencies

- Check the stdlib and existing dependencies before adding one.
- Never add a dependency for a single function's worth of behavior.

## Style

- Never put a regex running on untrusted input, or using backtracking constructs, in code unless the user validated it.
- An anchored literal pattern needs no round-trip.

## Testing

- Test behavior, not implementation.
- Never test a getter, a constant, or an unreachable code path.
- Assert one behavior per test.
- Mark test phases with `Arrange`, `Act`, `Assert` comments, written in the file's own comment syntax (`// Arrange`, `# Arrange`, `<!-- Arrange -->`).
- Drop the phase comment when a phase has no steps.

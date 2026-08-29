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

- No defensive checks for structurally impossible inputs or states. Handle real error returns only.
- No backwards-compat shims or stubs for removed code.
- No premature abstraction. Concrete type first. Interface only when two or more implementations exist.

## Safety

- Validate input crossing a trust boundary (user input, network payload, file content).
  This covers untrusted data, not the internal invariants under Design.
- Parameterized queries only. Never build SQL, shell, or path strings by concatenation.

## Dependencies

- Check the stdlib and existing dependencies before adding one.
- No new dependency for what a few lines of code do.

## Style

- Never put a regex in code unless the user validated it.

## Testing

- Test behavior, not implementation.
- No tests for trivial or unreachable code paths.
- Keep tests minimal and focused: one behavior per test.
- Mark test phases with `// Arrange`, `// Act`, `// Assert` comments (drop the comment when a phase has no steps).

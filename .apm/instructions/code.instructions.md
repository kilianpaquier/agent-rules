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

## Safety

- Validate input crossing a trust boundary (user input, network payload, file content), meaning untrusted data rather than the internal invariants under Design.
- Use parameterized queries only. Never build SQL, shell, or path strings by concatenation.
- Never ship a regex that runs on untrusted input or uses backtracking constructs unless the user validated it.
- An anchored literal pattern needs no validation.

## Dependencies

- Check the stdlib and existing dependencies before adding one.
- Never add a dependency for a single function's worth of behavior.

## Testing

- Test behavior, not implementation.
- Never test a getter, a constant, or an unreachable code path.
- Assert one behavior per test.
- Mark test phases with `Arrange`, `Act`, `Assert` comments, written in the file's own comment syntax (`// Arrange`, `# Arrange`, `<!-- Arrange -->`).
- Drop the phase comment when a phase has no steps.
- When a test or check fails, fix the code. Never delete, skip, or loosen a test or assertion to make it pass.

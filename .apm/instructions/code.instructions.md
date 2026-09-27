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

## Safety

- Validate input crossing a trust boundary (user input, network payload, file content). Internal invariants need no check.
- Use parameterized queries only. Never build SQL, shell, or path strings by concatenation.
- Never ship a regex that runs on untrusted input or uses backtracking constructs unless the user validated it.
- An anchored literal pattern needs no validation.

## Testing

- Test behavior, not implementation.
- Never test a getter, a constant, or an unreachable code path.
- Assert one behavior per test.
- Mark test phases with `Arrange`, `Act`, `Assert` comments, written in the file's own comment syntax (`// Arrange`, `# Arrange`, `<!-- Arrange -->`).
- Drop the phase comment when a phase has no steps.
- When a test or check fails, fix the code. Never delete, skip, or loosen a test or assertion to make it pass.

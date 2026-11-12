---
alwaysApply: false
applyTo: "**/*.{go,ts,tsx,js,jsx,mjs,py,rs,java,tf,tofu},**/*.*sh,**/bin/*"
description: Language-neutral code conventions
globs: ["**/*.{go,ts,tsx,js,jsx,mjs,py,rs,java,tf,tofu}", "**/*.*sh", "**/bin/*"]
paths: ["**/*.{go,ts,tsx,js,jsx,mjs,py,rs,java,tf,tofu}", "**/*.*sh", "**/bin/*"]
trigger: glob
---

# Code

Language-neutral rules. A language instruction file overrides these where they conflict.

## Safety

- Validate input crossing a trust boundary (user input, network payload, file content). Internal invariants need no check.
- Use parameterized queries only. Never build SQL, shell commands, or paths by concatenating untrusted input. Use parameters, argument arrays, or a path join checked to stay inside its base directory.
- Never ship a regex that runs on untrusted input and uses backtracking constructs (nested quantifiers, backreferences) unless the user reviewed and approved that regex.
- An anchored literal pattern needs no approval.

## Testing

- Test behavior, not implementation.
- Never test a getter, a constant, or an unreachable code path.
- Assert one behavior per test.
- Mark test phases with `Arrange`, `Act`, `Assert` comments, written in the file's own comment syntax (`// Arrange`, `# Arrange`).
- Drop the phase comment when a phase has no steps.
- Build multi-line inputs (config, fixtures, mocks) in `Arrange`.
- Inline a short value in the `Act` call only when it fits on one line (*e.g.* a context, a literal).

## Comments

- Prefer an if/else or a switch over a ternary when a branch needs its own comment.
- Put that comment directly above the branch it documents.

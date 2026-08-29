---
alwaysApply: false
applyTo: "**/*.ts,**/*.tsx,**/*.js"
description: TypeScript / JavaScript conventions
globs: ["**/*.ts", "**/*.tsx", "**/*.js"]
paths: ["**/*.ts", "**/*.tsx", "**/*.js"]
trigger: glob
---

# TypeScript / JavaScript

## Functions & exports

- Export functions as arrows: `export const fn = (...) => { }`.
- Named exports only, no default.
- File names `kebab-case`.

## Types

- `interface` for a public contract (object, class shape).
- `type` for aliases and unions.
- Enum values SCREAMING_SNAKE_CASE strings.
- Never `any`. Use `unknown` and narrow.

## Async

- `async`/`await` over `.then()` chains.
- Never float a promise. Await it, return it, or mark it `void` deliberately.
- Every `await` in a failure-capable path needs rejection handling.

## Errors

- Always throw errors, never return them as values.

## Style

- No semicolons (ESLint/Prettier `semi: false`).
- Always braces for `if`, `else`, `for`, `while`. No single-statement inline.
- No labeled statements, labeled `break`/`continue`, or goto-style control flow.

## Imports

- Sort alphabetically within each group (ESLint `sort-imports`).
- No default import from a local module.

## Comments

- JSDoc on every exported function (params, return type, thrown errors).

### Example

```typescript
/**
 * functionName does something with the given input.
 *
 * @param param1 description of param1.
 * @param param2 description of param2.
 *
 * @returns the computed result.
 *
 * @throws an error if something goes wrong.
 */
export const functionName = (param1: string, param2: number): string => { ... }
```

## Tests

- Match the project's framework (Bun test, Jest, Vitest).
- File pattern `*.test.ts`.
- Structure with `describe` and `test`.
- Mock with `spyOn` and framework teardown in `afterEach` (*e.g.* `mock.restore()` Bun, `jest.restoreAllMocks()` Jest, `vi.restoreAllMocks()` Vitest).

### Example

```typescript
describe("myFunction", () => {
  afterEach(() => restoreMocks()) // framework-specific teardown

  test("should return processed value", () => {
    // Arrange
    spyOn(dep, "fetch").mockResolvedValue({ ok: true, data: "raw" })

    // Act
    const result = myFunction("input")

    // Assert
    expect(result).toEqual("processed")
  })
})
```

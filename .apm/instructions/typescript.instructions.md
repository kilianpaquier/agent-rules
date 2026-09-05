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
- Use named exports only, never a default.
- Name files `kebab-case`, unless the project's framework convention says otherwise (React and Next.js components).

## Types

- Use `interface` for a public contract (object, class shape).
- Use `type` for aliases and unions.
- Write enum values as SCREAMING_SNAKE_CASE strings.
- Never use `any`. Use `unknown` and narrow it.

## Async

- Prefer `async`/`await` over `.then()` chains.
- Never float a promise. Await it, return it, or mark it `void` deliberately.
- Every `await` in a failure-capable path needs rejection handling.

## Errors

- Always throw errors, never return them as values.

## Style

- Match the project's ESLint or Prettier config wherever it disagrees with this section. These are the defaults for a new project.
- Never write semicolons (ESLint/Prettier `semi: false`).
- Always brace `if`, `else`, `for`, and `while`. Never inline a single statement.
- Never use a labeled statement, a labeled `break`/`continue`, or goto-style control flow.

## Imports

- Sort alphabetically within each group (ESLint `sort-imports`).
- Never default-import from a local module.

## Comments

- Write JSDoc on every exported function (params, return type, thrown errors).

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
- Name test files `*.test.ts`.
- Structure them with `describe` and `test`.
- Mock with `spyOn` and put the framework teardown in `afterEach` (*e.g.* `mock.restore()` Bun, `jest.restoreAllMocks()` Jest, `vi.restoreAllMocks()` Vitest).

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

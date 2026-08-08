---
alwaysApply: false
applyTo: "**/*.ts,**/*.tsx,**/*.js"
description: TypeScript / JavaScript conventions
globs: ["**/*.ts", "**/*.tsx", "**/*.js"]
paths: ["**/*.ts", "**/*.tsx", "**/*.js"]
---
# TypeScript / JavaScript

## Functions & exports

- Export fn: arrow (`export const fn = (...) => { }`).
- Named export only, no default.
- File name: `kebab-case`.

## Types

- `interface` for public contract (object, class shape).
- `type` for alias, union.
- Enum value: SCREAMING_SNAKE_CASE string.

## Errors

- Throw error always, never return as value.

## Style

- No semicolon (ESLint/Prettier `semi: false`).
- Always braces `{ }` for `if`/`else`/`for`/`while`/etc. No single-statement inline.
- No labeled statement (`label:`), labeled `break`/`continue`, `goto`-style control flow.

## Imports

- Sort alphabetical within group (ESLint `sort-imports`).
- No default import from local module.

## Comments

- JSDoc on every export fn (params, return type, thrown error).

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

- Framework: match project (Bun test, Jest, Vitest, etc).
- File pattern: `*.test.ts`.
- Structure: `describe` + `test`.
- Mock: `spyOn` + framework teardown in `afterEach` (*e.g.* `mock.restore()` Bun, `jest.restoreAllMocks()` Jest, `vi.restoreAllMocks()` Vitest).

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

---
alwaysApply: false
applyTo: "**/*.go"
description: Go file conventions
globs: ["**/*.go"]
paths: ["**/*.go"]
trigger: glob
---

# Go

## Comments

- Write a GoDoc comment on every exported identifier (func, type, var, const).
- Use `doc.go` for package-level docs.

### Example

Single-line, for most identifiers:

```go
// FunctionName does something with input and returns result.
func FunctionName(input string) (string, error) { ... }

// TypeName represents something.
type TypeName struct { ... }
```

Multiline when extra context is needed, separating paragraphs with `//`:

```go
// FunctionName does something with input and returns result.
//
// It also handles the edge case where input is empty.
// In that case, it returns an error.
func FunctionName(input string) (string, error) { ... }
```

`doc.go`, for the package-level doc:

```go
/*
Package mypkg provides utilities for doing something.

Optional additional paragraphs describing the package further.

Example:

  func main() {
    result, err := mypkg.FunctionName("input")
    // handle err
  }
*/
package mypkg
```

## Concurrency

- Every goroutine needs a cancellation path (`context.Context` or a done channel).
- Never write a naked `go` in a request path. Use `errgroup.Group` for fan-out and propagate the first error.
- Go 1.22+ scopes loop variables per iteration. On older versions, copy the variable before capturing it.

## Context

- Pass `context.Context` as the first param, after the receiver, and name it `ctx`.

## Declarations

- Use `:=` for local vars. Keep `var` for zero values, package-level declarations, and interface compliance checks.
- Avoid named return values, except when a deferred call must set the returned error.
- Avoid global `var` declarations unless required.
- Avoid `init()`. Use constructor funcs instead.
- Prefer `any` over `interface{}`.
- Write struct tags lowercase, with a snake_case field name and no spaces around `:` (*e.g.* `json:"created_at"`).

## Errors

- Wrap with `fmt.Errorf("<what you were doing>: %w", err)`. Never swallow an error.
- Declare `var ErrFoo = errors.New("...")` only when a caller needs `errors.Is` or `errors.As`.
- Write error strings lowercase, one clause, with no trailing punctuation.
- Aggregate with `errors.Join(errs...)`.
- When deferred cleanup returns an error (`Close`, `Rollback`, and similar), log it if a logger is in scope, otherwise ignore it.
- Propagate it through a named return only when the failure loses data (*e.g.* a buffered writer `Close`).

## Interfaces

- Verify compliance at compile time: `var _ MyInterface = (*MyType)(nil)`

## Linting

- Target every `//nolint:rulename` directive. Never write a bare `//nolint`.

## Optimizations

- Pre-allocate slices and maps when the final size is known: `make([]T, 0, n)` and `make(map[K]V, n)`.
- When the size isn't known before the loop, declare no capacity (`var s []T`). Add `//nolint:prealloc` only when golangci-lint flags it.
- Use `strings.Builder` or `bytes.Buffer` to assemble strings. Never concat with `+` in a loop.
- Prefer `slices.*` and `maps.*` (stdlib, Go 1.21+) over a manual for-range.
- Range over the index only (`for i := range s`) when the value isn't needed, it avoids an implicit copy.

## Receivers

- Use a pointer receiver when the method mutates state, or when the type contains a `sync` type or a large array.
- Keep receivers consistent within a type.

## Struct literals

- When it fits on one line, keep it on one line with fields comma-separated.
- When it doesn't fit, put every field on its own line (gofmt aligns the colons).
- Never group 2+ fields on a wrapped line.
- Never partial-wrap a field list.
- When a nested struct also doesn't fit, break it level by level with one `Field: &Type{` opener per line.
- Never cram multiple opening braces onto one line.
- When a slice needs breaking, put one element per line. Each element can stay compact on its own line when it fits.

```go
// bad: partial grouping across wrapped lines
Config: pkg.Options{
	Name: "foo", Tags: []string{"a", "b"},
	Owner: "bar", Path: "p", Region: "r",
},

// good: every field its own line once wrapped
Config: pkg.Options{
	Name:   "foo",
	Tags:   []string{"a", "b"},
	Owner:  "bar",
	Path:   "p",
	Region: "r",
},
```

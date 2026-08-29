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

- GoDoc comment on every exported identifier (func, type, var, const).
- Use `doc.go` for package-level docs.

### Example

Single-line (most identifiers):

```go
// FunctionName does something with input and returns result.
func FunctionName(input string) (string, error) { ... }

// TypeName represents something.
type TypeName struct { ... }
```

Multiline (extra context needed, separate paragraphs with `//`):

```go
// FunctionName does something with input and returns result.
//
// It also handles the edge case where input is empty.
// In that case, it returns an error.
func FunctionName(input string) (string, error) { ... }
```

`doc.go` (package-level doc):

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
- No naked `go` in a request path. Use `errgroup.Group` for fan-out and propagate the first error.
- Go 1.22+ scopes loop variables per iteration. On older versions, copy the variable before capturing it.

## Context

- `context.Context` always first param (after the receiver), named `ctx`.

## Declarations

- `:=` for local vars. `var` only for zero values, package-level declarations, interface compliance checks.
- Avoid named return values, except when a deferred call must set the returned error.
- Avoid global `var` declarations unless required.
- Avoid `init()`. Use constructor funcs instead.
- `any` over `interface{}`.
- Struct tags lowercase, snake_case field name, no spaces around `:` (*e.g.* `json:"created_at"`).

## Errors

- Wrap with `fmt.Errorf("small context information: %w", err)`. Never swallow an error.
- Declare `var ErrFoo = errors.New("...")` only when a caller needs `errors.Is` or `errors.As`.
- Error strings short, lowercase, no trailing punctuation.
- Aggregate with `errors.Join(errs...)`.
- Deferred cleanup returning an error (`Close`, `Rollback`, and similar): log it when a logger is in scope, otherwise ignore.
  Propagate through a named return only when the failure loses data (*e.g.* a buffered writer `Close`).

## Interfaces

- Verify compliance at compile time: `var _ MyInterface = (*MyType)(nil)`

## Linting

- Targeted `//nolint:rulename` directives. Never bare `//nolint`.

## Optimizations

- Pre-allocate slices and maps when the final size is known: `make([]T, 0, n)` and `make(map[K]V, n)`.
- Size unknown before the loop: declare no capacity (`var s []T`). Add `//nolint:prealloc` only when golangci-lint flags it.
- Use `strings.Builder` or `bytes.Buffer` to assemble strings. Never concat with `+` in a loop.
- Prefer `slices.*` and `maps.*` (stdlib, Go 1.21+) over a manual for-range.
- Index-only range (`for i := range s`) when the value isn't needed, avoids an implicit copy.

## Receivers

- Pointer receiver when the method mutates state or the type is large.
- Keep receivers consistent within a type.

## Struct literals

- Fits one line: keep it one line, fields comma-separated.
- Doesn't fit: every field on its own line (gofmt aligns the colons). Never group 2+ fields on a wrapped line, never partial-wrap a field list.
- Nested struct also too long: break level by level, one `Field: &Type{` opener per line. Never cram multiple opening braces onto one line.
- Slice needs breaking: one element per line. Each element can stay compact on one line if it fits on its own.

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

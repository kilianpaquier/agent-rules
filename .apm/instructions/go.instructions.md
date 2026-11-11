---
alwaysApply: false
applyTo: "**/*.go"
description: Go file conventions
globs: ["**/*.go"]
paths: ["**/*.go"]
trigger: glob
---

# Go

Follow [**Effective Go**](https://go.dev/doc/effective_go), the [**Uber** Go Style Guide](https://github.com/uber-go/guide/blob/master/style.md),
the [**Go** Code Review Comments](https://go.dev/wiki/CodeReviewComments)
and the `go` skill alongside these rules.
These rules override them on any conflict.

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

## Declarations

- Never use named return values, except when a deferred call must set the returned error.
- Write struct tags lowercase, with a snake_case field name and no spaces around `:` (*e.g.* `json:"created_at"`).
- Prefer unexported helpers. Export a func only when non-test code outside its package calls it.

## Errors

- When deferred cleanup returns an error (`Close`, `Rollback`, and similar), log it if a logger is in scope, otherwise ignore it.
- Propagate it through a named return only when the failure loses data (*e.g.* a buffered writer `Close`).

## Interfaces

- Verify compliance at compile time: `var _ MyInterface = (*MyType)(nil)`

## Linting

- Target every `//nolint:rulename` directive. Never write a bare `//nolint`.

## Optimizations

- When the size isn't known before the loop, declare no capacity (`var s []T`). Add `//nolint:prealloc` only when golangci-lint flags it.
- Use `strings.Builder` or `bytes.Buffer` to assemble strings. Never concat with `+` in a loop.

## Struct literals

- When it fits on one line, keep it on one line with fields comma-separated.
- When it doesn't fit, put every field on its own line. Never group 2+ fields on a wrapped line, never partial-wrap a field list.
- When a nested struct also doesn't fit, break it level by level with one `Field: &Type{` opener per line. Never cram multiple opening braces onto one line.
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

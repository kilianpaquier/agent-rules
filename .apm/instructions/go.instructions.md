---
alwaysApply: false
applyTo: "**/*.go"
description: Go file conventions
globs: ["**/*.go"]
paths: ["**/*.go"]
---
# Go

## Comments

- GoDoc comment every exported ident (func, type, var, const).
- Use `doc.go` files pkg-level docs.

### Example

Single-line (most idents):

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

`doc.go` (pkg-level doc):

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

## Context

- `context.Context` always first param (after receiver), named `ctx`.

## Declarations

- `:=` local vars. `var` only zero values, pkg-level decls, interface compliance checks.
- Avoid named return values.
- Avoid global `var` decls unless required.
- Avoid `init()`. Use constructor funcs instead.

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

## Errors

- Wrap `fmt.Errorf("small context information: %w", err)`. Never swallow errors.
- Declare `var ErrFoo = errors.New("...")` only when caller needs `errors.Is`/`errors.As`.
- Error strings: short, lowercase, no trailing punctuation.
- Aggregate multiple errors `errors.Join(errs...)`.

## Interfaces

- Concrete types default. Interface only when two+ distinct implementations exist.
- Verify compliance compile time: `var _ MyInterface = (*MyType)(nil) // ensure interface is implemented`

## Linting

- Targeted `//nolint:rulename` directives. Never bare `//nolint`.

## Optimizations

- Pre-allocate slices/maps when final size known: `make([]T, 0, n)` and `make(map[K]V, n)`.
- Size unknown before loop: declare no capacity (`var s []T`). Add `//nolint:prealloc` only when golangci-lint flags.
- Use `strings.Builder` or `bytes.Buffer` assemble strings. Never concat `+` in loop.
- Prefer `slices.*`/`maps.*` (stdlib, Go 1.21+) over manual for-range.
- Index-only range (`for i := range s`) when value not needed, avoids implicit copy.

## Receivers

- Pointer receiver when method mutates state or type large.
- Keep receivers consistent within type.

## Libraries

### Cobra CLI

- CLI code dedicated pkg (*e.g.*, `internal/cobra/`). One file per command + matching `_test.go`.
- Name constructors `{name}Cmd() *cobra.Command`. Shared state as params, not globals.
- Wire subcommands single top-level `Execute()` func.
- Always `RunE`, not `Run`.
- Set `SilenceErrors: true` and `SilenceUsage: true` on root cmd. Handle error/usage printing manual.
- `PersistentPreRunE` for cross-cutting setup (logger, working dir). `PreRunE` for command-specific validation.
- `PersistentFlags()` for flags inherited by all subcommands. `Flags()` for command-local flags.
- Enforce flag constraints `MarkFlagRequired()` and related `MarkFlags*` methods.
- Flag names as pkg-level constants, reuse across files/tests.
- No `viper`. Local helpers `getenv()` and `coalesce()`.
  - `getenv` maps kebab-case flag name to `SCREAMING_SNAKE_CASE` env var
  - `coalesce` returns first non-empty string. Use `coalesce(getenv(flagName), hardcodedDefault)` as flag default.

#### Example

```go
func Execute() {
	root := rootCmd()
	root.AddCommand(fooCmd())

	if err := root.Execute(); err != nil {
		subcmd, _, _ := root.Find(os.Args[1:])
		usage(root, subcmd, err) // print cmd usage for unknown flag / command errors
		os.Exit(1) //nolint:revive
	}
}

func rootCmd() *cobra.Command {
	logLevel := "info"
	cmd := &cobra.Command{ /* ... */ }
	cmd.PersistentFlags().StringVar(&logLevel, flagLogLevel, coalesce(getenv(flagLogLevel), logLevel), "set logging level")
	return cmd
}
```

---
alwaysApply: false
applyTo: "**/cmd/**/*.go,**/cmd/*.go,**/internal/cobra/**/*.go"
description: Go Cobra CLI conventions
globs: ["**/cmd/**/*.go", "**/cmd/*.go", "**/internal/cobra/**/*.go"]
paths: ["**/cmd/**/*.go", "**/cmd/*.go", "**/internal/cobra/**/*.go"]
trigger: glob
---

# Go Cobra CLI

## Structure

- CLI code in a dedicated package (*e.g.* `internal/cobra/`). One file per command plus a matching `_test.go`.
- Name constructors `{name}Cmd() *cobra.Command`. Pass shared state as params, not globals.
- Wire subcommands in a single top-level `Execute()` func.

## Commands

- Always `RunE`, not `Run`.
- Set `SilenceErrors: true` and `SilenceUsage: true` on the root command. Handle error and usage printing manually.
- `PersistentPreRunE` for cross-cutting setup (logger, working dir). `PreRunE` for command-specific validation.

## Flags

- `PersistentFlags()` for flags inherited by all subcommands. `Flags()` for command-local flags.
- Enforce flag constraints with `MarkFlagRequired()` and the related `MarkFlags*` methods.
- Flag names as package-level constants, reused across files and tests.
- No `viper`. Use local helpers `getenv()` and `coalesce()`.
  - `getenv` maps a kebab-case flag name to a `SCREAMING_SNAKE_CASE` env var.
  - `coalesce` returns the first non-empty string. Use `coalesce(getenv(flagName), hardcodedDefault)` as a flag default.

## Example

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

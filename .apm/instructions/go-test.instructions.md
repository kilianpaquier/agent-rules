---
alwaysApply: false
applyTo: "**/*_test.go"
description: Go test file conventions
globs: ["**/*_test.go"]
paths: ["**/*_test.go"]
trigger: glob
---

# Go tests

Follow these sources in order. A source that is missing, or too vague to settle the case, is completed by the next one for that point only:

1. The `go:go` skill (spf13), invoked, never consulted online
2. [**Google** Go Style Guide](https://google.github.io/styleguide/go/guide)
3. [**Uber** Go Style Guide](https://github.com/uber-go/guide/blob/master/style.md)

The rules in this file override all of them on any conflict.

## Package naming

- Default to the external test package `package foo_test`.
- Use `package foo` only when the project already does. Check existing test files first.
- When a directory has both styles, match the file you're extending. New standalone test files default to `package foo_test`.

## Structure

- Use `t.Run("description", func(t *testing.T) { ... })` subtests for each test case.
- Name subtests snake_case, prefixed `success_` or `error_` (*e.g.* `success_empty_input`, `error_invalid_json`).
- Before writing a test, read a sibling `_test.go` in the same package and match its subtest order and layout.
- When the package has no sibling `_test.go`, order every `error_` subtest first, then the `success_` ones.
- Never introduce a table-driven test (struct slice plus range) unless asked.
- When extending a file that already uses one, match it.
- Use `t.Cleanup(fn)` for teardown and state restore, over `defer` in subtests.
- Use `t.TempDir()` for file I/O (cleaned up automatically).
- From Go 1.24 (`go` directive in `go.mod`), call `t.Context()` inside each subtest on its own `t`, never through a `ctx` built from the parent `t`.
- Prefer literal fixtures (`testdata/` files, inline values) over builder helpers.

## Assertions

- Match the project's existing test library. When no library is present, use the stdlib `testing` only.
- Use `require.` (or an equivalent fail-fast) for preconditions, and `assert.` for the assertions themselves.

### Example

Stdlib:

```go
package files_test

import (
	"os"
	"path/filepath"
	"strings"
	"testing"

	"gitlab.com/org/project/internal/files"
)

func TestReadJSON(t *testing.T) {
	t.Run("error_invalid_json", func(t *testing.T) {
		// Arrange
		path := filepath.Join(t.TempDir(), "bad.json")
		if err := os.WriteFile(path, []byte("{invalid}"), 0o644); err != nil {
			t.Fatalf("write fixture: %v", err)
		}

		// Act
		var result map[string]any
		err := files.ReadJSON(path, &result)

		// Assert
		if err == nil || !strings.Contains(err.Error(), "unmarshal") {
			t.Errorf("got %v, want an error containing \"unmarshal\"", err)
		}
	})
}
```

Testify:

```go
package files_test

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"gitlab.com/org/project/internal/files"
)

func TestReadJSON(t *testing.T) {
	t.Run("error_invalid_json", func(t *testing.T) {
		// Arrange
		path := filepath.Join(t.TempDir(), "bad.json")
		require.NoError(t, os.WriteFile(path, []byte("{invalid}"), 0o644))

		// Act
		var result map[string]any
		err := files.ReadJSON(path, &result)

		// Assert
		assert.ErrorContains(t, err, "unmarshal")
	})
}
```

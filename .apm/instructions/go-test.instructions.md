---
alwaysApply: false
applyTo: "**/*_test.go"
description: Go test file conventions
globs: ["**/*_test.go"]
paths: ["**/*_test.go"]
trigger: glob
---

# Go tests

## Package naming

- Always use the external test package: `package foo_test`.
- Use `package foo` only when the project already does. Check existing test files first.
- Directory has both styles: match the file being extended. New standalone test files default to `package foo_test`.

## Structure

- Use `t.Run("description", func(t *testing.T) { ... })` subtests for each test case.
- No table-driven tests (struct slice plus range) unless asked.
- Use `t.Cleanup(fn)` for teardown and state restore, over `defer` in subtests.
- Use `t.TempDir()` for file I/O (cleaned up automatically).
- Mark test helpers with `t.Helper()` as the first statement.

## Assertions

- Match the project's existing test library.
- No library present: stdlib `testing` only.
- `require.` (or equivalent fail-fast) for preconditions, `assert.` for the actual assertions.

### Example

Stdlib: same shape as the **testify** example below, with `t.Fatalf` and `if` checks instead of `require.`/`assert.`.

```go
package files_test

import (
  "os"
  "path/filepath"
  "testing"

  "github.com/stretchr/testify/assert"
  "github.com/stretchr/testify/require"
)

func TestReadJSON(t *testing.T) {
  t.Run("invalid json returns error", func(t *testing.T) {
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

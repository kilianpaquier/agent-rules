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
- When a directory has both styles, match the file you're extending. New standalone test files default to `package foo_test`.

## Structure

- Use `t.Run("description", func(t *testing.T) { ... })` subtests for each test case.
- Never introduce a table-driven test (struct slice plus range) unless asked.
- When extending a file that already uses one, match it.
- Use `t.Cleanup(fn)` for teardown and state restore, over `defer` in subtests.
- Use `t.TempDir()` for file I/O (cleaned up automatically).
- Mark test helpers with `t.Helper()` as the first statement.

## Assertions

- Match the project's existing test library.
- When no library is present, use the stdlib `testing` only.
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
  t.Run("invalid json returns error", func(t *testing.T) {
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

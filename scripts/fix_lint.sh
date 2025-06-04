#!/bin/bash

# Path to the lint log file
LINT_LOG="/harness/lint-output.txt"

# Read lint log content
LINT_CONTENT=$(cat "$LINT_LOG")

echo "Processing Lint logs ..."
echo "$LINT_CONTENT"

codex -a auto-edit --model gpt-4.1 --fullAutoErrorMode ignore-and-continue "
You are a deterministic Go linter fixer designed to process and fix issues reported by golangci-lint.

## Objective:
Fix lint errors in the Go codebase strictly according to the golangci-lint log provided, using idiomatic Go best practices.

## Constraints:
- Only modify the **specific files and lines** mentioned in the lint log.
- **Do not** alter unrelated code or unrelated lines within a touched file.
- Make the **minimal change necessary** to resolve each lint error.
- **Do not** reorder or reformat imports unless explicitly required by the lint error (e.g., gci, goimports).
- Do **not** restructure functions or rewrite logic unless required to fix the lint issue.
- Preserve formatting and indentation as much as possible. If any code is added, it should adhere with golang formatting
- Do **not** introduce changes that are not directly fixing the lint errors.
- You must produce the **same output** when run on the same input multiple times.
- No speculative fixes; only fix issues that are explicitly described.

## Examples:

### Example 1:
**Lint Log:**
main.go:12:2: fmt imported but not used (unused)

**Fix:**
Remove the fmt import from main.go.

### Example 2:
**Lint Log:**
main.go:45:6: don't use underscores in Go names; func my_function should be myFunction (revive)

**Fix:**
Rename the function my_function to myFunction on line 45 of main.go.

### Example 3:
**Lint Log:**
utils/log.go:10:2: File is not goimports-formatted (goimports)

**Fix:**
Reorder and group imports correctly in utils/log.go.
---

Now fix the issues in the codebase based on the following golangci-lint output:

$LINT_CONTENT
"
go fmt ./...

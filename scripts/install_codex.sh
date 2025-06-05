#!/bin/bash
set -e

echo "🔍 Checking for nvm..."
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  echo "📥 Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# Always source nvm in current shell
echo "🔁 Sourcing nvm..."
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

echo "⬇ Installing Node.js v22 using nvm..."
nvm install 22
nvm use 22
nvm alias default 22

# Update PATH again in case it's needed
export PATH="$NVM_DIR/versions/node/v22.*/bin:$PATH"

echo "📦 Installing @openai/codex CLI..."
npm install -g @openai/codex

echo "✅ Codex installed. Verifying..."
codex --version

# # Source all potential rc/profile files
# [ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
# [ -f "$HOME/.bash_profile" ] && source "$HOME/.bash_profile"
# [ -f "$HOME/.profile" ] && source "$HOME/.profile"
# [ -f "$HOME/.zshrc" ] && source "$HOME/.zshrc"

# Path to the lint log file
LINT_LOG="$HOME/gobeyond/lint-output.txt"

# Read lint log content
LINT_CONTENT=$(cat "$LINT_LOG")

echo "Processing Lint logs ..."
echo "$LINT_CONTENT"

codex -a auto-edit --model gpt-4.1 --fullAutoErrorMode ignore-and-continue "
You are a strict, deterministic Go linter fixer. You will directly apply changes to Go source files based on the following golangci-lint log.

## Objective:
Apply lint fixes to the actual Go codebase files, not as suggestions or examples. All changes must be made directly in-place, modifying the original files exactly where needed.

## Constraints:
- Only modify **exact files and lines** referenced in the lint log.
- Apply the **minimum code change** necessary to resolve each issue.
- **Do not** suggest fixes — directly apply them to the code.
- Do not change code outside of lines explicitly required to fix.
- Do not reformat imports unless required by a specific lint rule.
- Avoid structural rewrites unless demanded by the lint warning.
- Adhere strictly to idiomatic Go best practices and formatting.
- Do not include explanations or surrounding context — only edit the code.
- Edits must be deterministic and reproducible.
- Do not skip any errors unless marked to ignore.

## Examples:

### Example 1:
**Lint Log:**
main.go:12:2: fmt imported but not used (unused)

**Fix:**
Open `main.go`, go to line 12, and remove the unused `fmt` import.

### Example 2:
**Lint Log:**
main.go:45:6: don't use underscores in Go names; func my_function should be myFunction (revive)

**Fix:**
Rename the function `my_function` to `myFunction` on line 45 of `main.go`.

---

## 🔧 Lint log input:
$LINT_CONTENT

Now modify the source files accordingly and apply the fixes in place.
"

echo "Formatting GO code after applying changes..."  
go fmt ./...


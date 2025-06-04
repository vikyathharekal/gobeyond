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

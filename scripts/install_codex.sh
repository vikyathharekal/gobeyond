#!/bin/bash
set -e

echo "🔍 Checking for nvm..."
if [ -z "$(command -v nvm)" ]; then
  echo "📥 Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

  # Load nvm without needing a restart
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
  echo "✅ nvm already installed."
fi

echo "⬇ Installing Node.js v22 using nvm..."
nvm install 22
nvm use 22
nvm alias default 22

echo "📦 Installing @openai/codex CLI..."
npm install -g @openai/codex

echo "✅ Codex installed. Verifying..."
codex --version || echo "❌ Codex installation failed."

echo "🚀 Run 'codex --help' to get started."
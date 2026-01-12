#!/usr/bin/env bash
set -euo pipefail

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "xcodegen not found. Install it via Homebrew: brew install xcodegen"
  exit 1
fi

xcodegen generate --spec project.yml
echo "Generated BitcoinBankApp.xcodeproj"

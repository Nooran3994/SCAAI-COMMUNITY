#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# SCAAI-COMMUNITY PUSH GUARD
# Blocks any push that would carry source code, secrets, env
# files, keys, or build artifacts into this public repo.
#
# Install (one time, from repo root):
#   ln -s ../../scripts/guard.sh .git/hooks/pre-push
#   chmod +x scripts/guard.sh
#
# The hook runs on EVERY `git push` and will refuse the push
# if it finds a forbidden path or a high-confidence secret.
# ─────────────────────────────────────────────────────────────

set -u

# forbidden path patterns — any match = HARD BLOCK
FORBIDDEN_PATTERNS=(
  '(^|/)src/'
  '(^|/)main\.js$'
  '(^|/)app\.js$'
  '(^|/)index\.js$'
  '(^|/)preload\.js$'
  '(^|/)supabase'
  '\.(pem|key|p12|pfx|crt|der)$'
  '(^|/)node_modules/'
  '(^|/)release/.*\.(exe|blockmap|zip|dmg|app)$'
  '(^|/)(builder-debug\.yml|builder-effective-config\.yaml)$'
  'config\.json$'
  'service-account.*\.json$'
  'credentials.*\.json$'
  '.*\.env(\..*)?$'
  '(^|/)dist/'
  '(^|/)(build|out)/'
  '(^|/)\.scaai/'
)

# high-confidence secret patterns — any match = HARD BLOCK
SECRET_PATTERNS=(
  'sk-[A-Za-z0-9]{20,}'
  'gh[pousr]_[A-Za-z0-9]{20,}'
  'AKIA[0-9A-Z]{16}'
  'xox[baprs]-[A-Za-z0-9-]{10,}'
  'AIza[0-9A-Za-z_-]{30,}'
  '-----BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY-----'
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}'
)

BLOCKED=0

# The hook receives <local ref> <local sha> <remote ref> <remote sha> on stdin
while read local_ref local_sha remote_ref remote_sha; do
  echo "── guard.sh: scanning push ($local_ref → $remote_ref)"

  # Scan the files this push actually carries.
  # If the remote ref exists, diff it against local; else scan whole index.
  if git cat-file -e "$remote_sha"^{commit} 2>/dev/null; then
    files=$(git diff --name-only "$remote_sha".."$local_sha")
  else
    # New branch or first push from this ref — scan everything tracked + staged
    files=$(git ls-files)
  fi

  while IFS= read -r f; do
    [ -z "$f" ] && continue

    # 1) forbidden path check
    for pat in "${FORBIDDEN_PATTERNS[@]}"; do
      if echo "$f" | grep -qE "$pat"; then
        echo "❌ BLOCKED: '$f' matches forbidden pattern '$pat'"
        echo "   This repo must stay free of source, secrets, and build artifacts."
        BLOCKED=1
        break
      fi
    done

    # 2) secret content check (only for files that exist on disk)
    if [ -f "$f" ]; then
      for spat in "${SECRET_PATTERNS[@]}"; do
        if grep -qE "$spat" "$f" 2>/dev/null; then
          echo "❌ BLOCKED: '$f' contains what looks like a secret ($spat)"
          BLOCKED=1
          break
        fi
      done
    fi
  done <<< "$files"
done

if [ "$BLOCKED" -ne 0 ]; then
  echo ""
  echo "🚫 Push refused. Remove the flagged files and try again."
  echo "   If a file is legitimately needed, add it to the allowlist"
  echo "   in scripts/guard.sh — but think twice: this is a PUBLIC repo."
  exit 1
fi

echo "✅ guard.sh: no source, secrets, or artifacts found. Push OK."
exit 0
#!/bin/bash
set -e

# -------------------------
# Usage check
# -------------------------
TARGET=$1
if [[ "$TARGET" != "blue" && "$TARGET" != "green" ]]; then
  echo "Usage: ./switch.sh [blue|green]"
  exit 1
fi

# -------------------------
# Determine primary and backup hosts (use container names)
# -------------------------
if [ "$TARGET" == "blue" ]; then
  export PRIMARY_HOST="app_blue:3000"
  export BACKUP_HOST="app_green:3000"
else
  export PRIMARY_HOST="app_green:3000"
  export BACKUP_HOST="app_blue:3000"
fi

# -------------------------
# Rebuild nginx.conf from template
# -------------------------
envsubst '$PRIMARY_HOST $BACKUP_HOST' < nginx/nginx.conf.template > nginx/nginx.conf

# -------------------------
# Reload nginx
# -------------------------
docker exec nginx nginx -s reload || true

# -------------------------
# Feedback
# -------------------------
echo "✅ Switched traffic to $TARGET environment"

# -------------------------
# Verify
# -------------------------
curl -i http://localhost:8080/version

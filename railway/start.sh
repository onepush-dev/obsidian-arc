#!/bin/sh
# Starts Obsidian Arc; on the first boot only, closes public registration as the admin.
set -u
/usr/local/bin/obsidian-arc "$@" &
PID=$!
trap 'kill -TERM "$PID" 2>/dev/null' TERM INT
MARK="${OBSIDIAN_DATA_DIR:-/data}/.railway-registration-closed"
if [ "${RAILWAY_CLOSE_REGISTRATION:-true}" = "true" ] && [ ! -f "$MARK" ] && [ -n "${OBSIDIAN_ADMIN_PASSWORD:-}" ]; then
  (
    O="http://localhost:${OBSIDIAN_ADDR##*:}"
    i=0; until curl -fs "$O/api/health" >/dev/null 2>&1; do i=$((i+1)); [ $i -gt 120 ] && exit 0; sleep 1; done
    J=$(mktemp)
    body=$(printf '{"identifier":"%s","password":"%s"}' "${OBSIDIAN_ADMIN_USER:-admin}" "$OBSIDIAN_ADMIN_PASSWORD")
    if curl -fs -c "$J" -b "$J" -X POST "$O/api/auth/login" -H 'content-type: application/json' -H "Origin: $O" --data "$body" >/dev/null \
       && curl -fs -b "$J" -X PUT "$O/api/admin/settings" -H 'content-type: application/json' -H "Origin: $O" --data '{"registration.enabled":"false"}' >/dev/null; then
      touch "$MARK"; echo "railway: public registration closed on first boot (reopen it in the admin console)"
    else
      echo "railway: could not close public registration automatically; close it in the admin console" >&2
    fi
    curl -fs -b "$J" -X POST "$O/api/auth/logout" -H "Origin: $O" >/dev/null 2>&1 || true
    rm -f "$J"
  ) &
fi
wait "$PID"; status=$?
wait "$PID" 2>/dev/null; exit $status

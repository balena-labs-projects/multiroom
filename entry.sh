#!/bin/bash
set -e

# Run balena base image entrypoint script
/usr/bin/entry.sh echo ""

# Environment variables and defaults
MULTI_ROOM_MODE="${MULTI_ROOM_MODE-SERVER}"

echo "--- Multiroom ---"
echo "Starting multiroom service with settings:"
echo "- Mode: $MULTI_ROOM_MODE"
echo "- Snapcast version: $(snapclient --version | head -n 1 | cut -d' ' -f2)"

# If command starts with an option, prepend snap to it
if [[ "${1#-}" != "$1" ]]; then
  if [[ "{$MULTI_ROOM_MODE}" == "CLIENT" ]]; then
    set -- snapclient "$@"
  else
    set -- snapserver "$@"
  fi
fi

exec "$@"
#!/bin/bash
set -e

# Run balena base image entrypoint script
/usr/bin/entry.sh echo ""

# Get mode
if [[ "$@" == *"snapclient"* ]]; then
  MULTI_ROOM_MODE="client"
else
  MULTI_ROOM_MODE="server"
fi

echo "--- Multiroom ---"
echo "Starting multiroom service with settings:"
echo "- Mode: $MULTI_ROOM_MODE"
echo "- Snapcast version: $(snapserver --version | head -n 1 | cut -d' ' -f2)"

# Add defaults to client
if [[ "${MULTI_ROOM_MODE}" == "client" ]]; then

  if [[ ! "$@" == *"logfilter"* ]]; then
    set -- "$@" --logfilter=*:error
  fi

  if [[ ! "$@" == *"hostID"* ]]; then
    set -- "$@" --hostID=$BALENA_DEVICE_UUID
  fi

  if [[ ! "$@" == *"--host="* ]]; then
    set -- "$@" --host=multiroom-server
  fi

fi

# If command starts with an option, assume snapserver and prepend snap to it
if [[ "${1#-}" != "$1" ]]; then
  set -- snapserver "$@"
fi

exec "$@"
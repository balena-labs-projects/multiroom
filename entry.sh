#!/bin/bash
set -e

# Run balena base image entrypoint script
/usr/bin/entry.sh echo ""

# Get mode
case "$@" in
  *"snapclient"*)
    MULTI_ROOM_MODE="client"
    ;;

  *"snapserver"*)
    MULTI_ROOM_MODE="server"
    ;;

  *)
    MULTI_ROOM_MODE="bash"
    ;;
esac

echo "--- Multiroom ---"
echo "Starting multiroom service with settings:"
echo "- Multiroom mode: $MULTI_ROOM_MODE"
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
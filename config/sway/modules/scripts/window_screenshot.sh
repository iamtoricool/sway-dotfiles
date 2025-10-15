#!/usr/bin/env bash

# Get the geometry (x,y width×height) of the focused window, whether tiled or floating
geom=$(swaymsg -t get_tree | jq -r '
  # First, try from any focused container
  (.. | select(.focused? and .rect) | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)")
  # If that fails, try floating nodes
  // (.. | .floating_nodes?[]? | select(.focused) | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)")
')

# Debug: print geometry for verifying
echo "DEBUG: geometry = $geom" >&2

if [ -n "$geom" ]; then
  grim -g "$geom" - | satty -f -
else
  echo "Could not determine focused window geometry." >&2
  exit 1
fi

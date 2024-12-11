#!/bin/bash
if pgrep -x "wofi" >/dev/null; then
  pkill wofi
else
  wofi --show drun
fi
et
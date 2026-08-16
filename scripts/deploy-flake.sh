#!/bin/sh
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
rsync -rt --delete . /etc/nixos/
nixos-rebuild $1 ${@:2} --log-format internal-json -v |& nom --json
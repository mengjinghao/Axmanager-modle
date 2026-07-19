#!/system/bin/sh
MODDIR=${0%/*}
MODE="${1:-balanced}"
sh "$MODDIR/install.sh" "$MODE"

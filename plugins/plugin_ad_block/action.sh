#!/system/bin/sh
MODDIR=${0%/*}
MODE="${1:-light}"
sh "$MODDIR/install.sh" "$MODE"

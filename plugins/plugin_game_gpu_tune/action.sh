#!/system/bin/sh
# ============================================================
# action.sh — AXManager Action按钮执行脚本
# 默认执行均衡模式，可通过参数切换
# 用法：action.sh [performance|balance|power_saver]
# ============================================================
MODDIR=${0%/*}
MODE="${1:-balance}"
sh "$MODDIR/install.sh" "$MODE"

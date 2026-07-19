#!/system/bin/sh
# ============================================================
# CPU性能调度 — install.sh
# 用法：install.sh [performance|balanced|battery]
# CPU调速器/频率/触控升频/调度策略/温度阈值
# ============================================================
MODDIR=${0%/*}
MODE="$1"

reset_all() {
    setprop persist.cpu.governor "" 2>/dev/null
    setprop persist.cpu.freq.max "" 2>/dev/null
    setprop persist.cpu.freq.min "" 2>/dev/null
    setprop persist.cpu.boost "" 2>/dev/null
    setprop persist.cpu.touch.boost "" 2>/dev/null
    setprop persist.cpu.thermal.throttle "" 2>/dev/null
    setprop persist.cpu.cores.online "" 2>/dev/null
    settings put global cpu_governor "" 2>/dev/null
    settings put global game_driver_preference "" 2>/dev/null
}
reset_all

case "$MODE" in
performance)
    ui_print "【性能全开】最高频率，触控升频，全核在线"

    setprop persist.cpu.governor performance 2>/dev/null
    setprop persist.cpu.freq.max 99 2>/dev/null
    setprop persist.cpu.freq.min 30 2>/dev/null
    setprop persist.cpu.boost 1 2>/dev/null
    setprop persist.cpu.touch.boost 1 2>/dev/null
    setprop persist.cpu.thermal.throttle 48 2>/dev/null
    setprop persist.cpu.cores.online all 2>/dev/null

    settings put global cpu_governor performance 2>/dev/null
    settings put global game_driver_preference 1 2>/dev/null

    ui_print "性能全开：Performance调速 · 全核在线 · 触控升频 · 最高温控"
    ;;

balanced)
    ui_print "【均衡日常】交互调速，适度触控响应，标准温控"

    setprop persist.cpu.governor interactive 2>/dev/null
    setprop persist.cpu.freq.max 85 2>/dev/null
    setprop persist.cpu.freq.min 15 2>/dev/null
    setprop persist.cpu.boost 1 2>/dev/null
    setprop persist.cpu.touch.boost 1 2>/dev/null
    setprop persist.cpu.thermal.throttle 45 2>/dev/null
    setprop persist.cpu.cores.online default 2>/dev/null

    settings put global cpu_governor interactive 2>/dev/null
    settings put global game_driver_preference 0 2>/dev/null

    ui_print "均衡日常：Interactive调速 · 标准频率 · 正常温控45度C"
    ;;

battery)
    ui_print "【省电续航】降频降压，关闭升频，收紧温控"

    setprop persist.cpu.governor powersave 2>/dev/null
    setprop persist.cpu.freq.max 60 2>/dev/null
    setprop persist.cpu.freq.min 10 2>/dev/null
    setprop persist.cpu.boost 0 2>/dev/null
    setprop persist.cpu.touch.boost 0 2>/dev/null
    setprop persist.cpu.thermal.throttle 38 2>/dev/null
    setprop persist.cpu.cores.online default 2>/dev/null

    settings put global cpu_governor powersave 2>/dev/null
    settings put global game_driver_preference 0 2>/dev/null

    ui_print "省电续航：Powersave调速 · 降频60%% · 关闭升频 · 低温38度C"
    ;;

*)
    ui_print "参数错误，请选择：performance / balanced / battery"
    exit 1
    ;;
esac

ui_print "注意：CPU prop生效依赖内核支持。ADB表层修改，重启后全部失效。"

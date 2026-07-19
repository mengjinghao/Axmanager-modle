#!/system/bin/sh
# ============================================================
# GPS定位优化 — install.sh
# 用法：install.sh [high_accuracy|balanced|battery_save]
# GPS模式/更新间隔/精度/AGPS/WiFi辅助
# ============================================================
MODDIR=${0%/*}
MODE="$1"

reset_all() {
    settings put secure location_mode "" 2>/dev/null
    settings put secure location_providers_allowed "" 2>/dev/null
    setprop persist.gps.accuracy "" 2>/dev/null
    setprop persist.gps.update.interval "" 2>/dev/null
    setprop persist.gps.agps "" 2>/dev/null
    setprop persist.gps.wifi.scan "" 2>/dev/null
    settings put global wifi_scan_always_enabled "" 2>/dev/null
}
reset_all

case "$MODE" in
high_accuracy)
    ui_print "【高精度导航】GPS+WiFi+基站联合定位，最高精度"

    settings put secure location_mode 3 2>/dev/null
    settings put secure location_providers_allowed gps,network,wifi 2>/dev/null

    setprop persist.gps.accuracy high 2>/dev/null
    setprop persist.gps.update.interval 1000 2>/dev/null
    setprop persist.gps.agps 1 2>/dev/null
    setprop persist.gps.wifi.scan 1 2>/dev/null

    settings put global wifi_scan_always_enabled 1 2>/dev/null

    ui_print "高精度导航：GPS+WiFi+基站 · 1s更新 · AGPS辅助 · 最高精度"
    ;;

balanced)
    ui_print "【均衡日常】GPS+基站定位，标准精度与功耗平衡"

    settings put secure location_mode 2 2>/dev/null
    settings put secure location_providers_allowed gps,network 2>/dev/null

    setprop persist.gps.accuracy medium 2>/dev/null
    setprop persist.gps.update.interval 3000 2>/dev/null
    setprop persist.gps.agps 1 2>/dev/null
    setprop persist.gps.wifi.scan 0 2>/dev/null

    settings put global wifi_scan_always_enabled 0 2>/dev/null

    ui_print "均衡日常：GPS+基站 · 3s更新 · 标准精度 · 均衡功耗"
    ;;

battery_save)
    ui_print "【省电低功耗】仅GPS定位，最低功耗，适合后台位置记录"

    settings put secure location_mode 1 2>/dev/null
    settings put secure location_providers_allowed gps 2>/dev/null

    setprop persist.gps.accuracy low 2>/dev/null
    setprop persist.gps.update.interval 10000 2>/dev/null
    setprop persist.gps.agps 0 2>/dev/null
    setprop persist.gps.wifi.scan 0 2>/dev/null

    settings put global wifi_scan_always_enabled 0 2>/dev/null

    ui_print "省电模式：仅GPS · 10s更新 · 低精度 · 最低功耗"
    ;;

*)
    ui_print "参数错误，请选择：high_accuracy / balanced / battery_save"
    exit 1
    ;;
esac

ui_print "注意：ADB表层修改，重启后全部失效。"

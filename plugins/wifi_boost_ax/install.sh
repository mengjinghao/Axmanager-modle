#!/system/bin/sh
# ============================================================
# WiFi网络增强 — install.sh
# 用法：install.sh [gaming|daily|power_save]
# WiFi扫描/省电模式/信号阈值/TCP保活/频段策略
# ============================================================
MODDIR=${0%/*}
MODE="$1"

reset_all() {
    settings put global wifi_scan_always_enabled "" 2>/dev/null
    settings put global wifi_power_save "" 2>/dev/null
    settings put global wifi_signal_threshold "" 2>/dev/null
    settings put global wifi_idle_ms "" 2>/dev/null
    settings put global wifi_frequency_band "" 2>/dev/null
    setprop persist.wifi.keepalive "" 2>/dev/null
    setprop persist.wifi.scan.interval "" 2>/dev/null
    setprop persist.wifi.rssi.threshold "" 2>/dev/null
    setprop persist.wifi.powersave "" 2>/dev/null
}
reset_all

case "$MODE" in
gaming)
    ui_print "【极速游戏】降低延迟，连接5GHz，高频扫描"

    settings put global wifi_scan_always_enabled 0 2>/dev/null
    settings put global wifi_power_save 0 2>/dev/null
    settings put global wifi_signal_threshold -80 2>/dev/null
    settings put global wifi_idle_ms 30000 2>/dev/null
    settings put global wifi_frequency_band 2 2>/dev/null

    setprop persist.wifi.keepalive 15 2>/dev/null
    setprop persist.wifi.scan.interval 30 2>/dev/null
    setprop persist.wifi.rssi.threshold -85 2>/dev/null
    setprop persist.wifi.powersave 0 2>/dev/null

    ui_print "极速游戏：5GHz优先 · 关闭省电 · 15s心跳 · 低延迟"
    ;;

daily)
    ui_print "【均衡日常】智能频段切换，标准WiFi策略"

    settings put global wifi_scan_always_enabled 1 2>/dev/null
    settings put global wifi_power_save 1 2>/dev/null
    settings put global wifi_signal_threshold -75 2>/dev/null
    settings put global wifi_idle_ms 300000 2>/dev/null
    settings put global wifi_frequency_band 0 2>/dev/null

    setprop persist.wifi.keepalive 60 2>/dev/null
    setprop persist.wifi.scan.interval 120 2>/dev/null
    setprop persist.wifi.rssi.threshold -78 2>/dev/null
    setprop persist.wifi.powersave 1 2>/dev/null

    ui_print "均衡日常：自动频段 · 标准省电 · 120s扫描间隔"
    ;;

power_save)
    ui_print "【深度省电】关闭后台扫描，最大化WiFi省电"

    settings put global wifi_scan_always_enabled 0 2>/dev/null
    settings put global wifi_power_save 2 2>/dev/null
    settings put global wifi_signal_threshold -70 2>/dev/null
    settings put global wifi_idle_ms 600000 2>/dev/null
    settings put global wifi_frequency_band 1 2>/dev/null

    setprop persist.wifi.keepalive 120 2>/dev/null
    setprop persist.wifi.scan.interval 300 2>/dev/null
    setprop persist.wifi.rssi.threshold -72 2>/dev/null
    setprop persist.wifi.powersave 2 2>/dev/null

    ui_print "深度省电：2.4GHz优先 · 深度省电 · 关闭后台扫描"
    ;;

*)
    ui_print "参数错误，请选择：gaming / daily / power_save"
    exit 1
    ;;
esac

ui_print "注意：ADB表层修改，重启后全部失效。"

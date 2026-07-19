#!/system/bin/sh
# ============================================================
# 护眼模式增强 — install.sh
# 用法：install.sh [standard|reading|dark]
# 阅读/灰度/反转/色温/降低白点/蓝光过滤
# ============================================================
MODDIR=${0%/*}
MODE="$1"

reset_all() {
    settings put system screen_color_mode "" 2>/dev/null
    settings put system night_display_activated "" 2>/dev/null
    settings put system night_display_color_temperature "" 2>/dev/null
    settings put secure accessibility_display_inversion_enabled "" 2>/dev/null
    settings put system screen_brightness_float "" 2>/dev/null
    settings put system reduce_bright_colors_activated "" 2>/dev/null
    setprop persist.display.color.temp "" 2>/dev/null
    setprop persist.display.night_mode "" 2>/dev/null
}
reset_all

case "$MODE" in
standard)
    ui_print "【标准默认】恢复系统默认显示设置"

    settings put system night_display_activated 0 2>/dev/null
    settings put system night_display_color_temperature 3500 2>/dev/null
    settings put secure accessibility_display_inversion_enabled 0 2>/dev/null
    settings put system reduce_bright_colors_activated 0 2>/dev/null
    settings put system screen_brightness_float 1.0 2>/dev/null

    setprop persist.display.color.temp 6500 2>/dev/null
    setprop persist.display.night_mode 0 2>/dev/null

    ui_print "标准默认：6500K色温 · 无过滤 · 无反转 · 标准亮度"
    ;;

reading)
    ui_print "【沉浸阅读】暖色温+蓝光过滤，适合长时间文字阅读"

    settings put system night_display_activated 1 2>/dev/null
    settings put system night_display_color_temperature 2200 2>/dev/null
    settings put secure accessibility_display_inversion_enabled 0 2>/dev/null
    settings put system reduce_bright_colors_activated 0 2>/dev/null
    settings put system screen_brightness_float 0.7 2>/dev/null

    setprop persist.display.color.temp 4000 2>/dev/null
    setprop persist.display.night_mode 1 2>/dev/null

    ui_print "沉浸阅读：4000K暖色 · 2200K蓝光过滤 · 70%亮度 · 护眼阅读"
    ;;

dark)
    ui_print "【极暗护眼】超低亮度+色彩反转+蓝光过滤，适合暗光环境"

    settings put system night_display_activated 1 2>/dev/null
    settings put system night_display_color_temperature 1000 2>/dev/null
    settings put secure accessibility_display_inversion_enabled 1 2>/dev/null
    settings put system reduce_bright_colors_activated 1 2>/dev/null
    settings put system screen_brightness_float 0.3 2>/dev/null

    setprop persist.display.color.temp 2800 2>/dev/null
    setprop persist.display.night_mode 1 2>/dev/null

    ui_print "极暗护眼：2800K极暖 · 色彩反转 · 降低白点 · 30%亮度 · 极暗模式"
    ;;

*)
    ui_print "参数错误，请选择：standard / reading / dark"
    exit 1
    ;;
esac

ui_print "注意：ADB表层修改，重启后全部失效。"

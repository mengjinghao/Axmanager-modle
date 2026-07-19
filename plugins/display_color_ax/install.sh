#!/system/bin/sh
# ============================================================
# 屏幕色彩亮度增强 — install.sh
# 用法：install.sh [standard|vivid|eye_care]
# 修改显示色彩饱和度/色域/背光/HDR/亮度感应属性
# 适配OLED/LCD全机型，不存在的prop自动跳过
# ============================================================
MODDIR=${0%/*}
MODE="$1"

# ===== 重置全部显示属性 =====
reset_all() {
    setprop persist.display.saturation "" 2>/dev/null
    setprop persist.display.gamut "" 2>/dev/null
    setprop persist.display.backlight.curve "" 2>/dev/null
    setprop persist.display.auto_brightness "" 2>/dev/null
    setprop persist.display.hdr "" 2>/dev/null
    setprop persist.display.peak_brightness "" 2>/dev/null
    setprop persist.display.color.temp "" 2>/dev/null
    setprop persist.display.contrast "" 2>/dev/null
    setprop persist.display.night_mode "" 2>/dev/null
    setprop persist.display.brightness.floor "" 2>/dev/null
    settings put system screen_brightness_mode "" 2>/dev/null
    settings put system screen_auto_brightness_adj "" 2>/dev/null
    settings put system screen_color_mode "" 2>/dev/null
}
reset_all

case "$MODE" in
standard)
    ui_print "【标准原色】恢复系统默认色彩与亮度设置"

    setprop persist.display.saturation 1.0 2>/dev/null
    setprop persist.display.gamut srgb 2>/dev/null
    setprop persist.display.backlight.curve normal 2>/dev/null
    setprop persist.display.auto_brightness 1 2>/dev/null
    setprop persist.display.hdr 0 2>/dev/null
    setprop persist.display.peak_brightness 500 2>/dev/null
    setprop persist.display.color.temp 6500 2>/dev/null
    setprop persist.display.contrast 1.0 2>/dev/null
    setprop persist.display.night_mode 0 2>/dev/null
    setprop persist.display.brightness.floor 20 2>/dev/null

    settings put system screen_brightness_mode 1 2>/dev/null
    settings put system screen_auto_brightness_adj 0 2>/dev/null
    settings put system screen_color_mode 0 2>/dev/null

    ui_print "标准原色已生效：sRGB色域 · 6500K色温 · 标准背光曲线"
    ;;

vivid)
    ui_print "【鲜艳广色域】提升色彩饱和与对比度，开启HDR优化"

    setprop persist.display.saturation 1.3 2>/dev/null
    setprop persist.display.gamut dci_p3 2>/dev/null
    setprop persist.display.backlight.curve vivid 2>/dev/null
    setprop persist.display.auto_brightness 1 2>/dev/null
    setprop persist.display.hdr 1 2>/dev/null
    setprop persist.display.peak_brightness 700 2>/dev/null
    setprop persist.display.color.temp 6800 2>/dev/null
    setprop persist.display.contrast 1.2 2>/dev/null
    setprop persist.display.night_mode 0 2>/dev/null
    setprop persist.display.brightness.floor 15 2>/dev/null

    settings put system screen_brightness_mode 1 2>/dev/null
    settings put system screen_auto_brightness_adj 5 2>/dev/null
    settings put system screen_color_mode 1 2>/dev/null

    ui_print "鲜艳广色域已生效：DCI-P3色域 · 饱和+30% · 峰值亮度700nit"
    ;;

eye_care)
    ui_print "【护眼低亮度】降低蓝光色温，减小最低亮度，保护视力"

    setprop persist.display.saturation 0.9 2>/dev/null
    setprop persist.display.gamut srgb 2>/dev/null
    setprop persist.display.backlight.curve soft 2>/dev/null
    setprop persist.display.auto_brightness 1 2>/dev/null
    setprop persist.display.hdr 0 2>/dev/null
    setprop persist.display.peak_brightness 350 2>/dev/null
    setprop persist.display.color.temp 4500 2>/dev/null
    setprop persist.display.contrast 0.9 2>/dev/null
    setprop persist.display.night_mode 1 2>/dev/null
    setprop persist.display.brightness.floor 5 2>/dev/null

    settings put system screen_brightness_mode 1 2>/dev/null
    settings put system screen_auto_brightness_adj -5 2>/dev/null
    settings put system screen_color_mode 2 2>/dev/null

    ui_print "护眼低亮度已生效：4500K暖色温 · 最低亮度5 · 夜晚模式 · 自动感光降低"
    ;;

*)
    ui_print "参数错误，请选择：standard / vivid / eye_care"
    exit 1
    ;;
esac

ui_print "注意：ADB表层修改，重启后全部失效。OLED/LCD通用适配。"

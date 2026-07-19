#!/system/bin/sh
# ============================================================
# 屏幕色彩亮度增强 — uninstall.sh
# 清空全部显示色彩/亮度自定义属性，恢复原厂默认
# ============================================================
ui_print "正在恢复全部屏幕色彩/亮度属性到原厂默认..."

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

settings delete system screen_brightness_mode 2>/dev/null
settings delete system screen_auto_brightness_adj 2>/dev/null
settings delete system screen_color_mode 2>/dev/null

ui_print "重置完成，全部屏幕色彩亮度参数已恢复系统默认，无残留。"

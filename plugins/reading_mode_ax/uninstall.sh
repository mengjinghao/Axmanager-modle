#!/system/bin/sh
# 护眼模式增强 — uninstall.sh
ui_print "正在恢复全部护眼模式参数到原厂默认..."

settings delete system night_display_activated 2>/dev/null
settings delete system night_display_color_temperature 2>/dev/null
settings delete secure accessibility_display_inversion_enabled 2>/dev/null
settings delete system reduce_bright_colors_activated 2>/dev/null
settings delete system screen_brightness_float 2>/dev/null

setprop persist.display.color.temp "" 2>/dev/null
setprop persist.display.night_mode "" 2>/dev/null

ui_print "重置完成，全部护眼模式参数已恢复原厂默认，无残留。"

#!/system/bin/sh
# ============================================================
# 系统界面美化微调 — uninstall.sh
# 功能：恢复全部settings属性到系统默认
# ============================================================
ui_print "正在恢复系统界面全部默认参数..."

settings put global window_animation_scale 1.0 2>/dev/null
settings put global transition_animation_scale 1.0 2>/dev/null
settings put global animator_duration_scale 1.0 2>/dev/null

settings delete system screen_density 2>/dev/null
settings delete system peak_refresh_rate 2>/dev/null
settings delete system min_refresh_rate 2>/dev/null
settings delete system screen_off_refresh_rate 2>/dev/null
settings delete system status_bar_height 2>/dev/null

ui_print "重置完成，所有界面参数已恢复系统默认。建议重启使DPI/刷新率完全生效。"

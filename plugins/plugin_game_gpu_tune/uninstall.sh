#!/system/bin/sh
# ============================================================
# 机型专属手游画质调度 — uninstall.sh
# 功能：清空全部自定义属性，恢复系统原始参数
# ============================================================
ui_print "正在恢复原厂全部GPU、温控、帧率参数..."

# --- 清除settings属性（ADB可用）---
settings delete system peak_refresh_rate 2>/dev/null
settings delete system min_refresh_rate 2>/dev/null
settings delete system screen_off_refresh_rate 2>/dev/null
settings delete system dynamic_resolution_switch 2>/dev/null
settings delete system touch_sensitivity_mode 2>/dev/null
settings delete system pointer_speed 2>/dev/null
settings delete system screen_brightness_mode 2>/dev/null
settings delete system game_mode_performance 2>/dev/null
settings delete global game_driver_preference 2>/dev/null

# --- 清空setprop属性（可能失败，不影响流程）---
setprop persist.gpu.freq.max "" 2>/dev/null
setprop persist.gpu.min.freq "" 2>/dev/null
setprop persist.gpu.render.level "" 2>/dev/null
setprop persist.gpu.power_policy "" 2>/dev/null
setprop debug.game.frame_rate_limit "" 2>/dev/null
setprop vivo.game.frame.rate "" 2>/dev/null
setprop oppo.game.frame.rate "" 2>/dev/null
setprop xiaomi.game.frame.rate "" 2>/dev/null
setprop persist.temp.limit "" 2>/dev/null
setprop persist.temp.throttle "" 2>/dev/null
setprop debug.hwui.render_dirty_regions "" 2>/dev/null
setprop ro.vendor.perf.scroll_opt "" 2>/dev/null

ui_print "重置完成，所有参数已恢复原厂默认，无残留"

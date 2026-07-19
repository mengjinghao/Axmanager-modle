#!/system/bin/sh
# ============================================================
# 充电温控优化 — uninstall.sh
# 清空全部充电温控自定义属性，恢复原厂默认
# ============================================================
ui_print "正在恢复全部充电温控属性到原厂默认..."

setprop persist.chg.current.max "" 2>/dev/null
setprop persist.chg.temp.limit "" 2>/dev/null
setprop persist.batt.thermal.throttle "" 2>/dev/null
setprop persist.chg.screen_off.boost "" 2>/dev/null
setprop persist.chg.slow.charge "" 2>/dev/null
setprop persist.chg.overheat.protect "" 2>/dev/null
setprop persist.batt.health.limit "" 2>/dev/null

settings delete system charge_full_design 2>/dev/null
settings delete system battery_saver_mode 2>/dev/null
settings delete global device_idle_constants 2>/dev/null

ui_print "重置完成，全部充电温控参数已恢复原厂默认，无残留。"

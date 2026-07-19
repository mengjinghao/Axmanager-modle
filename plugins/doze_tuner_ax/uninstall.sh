#!/system/bin/sh
# 待机功耗优化 — uninstall.sh
ui_print "正在恢复全部待机功耗参数到原厂默认..."

settings delete global device_idle_constants 2>/dev/null
settings delete global app_idle_constants 2>/dev/null

setprop persist.sys.deep.sleep "" 2>/dev/null
setprop persist.sys.idle.timeout "" 2>/dev/null
setprop persist.sys.wakelock.block "" 2>/dev/null
setprop persist.sys.sensor.sleep "" 2>/dev/null

ui_print "重置完成，全部待机功耗参数已恢复原厂默认，无残留。"

#!/system/bin/sh
# GPS定位优化 — uninstall.sh
ui_print "正在恢复全部GPS定位参数到原厂默认..."

settings delete secure location_mode 2>/dev/null
settings delete secure location_providers_allowed 2>/dev/null

setprop persist.gps.accuracy "" 2>/dev/null
setprop persist.gps.update.interval "" 2>/dev/null
setprop persist.gps.agps "" 2>/dev/null
setprop persist.gps.wifi.scan "" 2>/dev/null

settings delete global wifi_scan_always_enabled 2>/dev/null

ui_print "重置完成，全部GPS定位参数已恢复原厂默认，无残留。"

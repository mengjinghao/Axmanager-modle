#!/system/bin/sh
# WiFi网络增强 — uninstall.sh
ui_print "正在恢复全部WiFi参数到原厂默认..."

settings delete global wifi_scan_always_enabled 2>/dev/null
settings delete global wifi_power_save 2>/dev/null
settings delete global wifi_signal_threshold 2>/dev/null
settings delete global wifi_idle_ms 2>/dev/null
settings delete global wifi_frequency_band 2>/dev/null

setprop persist.wifi.keepalive "" 2>/dev/null
setprop persist.wifi.scan.interval "" 2>/dev/null
setprop persist.wifi.rssi.threshold "" 2>/dev/null
setprop persist.wifi.powersave "" 2>/dev/null

ui_print "重置完成，全部WiFi参数已恢复原厂默认，无残留。"

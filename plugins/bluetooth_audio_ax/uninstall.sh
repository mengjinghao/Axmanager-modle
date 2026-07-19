#!/system/bin/sh
# 蓝牙音频增强 — uninstall.sh
ui_print "正在恢复全部蓝牙音频参数到原厂默认..."

settings delete global bluetooth_codec 2>/dev/null
settings delete global bluetooth_sample_rate 2>/dev/null
settings delete global bluetooth_bit_rate 2>/dev/null
settings delete global bluetooth_ldac_quality 2>/dev/null
settings delete global bluetooth_a2dp_latency 2>/dev/null
settings delete global bluetooth_absolute_volume 2>/dev/null

setprop persist.bluetooth.codec "" 2>/dev/null
setprop persist.bluetooth.bitpool "" 2>/dev/null
setprop persist.bluetooth.a2dp.offload "" 2>/dev/null

ui_print "重置完成，全部蓝牙音频参数已恢复原厂默认，无残留。"

#!/system/bin/sh
# 传感器性能调节 — uninstall.sh
ui_print "正在恢复全部传感器参数到原厂默认..."

setprop persist.sensor.rate.accelerometer "" 2>/dev/null
setprop persist.sensor.rate.gyroscope "" 2>/dev/null
setprop persist.sensor.rate.magnetometer "" 2>/dev/null
setprop persist.sensor.proximity.delay "" 2>/dev/null
setprop persist.sensor.light.delay "" 2>/dev/null
setprop persist.sensor.gyro.gaming "" 2>/dev/null
setprop persist.sensor.performance "" 2>/dev/null

settings delete system accelerometer_rotation 2>/dev/null

ui_print "重置完成，全部传感器参数已恢复原厂默认，无残留。"

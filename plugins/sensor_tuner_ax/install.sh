#!/system/bin/sh
# ============================================================
# 传感器性能调节 — install.sh
# 用法：install.sh [gaming|standard|power_save]
# 调节传感器采样率/行为策略
# ============================================================
MODDIR=${0%/*}
MODE="$1"

reset_all() {
    setprop persist.sensor.rate.accelerometer "" 2>/dev/null
    setprop persist.sensor.rate.gyroscope "" 2>/dev/null
    setprop persist.sensor.rate.magnetometer "" 2>/dev/null
    setprop persist.sensor.proximity.delay "" 2>/dev/null
    setprop persist.sensor.light.delay "" 2>/dev/null
    setprop persist.sensor.gyro.gaming "" 2>/dev/null
    setprop persist.sensor.performance "" 2>/dev/null
    settings put system accelerometer_rotation "" 2>/dev/null
}
reset_all

case "$MODE" in
gaming)
    ui_print "【游戏高精度】最高采样率，陀螺仪加速响应"

    setprop persist.sensor.rate.accelerometer 200 2>/dev/null
    setprop persist.sensor.rate.gyroscope 200 2>/dev/null
    setprop persist.sensor.rate.magnetometer 100 2>/dev/null
    setprop persist.sensor.proximity.delay 50 2>/dev/null
    setprop persist.sensor.light.delay 50 2>/dev/null
    setprop persist.sensor.gyro.gaming 1 2>/dev/null
    setprop persist.sensor.performance 2 2>/dev/null

    settings put system accelerometer_rotation 1 2>/dev/null

    ui_print "游戏高精度：加速度200Hz · 陀螺200Hz · 磁力100Hz · 极致响应"
    ;;

standard)
    ui_print "【标准日常】常规采样率，均衡功耗与精度"

    setprop persist.sensor.rate.accelerometer 100 2>/dev/null
    setprop persist.sensor.rate.gyroscope 100 2>/dev/null
    setprop persist.sensor.rate.magnetometer 50 2>/dev/null
    setprop persist.sensor.proximity.delay 200 2>/dev/null
    setprop persist.sensor.light.delay 200 2>/dev/null
    setprop persist.sensor.gyro.gaming 0 2>/dev/null
    setprop persist.sensor.performance 1 2>/dev/null

    settings put system accelerometer_rotation 1 2>/dev/null

    ui_print "标准日常：加速度100Hz · 陀螺100Hz · 标准功耗"
    ;;

power_save)
    ui_print "【省电低采样】降低采样频率，延长续航"

    setprop persist.sensor.rate.accelerometer 50 2>/dev/null
    setprop persist.sensor.rate.gyroscope 50 2>/dev/null
    setprop persist.sensor.rate.magnetometer 20 2>/dev/null
    setprop persist.sensor.proximity.delay 500 2>/dev/null
    setprop persist.sensor.light.delay 500 2>/dev/null
    setprop persist.sensor.gyro.gaming 0 2>/dev/null
    setprop persist.sensor.performance 0 2>/dev/null

    settings put system accelerometer_rotation 0 2>/dev/null

    ui_print "省电低采样：加速度50Hz · 陀螺50Hz · 传感器省电模式"
    ;;

*)
    ui_print "参数错误，请选择：gaming / standard / power_save"
    exit 1
    ;;
esac

ui_print "注意：传感器参数依赖厂商ROM支持，不支持的属性自动跳过。ADB表层修改，重启后全部失效。"

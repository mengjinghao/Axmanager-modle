#!/system/bin/sh
# ============================================================
# 待机功耗优化 — install.sh
# 用法：install.sh [aggressive|balanced|stock]
# Doze深度睡眠参数/待机策略/唤醒锁/传感器休眠
# ============================================================
MODDIR=${0%/*}
MODE="$1"

reset_all() {
    settings put global device_idle_constants "" 2>/dev/null
    settings put global app_idle_constants "" 2>/dev/null
    setprop persist.sys.deep.sleep "" 2>/dev/null
    setprop persist.sys.idle.timeout "" 2>/dev/null
    setprop persist.sys.wakelock.block "" 2>/dev/null
    setprop persist.sys.sensor.sleep "" 2>/dev/null
}
reset_all

case "$MODE" in
aggressive)
    ui_print "【激进省电】快速进入深度睡眠，严控唤醒锁"

    settings put global device_idle_constants "light_after_inactive_to=300000,light_pre_idle_to=600000,light_idle_to=900000,light_idle_factor=2.0,light_max_idle_to=1800000,idle_after_inactive_to=1800000,idle_pending_to=300000,max_idle_pending_to=600000,idle_pending_factor=2.0,idle_to=3600000,max_idle_to=7200000" 2>/dev/null
    settings put global app_idle_constants "key_timeout=600000,key_inactive_timeout=300000" 2>/dev/null

    setprop persist.sys.deep.sleep 1 2>/dev/null
    setprop persist.sys.idle.timeout 300 2>/dev/null
    setprop persist.sys.wakelock.block 1 2>/dev/null
    setprop persist.sys.sensor.sleep 1 2>/dev/null

    ui_print "激进省电：5分钟进Doze · 强制深度睡眠 · 严控唤醒锁 · 传感器休眠"
    ;;

balanced)
    ui_print "【均衡待机】标准Doze参数，适度省电不影响通知"

    settings put global device_idle_constants "light_after_inactive_to=600000,light_pre_idle_to=1800000,light_idle_to=3600000,light_idle_factor=2.0,light_max_idle_to=7200000,idle_after_inactive_to=3600000,idle_pending_to=600000,max_idle_pending_to=1200000,idle_pending_factor=2.0,idle_to=7200000,max_idle_to=21600000" 2>/dev/null
    settings put global app_idle_constants "key_timeout=3600000,key_inactive_timeout=1800000" 2>/dev/null

    setprop persist.sys.deep.sleep 1 2>/dev/null
    setprop persist.sys.idle.timeout 600 2>/dev/null
    setprop persist.sys.wakelock.block 1 2>/dev/null
    setprop persist.sys.sensor.sleep 0 2>/dev/null

    ui_print "均衡待机：10分钟进Doze · 标准睡眠 · 适度唤醒限制 · 保持通知"
    ;;

stock)
    ui_print "【原厂默认】恢复系统默认Doze和待机策略"

    settings put global device_idle_constants "" 2>/dev/null
    settings put global app_idle_constants "" 2>/dev/null

    setprop persist.sys.deep.sleep 0 2>/dev/null
    setprop persist.sys.idle.timeout 0 2>/dev/null
    setprop persist.sys.wakelock.block 0 2>/dev/null
    setprop persist.sys.sensor.sleep 0 2>/dev/null

    ui_print "原厂默认：系统默认Doze · 标准待机 · 所有唤醒允许"
    ;;

*)
    ui_print "参数错误，请选择：aggressive / balanced / stock"
    exit 1
    ;;
esac

ui_print "注意：device_idle为settings全局属性，重启后保持。setprop属性重启后失效。"

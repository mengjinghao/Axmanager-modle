#!/system/bin/sh
# ============================================================
# 充电温控优化 — install.sh
# 用法：install.sh [fast_charge|cool_charge|power_charge]
# 修改充电电流/电池温度阈值/过热降功率/息屏充电策略
# 所有 setprop 加 2>/dev/null 自动跳过不存在的属性
# ============================================================
MODDIR=${0%/*}
MODE="$1"

# ===== 第一步：重置全部充电温控属性 =====
reset_all() {
    setprop persist.chg.current.max "" 2>/dev/null
    setprop persist.chg.temp.limit "" 2>/dev/null
    setprop persist.batt.thermal.throttle "" 2>/dev/null
    setprop persist.chg.screen_off.boost "" 2>/dev/null
    setprop persist.chg.slow.charge "" 2>/dev/null
    setprop persist.chg.overheat.protect "" 2>/dev/null
    setprop persist.batt.health.limit "" 2>/dev/null
    settings put system charge_full_design "" 2>/dev/null
    settings put global device_idle_constants "" 2>/dev/null
}
reset_all

# ===== 第二步：通用安全优化 =====
# 开启过充保护
setprop persist.chg.overheat.protect 1 2>/dev/null
# 电池健康模式
settings put system battery_saver_mode 0 2>/dev/null

# ===== 第三步：按模式写入参数 =====
case "$MODE" in
fast_charge)
    ui_print "【快充均衡】放宽温度限制，提升充电电流上限"

    setprop persist.chg.current.max 5000 2>/dev/null
    setprop persist.chg.temp.limit 45 2>/dev/null
    setprop persist.batt.thermal.throttle 43 2>/dev/null
    setprop persist.chg.screen_off.boost 1 2>/dev/null
    setprop persist.chg.slow.charge 0 2>/dev/null
    setprop persist.batt.health.limit 40 2>/dev/null

    settings put global device_idle_constants "" 2>/dev/null

    ui_print "快充均衡已生效：5A电流上限 · 45°C高温阈值 · 息屏加速充电"
    ;;

cool_charge)
    ui_print "【低温慢充】降低充电功率，优先控制热量"

    setprop persist.chg.current.max 2500 2>/dev/null
    setprop persist.chg.temp.limit 38 2>/dev/null
    setprop persist.batt.thermal.throttle 35 2>/dev/null
    setprop persist.chg.screen_off.boost 0 2>/dev/null
    setprop persist.chg.slow.charge 1 2>/dev/null
    setprop persist.batt.health.limit 35 2>/dev/null

    settings put global device_idle_constants "" 2>/dev/null

    ui_print "低温慢充已生效：2.5A低调功率 · 38°C低温阈值 · 慢充降热"
    ;;

power_charge)
    ui_print "【极限温控省电】严格限流，最大化电池保护"

    setprop persist.chg.current.max 1500 2>/dev/null
    setprop persist.chg.temp.limit 35 2>/dev/null
    setprop persist.batt.thermal.throttle 33 2>/dev/null
    setprop persist.chg.screen_off.boost 0 2>/dev/null
    setprop persist.chg.slow.charge 1 2>/dev/null
    setprop persist.batt.health.limit 30 2>/dev/null

    # 开启Doze省电模式辅助降温
    settings put global device_idle_constants "light_after_inactive_to=300000,light_pre_idle_to=600000" 2>/dev/null

    ui_print "极限温控省电已生效：1.5A超低功耗 · 35°C极低温 · 深度省电"
    ;;

*)
    ui_print "参数错误，请选择：fast_charge / cool_charge / power_charge"
    exit 1
    ;;
esac

ui_print "注意：setprop属性为ADB表层修改，重启手机后全部失效。"

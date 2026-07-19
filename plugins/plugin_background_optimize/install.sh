#!/system/bin/sh
# ============================================================
# APP后台管控优化 — install.sh
# 功能：三档后台限制策略，批量管控自启动/唤醒/后台活动
# 用法：install.sh [aggressive|balanced|loose]
#
# 权限说明：
#   settings put — ADB权限可用 ✓
#   cmd appops — ADB权限可用 ✓
#   pm set-app-standby-bucket — ADB权限可用 ✓
#   setprop persist.sys.* — 需system级ADB，失败自动跳过
# ============================================================
MODDIR=${0%/*}
MODE="$1"

# ========== 白名单（保留后台的通讯IM类应用，按需增减）==========
WHITELIST="com.tencent.mm com.tencent.mobileqq com.tencent.wework com.alibaba.android.rimet com.eg.android.AlipayGphone"

# ========== 函数：应用后台限制 ==========
apply_restrictions() {
    LEVEL="$1"
    ALL_APPS=$(pm list packages -3 2>/dev/null | sed 's/package://')

    for pkg in $ALL_APPS; do
        [ -z "$pkg" ] && continue
        SKIP=0
        for white in $WHITELIST; do
            [ "$pkg" = "$white" ] && SKIP=1 && break
        done
        [ "$SKIP" -eq 1 ] && continue

        case "$LEVEL" in
        aggressive)
            cmd appops set "$pkg" RUN_IN_BACKGROUND deny 2>/dev/null
            cmd appops set "$pkg" WAKE_LOCK deny 2>/dev/null
            cmd appops set "$pkg" START_FOREGROUND deny 2>/dev/null
            cmd appops set "$pkg" BOOT_COMPLETED deny 2>/dev/null
            pm set-app-standby-bucket "$pkg" restricted 2>/dev/null
            ;;
        balanced)
            cmd appops set "$pkg" RUN_IN_BACKGROUND allow 2>/dev/null
            cmd appops set "$pkg" WAKE_LOCK deny 2>/dev/null
            cmd appops set "$pkg" START_FOREGROUND allow 2>/dev/null
            cmd appops set "$pkg" BOOT_COMPLETED deny 2>/dev/null
            pm set-app-standby-bucket "$pkg" working_set 2>/dev/null
            ;;
        loose)
            cmd appops set "$pkg" RUN_IN_BACKGROUND allow 2>/dev/null
            cmd appops set "$pkg" WAKE_LOCK allow 2>/dev/null
            cmd appops set "$pkg" START_FOREGROUND allow 2>/dev/null
            cmd appops set "$pkg" BOOT_COMPLETED deny 2>/dev/null
            pm set-app-standby-bucket "$pkg" active 2>/dev/null
            ;;
        esac
    done
}

# ========== 全局系统级后台策略 ==========
case "$MODE" in
aggressive)
    ui_print "【激进后台限制】重度杀后台、严控唤醒、禁止自启动"

    settings put global app_idle_constants "key_timeout=3600000,key_inactive_timeout=600000" 2>/dev/null
    settings put global activity_manager_constants "service_restart_policy=0,service_min_restart_time=1200000" 2>/dev/null
    settings put global auto_sync 0 2>/dev/null
    settings put global mobile_data_always_on 0 2>/dev/null

    # setprop需system级ADB，失败跳过
    setprop persist.sys.background_process_limit 2 2>/dev/null
    setprop persist.sys.max_cached_apps 4 2>/dev/null

    apply_restrictions aggressive
    ui_print "激进模式已生效。白名单(微信/QQ/钉钉/支付宝)已保留后台。"
    ;;

balanced)
    ui_print "【均衡管控】平衡后台保活与功耗"

    settings put global app_idle_constants "key_timeout=86400000,key_inactive_timeout=1800000" 2>/dev/null
    settings put global activity_manager_constants "service_restart_policy=1,service_min_restart_time=300000" 2>/dev/null
    settings put global auto_sync 1 2>/dev/null
    settings put global mobile_data_always_on 1 2>/dev/null

    apply_restrictions balanced
    ui_print "均衡模式已生效"
    ;;

loose)
    ui_print "【宽松原厂】接近系统默认后台策略"

    settings delete global app_idle_constants 2>/dev/null
    settings delete global activity_manager_constants 2>/dev/null
    settings put global auto_sync 1 2>/dev/null
    settings put global mobile_data_always_on 1 2>/dev/null

    setprop persist.sys.background_process_limit "" 2>/dev/null
    setprop persist.sys.max_cached_apps "" 2>/dev/null

    apply_restrictions loose
    ui_print "宽松模式已生效"
    ;;

*)
    ui_print "参数错误，请选择：aggressive / balanced / loose"
    exit 1
    ;;
esac

ui_print "白名单应用已保留后台权限不受限制。"

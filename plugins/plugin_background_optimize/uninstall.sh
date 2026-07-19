#!/system/bin/sh
# ============================================================
# APP后台管控优化 — uninstall.sh
# 功能：恢复全部后台限制为系统默认
# ============================================================
ui_print "正在恢复全部后台权限为系统默认..."

settings delete global app_idle_constants 2>/dev/null
settings delete global activity_manager_constants 2>/dev/null
settings put global auto_sync 1 2>/dev/null
settings put global mobile_data_always_on 1 2>/dev/null

setprop persist.sys.background_process_limit "" 2>/dev/null
setprop persist.sys.max_cached_apps "" 2>/dev/null

ALL_APPS=$(pm list packages -3 2>/dev/null | sed 's/package://')
for pkg in $ALL_APPS; do
    [ -z "$pkg" ] && continue
    cmd appops set "$pkg" RUN_IN_BACKGROUND default 2>/dev/null
    cmd appops set "$pkg" WAKE_LOCK default 2>/dev/null
    cmd appops set "$pkg" START_FOREGROUND default 2>/dev/null
    cmd appops set "$pkg" BOOT_COMPLETED default 2>/dev/null
    pm set-app-standby-bucket "$pkg" active 2>/dev/null
done

ui_print "重置完成，全部后台策略已恢复系统默认。建议重启手机使改动完全生效。"

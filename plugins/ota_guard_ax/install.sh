#!/system/bin/sh
# ============================================================
# OTA更新阻断守护 — install.sh
# 用法：install.sh [block_all|light|allow]
# 扫描并冻结系统OTA/更新服务，支持后台守护
# ============================================================
MODDIR=${0%/*}
MODE="$1"

# ===== 扫描所有可能的OTA/更新包名 =====
scan_ota_packages() {
    pm list packages 2>/dev/null | sed 's/package://' | grep -iE "ota|update|fota|upgrade|firmware|systemupdate|softwareupdate|miupdate|oppoupdate|vivoupdate|huaweiupdate|samsungupdate|motorolaupdate|oneplusupdate"
}

# ===== 冻结函数 =====
freeze_pkg() {
    if pm list packages 2>/dev/null | grep -q "$1"; then
        ui_print "冻结OTA服务: $1"
        pm disable-user "$1" 2>/dev/null
    fi
}

# ===== 解冻函数 =====
enable_pkg() {
    if pm list packages -d 2>/dev/null | grep -q "$1"; then
        ui_print "解冻OTA服务: $1"
        pm enable "$1" 2>/dev/null
    fi
}

# ===== 通用阻断：停用系统更新触发器 =====
settings put global ota_disable_automatic_update 1 2>/dev/null
settings put system ota_disable_automatic_update 1 2>/dev/null
setprop persist.sys.ota.disable 1 2>/dev/null

case "$MODE" in
block_all)
    ui_print "【全面阻断】扫描并冻结全部OTA/更新组件"

    OTA_LIST=$(scan_ota_packages)
    COUNT=0
    for pkg in $OTA_LIST; do
        [ -z "$pkg" ] && continue
        freeze_pkg "$pkg"
        COUNT=$((COUNT + 1))
    done

    # 额外禁用开发者选项中的自动更新
    settings put global automatic_system_update 0 2>/dev/null

    ui_print "全面阻断完成：已冻结 ${COUNT} 个OTA服务"
    ;;

light)
    ui_print "【轻度拦截】仅冻结静默后台升级组件"

    # 仅冻结明确的后台静默升级包
    for pkg in com.miui.systemAdSolution com.xiaomi.discover com.oppo.ota com.bbk.updater com.huawei.android.hwouc com.samsung.sdm com.samsung.sdm.sdmviewer; do
        freeze_pkg "$pkg"
    done

    ui_print "轻度拦截完成：仅冻结核心静默升级组件"
    ;;

allow)
    ui_print "【临时放行】解冻全部OTA组件"

    ALL_DISABLED=$(pm list packages -d 2>/dev/null | sed 's/package://' | grep -iE "ota|update|fota|upgrade")
    for pkg in $ALL_DISABLED; do
        [ -z "$pkg" ] && continue
        enable_pkg "$pkg"
    done

    settings put global automatic_system_update 1 2>/dev/null

    ui_print "临时放行：全部OTA组件已解冻，系统更新可正常进行"
    ;;

*)
    ui_print "参数错误，请选择：block_all / light / allow"
    exit 1
    ;;
esac

ui_print "注意：OTA阻断基于pm disable-user，重启后保持冻结状态。如需彻底清除请使用uninstall.sh。"

#!/system/bin/sh
# ============================================================
# 开机自启管理 — install.sh
# 用法：install.sh [aggressive|smart|all_open]
# 组件级禁止/允许 BOOT_COMPLETED 接收器
# ============================================================
MODDIR=${0%/*}
MODE="$1"

# ===== 白名单（保留自启的通讯IM应用）=====
WHITELIST="com.tencent.mm com.tencent.mobileqq com.tencent.wework com.alibaba.android.rimet com.eg.android.AlipayGphone com.android.phone com.android.contacts com.google.android.dialer"

is_whitelisted() {
    for w in $WHITELIST; do
        [ "$1" = "$w" ] && return 0
    done
    return 1
}

# ===== 禁止开机自启 =====
disable_boot() {
    PKG="$1"
    # 获取该包的所有 BOOT_COMPLETED 接收器
    RECEIVERS=$(cmd package query-receivers -a android.intent.action.BOOT_COMPLETED "$PKG" 2>/dev/null | grep "receiver" | awk '{print $NF}')
    if [ -n "$RECEIVERS" ]; then
        for rec in $RECEIVERS; do
            [ -z "$rec" ] && continue
            # 组件级禁用接收器
            pm disable "$PKG/$rec" 2>/dev/null
        done
    fi
    # 额外禁止自启动权限
    cmd appops set "$PKG" BOOT_COMPLETED deny 2>/dev/null
}

# ===== 允许开机自启 =====
enable_boot() {
    PKG="$1"
    # 启用所有被禁用的接收器
    DISABLED=$(pm list packages -d 2>/dev/null | sed 's/package://')
    # 仅恢复组件级禁用
    cmd appops set "$PKG" BOOT_COMPLETED allow 2>/dev/null
}

case "$MODE" in
aggressive)
    ui_print "【激进控制】仅允许系统核心+通讯白名单开机自启"

    ALL_APPS=$(pm list packages -3 2>/dev/null | sed 's/package://')
    for pkg in $ALL_APPS; do
        [ -z "$pkg" ] && continue
        if is_whitelisted "$pkg"; then continue; fi
        disable_boot "$pkg"
    done

    ui_print "激进控制完成：白名单(微信/QQ/钉钉/支付宝)保留自启，其余全部禁止。"
    ;;

smart)
    ui_print "【智能管理】仅禁止非必要应用开机自启"

    # 禁止明显非必要的开机自启应用
    for pkg in $(pm list packages -3 2>/dev/null | sed 's/package://'); do
        [ -z "$pkg" ] && continue
        # 跳过系统包
        if pm list packages -s 2>/dev/null | grep -q "$pkg"; then continue; fi
        if is_whitelisted "$pkg"; then continue; fi
        # 仅禁止游戏/娱乐/工具类自启
        if echo "$pkg" | grep -qiE "game|shop|video|music|browser|news|reader|tool|clean|camera|photo|weather|map"; then
            disable_boot "$pkg"
        fi
    done

    ui_print "智能管理完成：仅禁止游戏/娱乐/工具类应用自启。"
    ;;

all_open)
    ui_print "【全部放行】允许所有应用开机自启"

    ALL_APPS=$(pm list packages -3 2>/dev/null | sed 's/package://')
    for pkg in $ALL_APPS; do
        [ -z "$pkg" ] && continue
        enable_boot "$pkg"
    done

    ui_print "全部放行完成：所有应用已恢复自启权限。"
    ;;

*)
    ui_print "参数错误，请选择：aggressive / smart / all_open"
    exit 1
    ;;
esac

ui_print "注意：组件级禁用基于pm命令，重启后保持。卸载脚本将恢复全部自启权限。"

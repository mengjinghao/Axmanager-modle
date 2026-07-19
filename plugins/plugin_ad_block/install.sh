#!/system/bin/sh
# ============================================================
# 全局表层广告屏蔽 — install.sh
# 功能：三档ADB表层广告屏蔽策略
# 用法：install.sh [strong|light|default]
#
# 重要限制：
#   - 仅ADB表层操作（pm disable-user + settings put）
#   - 无root无法写/system/hosts，不提供hosts域名拦截
#   - 重启后效果重置，需重新执行
#   - pm enable可完全恢复，无残留
# ============================================================
MODDIR=${0%/*}
MODE="$1"

# ========== 系统广告服务包名列表（按需增减） ==========
# --- 小米广告组件 ---
MI_AD="com.miui.msa.global com.miui.analytics com.xiaomi.ab com.miui.systemAdSolution"
# --- OPPO广告组件 ---
OPPO_AD="com.coloros.adservices com.heytap.adx com.oplus.ads com.opos.ads"
# --- vivo广告组件 ---
VIVO_AD="com.vivo.unionservice com.vivo.adsdk com.vivo.daemonService"
# --- 华为广告组件 ---
HUAWEI_AD="com.huawei.hms.ads com.huawei.hwid com.huawei.android.hsf"
# --- 三星广告组件 ---
SAMSUNG_AD="com.samsung.android.samsungad com.samsung.android.bixby.agent"
# --- 通用广告/推送 ---
COMMON_AD="com.google.android.gms.ads com.facebook.adsmanager com.facebook.appmanager com.facebook.system"

# ========== 函数：冻结广告服务 ==========
freeze_ad() {
    for pkg in $1; do
        [ -z "$pkg" ] && continue
        if pm list packages 2>/dev/null | grep -q "$pkg"; then
            ui_print "冻结广告: $pkg"
            pm disable-user "$pkg" 2>/dev/null
        fi
    done
}

# ========== 函数：解冻广告服务 ==========
enable_ad() {
    for pkg in $1; do
        [ -z "$pkg" ] && continue
        if pm list packages -d 2>/dev/null | grep -q "$pkg"; then
            ui_print "解冻广告: $pkg"
            pm enable "$pkg" 2>/dev/null
        fi
    done
}

# ========== 函数：关闭个性化推荐 ==========
disable_personalized() {
    settings put secure limit_ad_tracking 1 2>/dev/null
    settings put global adb_enabled 0 2>/dev/null
}
enable_personalized() {
    settings put secure limit_ad_tracking 0 2>/dev/null
    settings put global adb_enabled 1 2>/dev/null
}

# ========== 执行模式 ==========
case "$MODE" in
strong)
    ui_print "【强效屏蔽】冻结全部厂商广告组件 + 关闭个性化推荐"
    freeze_ad "$MI_AD $OPPO_AD $VIVO_AD $HUAWEI_AD $SAMSUNG_AD $COMMON_AD"
    disable_personalized
    ui_print "强效屏蔽完成。注意：仅表层ADB拦截，重启后失效需重新执行。"
    ;;

light)
    ui_print "【轻度屏蔽】仅冻结厂商推送广告 + 关闭个性化推荐"
    freeze_ad "$MI_AD $OPPO_AD $VIVO_AD $HUAWEI_AD $SAMSUNG_AD"
    disable_personalized
    ui_print "轻度屏蔽完成。"
    ;;

default)
    ui_print "【原厂无屏蔽】解冻全部广告组件 + 恢复个性化推荐"
    enable_ad "$MI_AD $OPPO_AD $VIVO_AD $HUAWEI_AD $SAMSUNG_AD $COMMON_AD"
    enable_personalized
    ui_print "原厂已恢复：全部广告组件已启用。"
    ;;

*)
    ui_print "参数错误，请选择：strong / light / default"
    exit 1
    ;;
esac

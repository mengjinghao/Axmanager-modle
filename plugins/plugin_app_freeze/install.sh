#!/system/bin/sh
# ============================================================
# 厂商预装冻结精简 — install.sh
# 功能：三档批量冻结/解冻厂商预装应用
# 用法：install.sh [deep|light|default]
# 使用pm disable-user冻结，pm enable恢复，ADB权限可用 ✓
# ============================================================
MODDIR=${0%/*}
MODE="$1"

# ========== 包名列表（按需增减）==========
# 小米
MI_PKGS="com.miui.analytics com.miui.msa.global com.miui.cloudservice com.miui.cloudbackup com.miui.hybrid com.miui.yellowpage com.miui.virtualsim com.xiaomi.miplay_client com.miui.player com.miui.notes com.miui.gallery com.miui.weather2 com.xiaomi.shop com.miui.video com.xiaomi.mirecycle com.miui.miservice com.miui.daemon com.xiaomi.payment com.miui.cleanmaster com.miui.touchassistant"
# OPPO/一加
OPPO_PKGS="com.coloros.assistantscreen com.coloros.smartsidebar com.oppo.market com.heytap.cloud com.heytap.market com.heytap.browser com.heytap.music com.heytap.themestore com.heytap.usercenter com.coloros.video com.coloros.weather.service"
# vivo
VIVO_PKGS="com.vivo.assistant com.vivo.smartlife com.vivo.globalsearch com.vivo.health com.bbk.cloud com.vivo.browser com.vivo.weather com.vivo.email com.vivo.game com.vivo.appstore com.vivo.videoeditor"
# 华为
HUAWEI_PKGS="com.huawei.appmarket com.huawei.himovie com.huawei.hitouch com.huawei.hwireader com.huawei.gamebox com.huawei.search com.huawei.hicare com.huawei.wallet com.huawei.hicloud"
# 三星
SAMSUNG_PKGS="com.samsung.android.bixby.agent com.samsung.android.spay com.samsung.android.voc com.samsung.android.scloud com.samsung.android.app.social"
# 运营商/通用
CARRIER_PKGS="com.android.browser com.android.email com.google.android.apps.maps com.google.android.apps.photos com.google.android.youtube com.google.android.videos com.google.android.music com.android.chrome com.facebook.katana"
# 广告/推送
AD_PKGS="com.miui.msa.global com.coloros.adservices com.heytap.adx com.oplus.ads com.huawei.hms.ads com.google.android.gms.ads com.facebook.adsmanager"

# ========== 冻结函数 ==========
freeze_pkgs() {
    for pkg in $1; do
        [ -z "$pkg" ] && continue
        if pm list packages 2>/dev/null | grep -q "$pkg"; then
            ui_print "冻结: $pkg"
            pm disable-user "$pkg" 2>/dev/null
        fi
    done
}

# ========== 解冻全部 ==========
unfreeze_all() {
    PACKAGES=$(pm list packages -d 2>/dev/null | sed 's/package://')
    for pkg in $PACKAGES; do
        [ -z "$pkg" ] && continue
        ui_print "解冻: $pkg"
        pm enable "$pkg" 2>/dev/null
    done
}

# ========== 执行模式 ==========
case "$MODE" in
deep)
    ui_print "【深度精简】冻结全部厂商+运营商+广告组件"
    freeze_pkgs "$MI_PKGS $OPPO_PKGS $VIVO_PKGS $HUAWEI_PKGS $SAMSUNG_PKGS $CARRIER_PKGS $AD_PKGS"
    ui_print "深度精简完成"
    ;;
light)
    ui_print "【轻度精简】仅冻结广告推送+运营商冗余"
    freeze_pkgs "$AD_PKGS $CARRIER_PKGS"
    ui_print "轻度精简完成"
    ;;
default)
    ui_print "【原厂默认】解冻全部已冻结应用"
    unfreeze_all
    ui_print "原厂默认已恢复"
    ;;
*)
    ui_print "参数错误，请选择：deep / light / default"
    exit 1
    ;;
esac

ui_print "操作完成。pm disable-user冻结，数据保留可随时解冻。"

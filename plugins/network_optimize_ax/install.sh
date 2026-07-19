#!/system/bin/sh
# ============================================================
# 网络优化工具 — install.sh
# 用法：install.sh [gaming|balanced|power_save]
# 优化TCP/网络延迟/5G策略/后台扫描/网络收集服务
# ============================================================
MODDIR=${0%/*}
MODE="$1"

# ===== 重置全部网络属性 =====
reset_all() {
    setprop persist.net.tcp.buffers "" 2>/dev/null
    setprop persist.net.dns.optimize "" 2>/dev/null
    setprop persist.net.keepalive "" 2>/dev/null
    setprop persist.net.low.latency "" 2>/dev/null
    setprop persist.radio.5g.force "" 2>/dev/null
    setprop persist.radio.network.scan "" 2>/dev/null
    settings put global mobile_data_always_on "" 2>/dev/null
    settings put global wifi_scan_always_enabled "" 2>/dev/null
    settings put global network_recommendations_enabled "" 2>/dev/null
    settings put global captive_portal_detection_enabled "" 2>/dev/null
    settings put global tether_default_enabled "" 2>/dev/null
}
reset_all

# ===== 停止厂商网络收集服务 =====
for pkg in com.qualcomm.qti.qms.service.connectionsecurity com.qualcomm.qti.confdialer; do
    pm disable-user "$pkg" 2>/dev/null
done

case "$MODE" in
gaming)
    ui_print "【极速低延迟】优化TCP缓冲，降低网络延迟，驻留5G"

    # TCP 缓冲参数优化（低延迟）
    setprop persist.net.tcp.buffers optimized 2>/dev/null
    setprop persist.net.dns.optimize 1 2>/dev/null
    setprop persist.net.keepalive 30 2>/dev/null
    setprop persist.net.low.latency 1 2>/dev/null

    # 强制5G驻留
    setprop persist.radio.5g.force 1 2>/dev/null

    # 关闭后台冗余网络扫描
    setprop persist.radio.network.scan 0 2>/dev/null

    # 始终连接移动数据
    settings put global mobile_data_always_on 1 2>/dev/null
    settings put global wifi_scan_always_enabled 0 2>/dev/null
    settings put global network_recommendations_enabled 0 2>/dev/null
    settings put global captive_portal_detection_enabled 0 2>/dev/null
    settings put global tether_default_enabled 0 2>/dev/null

    ui_print "极速低延迟已生效：TCP优化 · DNS加速 · 5G驻留 · 关闭后台扫描"
    ;;

balanced)
    ui_print "【均衡省电】标准TCP，智能网络切换，常规省电"

    setprop persist.net.tcp.buffers default 2>/dev/null
    setprop persist.net.dns.optimize 0 2>/dev/null
    setprop persist.net.keepalive 60 2>/dev/null
    setprop persist.net.low.latency 0 2>/dev/null

    setprop persist.radio.5g.force 0 2>/dev/null
    setprop persist.radio.network.scan 1 2>/dev/null

    settings put global mobile_data_always_on 1 2>/dev/null
    settings put global wifi_scan_always_enabled 1 2>/dev/null
    settings put global network_recommendations_enabled 0 2>/dev/null
    settings put global captive_portal_detection_enabled 0 2>/dev/null
    settings put global tether_default_enabled 0 2>/dev/null

    ui_print "均衡省电已生效：标准TCP · 智能4G/5G · 常规省电"
    ;;

power_save)
    ui_print "【纯4G省电】关闭5G，最大化省电，降低数据消耗"

    setprop persist.net.tcp.buffers default 2>/dev/null
    setprop persist.net.dns.optimize 0 2>/dev/null
    setprop persist.net.keepalive 120 2>/dev/null
    setprop persist.net.low.latency 0 2>/dev/null

    # 强制关闭5G
    setprop persist.radio.5g.force -1 2>/dev/null
    setprop persist.radio.network.scan 0 2>/dev/null

    # WiFi常驻策略
    settings put global mobile_data_always_on 0 2>/dev/null
    settings put global wifi_scan_always_enabled 1 2>/dev/null
    settings put global network_recommendations_enabled 0 2>/dev/null
    settings put global captive_portal_detection_enabled 0 2>/dev/null
    settings put global tether_default_enabled 0 2>/dev/null

    ui_print "纯4G省电已生效：关闭5G · 移动数据WiFi常驻 · 低功耗策略"
    ;;

*)
    ui_print "参数错误，请选择：gaming / balanced / power_save"
    exit 1
    ;;
esac

ui_print "注意：ADB表层修改，重启后全部失效。"

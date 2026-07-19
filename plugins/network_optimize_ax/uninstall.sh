#!/system/bin/sh
# ============================================================
# 网络优化工具 — uninstall.sh
# 清空全部网络自定义属性，恢复系统默认
# ============================================================
ui_print "正在恢复全部网络属性到原厂默认..."

setprop persist.net.tcp.buffers "" 2>/dev/null
setprop persist.net.dns.optimize "" 2>/dev/null
setprop persist.net.keepalive "" 2>/dev/null
setprop persist.net.low.latency "" 2>/dev/null
setprop persist.radio.5g.force "" 2>/dev/null
setprop persist.radio.network.scan "" 2>/dev/null

settings delete global mobile_data_always_on 2>/dev/null
settings delete global wifi_scan_always_enabled 2>/dev/null
settings delete global network_recommendations_enabled 2>/dev/null
settings delete global captive_portal_detection_enabled 2>/dev/null
settings delete global tether_default_enabled 2>/dev/null

# 重新启用被停用的网络服务
for pkg in com.qualcomm.qti.qms.service.connectionsecurity com.qualcomm.qti.confdialer; do
    pm enable "$pkg" 2>/dev/null
done

ui_print "重置完成，全部网络参数已恢复系统默认，网络服务已重新启用。"

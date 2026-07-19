#!/system/bin/sh
# ============================================================
# HTTP代理快速切换 — install.sh
# 用法：install.sh [capture|office|direct]
# 全局HTTP/HTTPS代理设置/测试/排除列表
# ============================================================
MODDIR=${0%/*}
MODE="$1"

reset_all() {
    settings put global http_proxy :0 2>/dev/null
    settings delete global global_http_proxy_host 2>/dev/null
    settings delete global global_http_proxy_port 2>/dev/null
    settings delete global global_http_proxy_exclusion_list 2>/dev/null
    settings delete global global_http_proxy_pac 2>/dev/null
}
reset_all

case "$MODE" in
capture)
    ui_print "【抓包代理】127.0.0.1:8080 — mitmproxy/Charles/Fiddler"

    settings put global http_proxy 127.0.0.1:8080 2>/dev/null
    settings put global global_http_proxy_host 127.0.0.1 2>/dev/null
    settings put global global_http_proxy_port 8080 2>/dev/null
    settings put global global_http_proxy_exclusion_list "localhost,127.0.0.1,::1" 2>/dev/null

    ui_print "抓包代理已启用：127.0.0.1:8080 · 排除localhost · 适合抓包调试"
    ;;

office)
    ui_print "【公司网络】10.0.0.1:8888 — 企业代理"

    settings put global http_proxy 10.0.0.1:8888 2>/dev/null
    settings put global global_http_proxy_host 10.0.0.1 2>/dev/null
    settings put global global_http_proxy_port 8888 2>/dev/null
    settings put global global_http_proxy_exclusion_list "*.local,*.internal,192.168.*" 2>/dev/null

    ui_print "公司代理已启用：10.0.0.1:8888 · 排除内网 · 适合企业网络"
    ;;

direct)
    ui_print "【直连模式】清除代理设置，直接连接"

    settings put global http_proxy :0 2>/dev/null
    settings delete global global_http_proxy_host 2>/dev/null
    settings delete global global_http_proxy_port 2>/dev/null
    settings delete global global_http_proxy_exclusion_list 2>/dev/null

    ui_print "直连模式：已清除全部代理设置，直接上网。"
    ;;

*)
    ui_print "参数错误，请选择：capture / office / direct"
    exit 1
    ;;
esac

ui_print "注意：仅设置全局HTTP代理，部分应用可能不遵守系统代理设置。"

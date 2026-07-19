#!/system/bin/sh
# HTTP代理快速切换 — uninstall.sh
ui_print "正在清除全部HTTP代理设置..."

settings put global http_proxy :0 2>/dev/null
settings delete global global_http_proxy_host 2>/dev/null
settings delete global global_http_proxy_port 2>/dev/null
settings delete global global_http_proxy_exclusion_list 2>/dev/null
settings delete global global_http_proxy_pac 2>/dev/null

ui_print "重置完成，全部代理设置已清除，恢复直连。"

#!/system/bin/sh
# OTA更新阻断守护 — uninstall.sh
ui_print "正在解冻全部OTA更新服务，恢复系统更新..."

ALL_DISABLED=$(pm list packages -d 2>/dev/null | sed 's/package://' | grep -iE "ota|update|fota|upgrade")
COUNT=0
for pkg in $ALL_DISABLED; do
    [ -z "$pkg" ] && continue
    ui_print "启用: $pkg"
    pm enable "$pkg" 2>/dev/null
    COUNT=$((COUNT + 1))
done

settings delete global ota_disable_automatic_update 2>/dev/null
settings delete system ota_disable_automatic_update 2>/dev/null
settings delete global automatic_system_update 2>/dev/null
setprop persist.sys.ota.disable "" 2>/dev/null

if [ "$COUNT" -gt 0 ]; then
    ui_print "已启用 ${COUNT} 个OTA服务"
else
    ui_print "无需要解冻的OTA服务"
fi

ui_print "重置完成，系统更新功能已恢复正常。"

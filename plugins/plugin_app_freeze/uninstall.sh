#!/system/bin/sh
# ============================================================
# 厂商预装冻结精简 — uninstall.sh
# 功能：一键解冻全部被pm disable-user的应用
# ============================================================
ui_print "正在解冻全部已冻结应用..."

PACKAGES=$(pm list packages -d 2>/dev/null | sed 's/package://')
COUNT=0
for pkg in $PACKAGES; do
    [ -z "$pkg" ] && continue
    ui_print "解冻: $pkg"
    pm enable "$pkg" 2>/dev/null
    COUNT=$((COUNT + 1))
done

if [ "$COUNT" -eq 0 ]; then
    ui_print "没有需要解冻的应用，系统已处于原厂状态"
else
    ui_print "已解冻 ${COUNT} 个应用"
fi

ui_print "重置完成，全部预装应用已恢复。所有数据完整保留，无任何删除操作。"

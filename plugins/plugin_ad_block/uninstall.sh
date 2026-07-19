#!/system/bin/sh
# ============================================================
# 全局表层广告屏蔽 — uninstall.sh
# 功能：启用全部广告组件 + 恢复个性化推荐
# ============================================================
ui_print "正在恢复全部广告组件和个性化推荐..."

# 解冻全部被冻结的应用
ALL_DISABLED=$(pm list packages -d 2>/dev/null | sed 's/package://')
COUNT=0
for pkg in $ALL_DISABLED; do
    [ -z "$pkg" ] && continue
    ui_print "启用: $pkg"
    pm enable "$pkg" 2>/dev/null
    COUNT=$((COUNT + 1))
done

if [ "$COUNT" -gt 0 ]; then
    ui_print "已启用 ${COUNT} 个组件"
fi

# 恢复个性化推荐
settings put secure limit_ad_tracking 0 2>/dev/null
settings put global adb_enabled 1 2>/dev/null

ui_print "重置完成，全部广告组件已启用，个性化推荐已恢复。"

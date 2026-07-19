#!/system/bin/sh
# 开机自启管理 — uninstall.sh
ui_print "正在恢复全部应用开机自启权限..."

# 恢复所有应用的 BOOT_COMPLETED 权限
ALL_APPS=$(pm list packages -3 2>/dev/null | sed 's/package://')
for pkg in $ALL_APPS; do
    [ -z "$pkg" ] && continue
    cmd appops set "$pkg" BOOT_COMPLETED allow 2>/dev/null
done

# 尝试启用所有被禁用的组件
ALL_DISABLED=$(pm list packages -d 2>/dev/null | sed 's/package://')
for pkg in $ALL_DISABLED; do
    [ -z "$pkg" ] && continue
    pm enable "$pkg" 2>/dev/null
done

ui_print "重置完成，全部应用开机自启权限已恢复。"

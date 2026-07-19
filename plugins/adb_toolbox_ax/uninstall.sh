#!/system/bin/sh
# ADB快捷工具箱 — uninstall.sh
pkill screenrecord 2>/dev/null
settings delete system screen_density 2>/dev/null
rm -f /sdcard/ax_toolbox_*.png /sdcard/ax_recording.mp4 2>/dev/null

# 恢复后台权限
ALL_APPS=$(pm list packages -3 2>/dev/null | sed 's/package://')
for pkg in $ALL_APPS; do
    [ -z "$pkg" ] && continue
    cmd appops set "$pkg" RUN_IN_BACKGROUND default 2>/dev/null
done

ui_print "ADB工具箱已卸载：DPI恢复默认、停止录屏、恢复后台权限、清理临时文件。"

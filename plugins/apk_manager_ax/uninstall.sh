#!/system/bin/sh
# APK管理与权限审计 — uninstall.sh
ui_print "正在清理提取的APK文件..."
rm -rf /sdcard/AxAPKs 2>/dev/null
ui_print "插件已卸载，APK文件已清理。"

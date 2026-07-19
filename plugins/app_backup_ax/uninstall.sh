#!/system/bin/sh
# 应用数据备份迁移 — uninstall.sh
ui_print "正在清理备份文件..."
rm -rf /sdcard/AxBackup 2>/dev/null
ui_print "插件已卸载，备份文件已清理。"

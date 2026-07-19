#!/system/bin/sh
# Logcat日志工具箱 — uninstall.sh
ui_print "正在清理日志导出文件..."
rm -rf /sdcard/AxDiagnose_* 2>/dev/null
rm -f /sdcard/logcat_*.txt 2>/dev/null
ui_print "插件已卸载，诊断文件已清理。"

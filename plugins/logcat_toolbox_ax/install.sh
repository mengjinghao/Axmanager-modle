#!/system/bin/sh
# ============================================================
# Logcat日志工具箱 — install.sh
# 用法：install.sh [live|crash|export|clear|dump]
# 实时日志/崩溃过滤/导出/清理/dumpsys诊断
# ============================================================
MODDIR=${0%/*}
CMD="$1"

case "$CMD" in
live)
    # 实时日志（仅显示最近100条）
    logcat -t 100 2>/dev/null
    ;;
crash)
    # 过滤崩溃/异常/ANR
    ui_print "=== 崩溃与异常日志 ==="
    logcat -d -s AndroidRuntime:E 2>/dev/null | head -30
    echo ""
    echo "=== ANR (应用无响应) ==="
    logcat -d -b events 2>/dev/null | grep -i "anr" | head -15
    echo ""
    echo "=== 严重错误 ==="
    logcat -d '*:E' 2>/dev/null | head -20
    ;;
battery)
    # 电池相关日志
    ui_print "=== 电池状态 ==="
    dumpsys battery 2>/dev/null
    echo ""
    echo "=== 充电历史 ==="
    dumpsys batterystats --charged 2>/dev/null | head -20
    ;;
network_log)
    # 网络相关日志
    ui_print "=== 网络连接日志 ==="
    logcat -d -s ConnectivityService:* 2>/dev/null | head -30
    echo ""
    echo "=== WiFi日志 ==="
    logcat -d -s WifiService:* 2>/dev/null | head -20
    ;;
export)
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    FILE="/sdcard/logcat_${TIMESTAMP}.txt"
    logcat -d > "$FILE" 2>/dev/null && echo "日志已导出: $FILE" || echo "导出失败"
    du -sh "$FILE" 2>/dev/null
    ;;
clear)
    logcat -c 2>/dev/null && ui_print "日志缓冲区已清空" || ui_print "清理失败"
    ;;
dump)
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    DIR="/sdcard/AxDiagnose_${TIMESTAMP}"
    mkdir -p "$DIR" 2>/dev/null

    ui_print "正在导出诊断包..."
    dumpsys battery > "$DIR/battery.txt" 2>/dev/null
    dumpsys meminfo > "$DIR/meminfo.txt" 2>/dev/null
    dumpsys cpuinfo > "$DIR/cpuinfo.txt" 2>/dev/null
    dumpsys connectivity > "$DIR/connectivity.txt" 2>/dev/null
    dumpsys package > "$DIR/packages.txt" 2>/dev/null
    logcat -d > "$DIR/logcat.txt" 2>/dev/null
    df -h > "$DIR/disk.txt" 2>/dev/null

    ui_print "诊断包已导出到: $DIR"
    du -sh "$DIR" 2>/dev/null
    ;;

*)
    echo "用法: install.sh [live|crash|battery|network_log|export|clear|dump]"
    exit 1
    ;;
esac

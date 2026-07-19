#!/system/bin/sh
# ============================================================
# 进程与后台守护 — install.sh
# 用法：install.sh [top|kill <pkg>|killall_bg|info <pkg>]
# 进程查看/结束/守护/信息
# ============================================================
MODDIR=${0%/*}
CMD="$1"
ARG="$2"

case "$CMD" in
top)
    ui_print "=== TOP 进程 (CPU/内存占用) ==="
    ps -eo PID,USER,%CPU,%MEM,ARGS --sort=-%CPU 2>/dev/null | head -20 || ps -A -o PID,USER,%CPU,%MEM,ARGS 2>/dev/null | head -20
    ;;
kill)
    [ -z "$ARG" ] && { echo "用法: install.sh kill <包名>"; exit 1; }
    am force-stop "$ARG" 2>/dev/null && ui_print "已结束: $ARG" || ui_print "结束失败: $ARG"
    ;;
killall_bg)
    ui_print "正在结束所有后台进程..."
    COUNT=0
    ALL_APPS=$(ps -A -o PID,ARGS 2>/dev/null | grep -v "PID" | awk '{print $1}')
    for pid in $ALL_APPS; do
        [ -z "$pid" ] && continue
        PROC=$(ps -A -o PID,NAME 2>/dev/null | grep "^$pid " | awk '{print $2}')
        [ -z "$PROC" ] && continue
        [ "$PROC" = "system_server" ] && continue
        [ "$PROC" = "zygote" ] && continue
        kill "$pid" 2>/dev/null && COUNT=$((COUNT + 1))
    done
    ui_print "已结束 ${COUNT} 个后台进程"
    ;;
info)
    [ -z "$ARG" ] && { echo "用法: install.sh info <包名>"; exit 1; }
    ui_print "=== 进程信息: $ARG ==="
    PID=$(pidof "$ARG" 2>/dev/null | awk '{print $1}')
    if [ -n "$PID" ]; then
        echo "PID: $PID"
        echo "进程名: $(ps -A -o PID,NAME 2>/dev/null | grep "^$PID " | awk '{print $2}')"
        cat /proc/"$PID"/status 2>/dev/null | grep -E "Name|State|VmSize|VmRSS|Threads" | head -6
        echo ""
        echo "OOM Score: $(cat /proc/"$PID"/oom_score 2>/dev/null)"
    else
        ui_print "进程未运行: $ARG"
    fi
    ;;
meminfo)
    ui_print "=== 内存使用 TOP 10 ==="
    dumpsys meminfo 2>/dev/null | grep "kB:" | head -10
    ;;
*)
    echo "用法: install.sh [top|kill <pkg>|killall_bg|info <pkg>|meminfo]"
    exit 1
    ;;
esac

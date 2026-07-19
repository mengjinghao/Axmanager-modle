#!/system/bin/sh
# ============================================================
# 实时系统监控面板 — install.sh
# 用法：install.sh [cpu|mem|battery|network|all]
# 通过 dumpsys 获取系统实时状态，WebUI面板展示
# ============================================================
MODDIR=${0%/*}
QUERY="$1"

case "$QUERY" in
cpu)
    # CPU使用率
    dumpsys cpuinfo 2>/dev/null | head -5
    ;;
mem)
    # 内存占用
    dumpsys meminfo 2>/dev/null | grep -E "Total RAM|Free RAM|Used RAM|Lost RAM" | head -5
    echo "---PROCESS---"
    dumpsys meminfo 2>/dev/null | grep "TOP" -A 5 | head -8
    ;;
battery)
    # 电池信息
    dumpsys battery 2>/dev/null
    ;;
network)
    # 网络信息
    dumpsys connectivity 2>/dev/null | grep -E "NetworkAgentInfo|type|state|speed" | head -10
    echo "---TRAFFIC---"
    cat /proc/net/dev 2>/dev/null | grep -E "wlan0|rmnet" | head -3
    ;;
all)
    echo "=== CPU ==="
    dumpsys cpuinfo 2>/dev/null | head -3
    echo "=== MEMORY ==="
    dumpsys meminfo 2>/dev/null | grep "Total RAM" | head -1
    echo "=== BATTERY ==="
    dumpsys battery 2>/dev/null | grep -E "level|temperature|health|status|technology" | head -5
    echo "=== DISK ==="
    df -h /data 2>/dev/null | tail -1
    ;;
screenshot)
    rm -f /sdcard/ax_screenshot.png 2>/dev/null
    screencap -p /sdcard/ax_screenshot.png 2>/dev/null && echo "OK:/sdcard/ax_screenshot.png" || echo "FAIL:截图失败"
    ;;
clear_cache)
    pm trim-caches 999G 2>/dev/null
    echo "系统缓存已清理"
    ;;
restart_ui)
    pkill -f com.android.systemui 2>/dev/null
    echo "SystemUI已重启"
    ;;
*)
    echo "用法: install.sh [cpu|mem|battery|network|all|screenshot|clear_cache|restart_ui]"
    ;;
esac

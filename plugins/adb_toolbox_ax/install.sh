#!/system/bin/sh
# ============================================================
# ADB快捷工具箱 — install.sh
# 用法：install.sh [screenshot|screenrecord_start|screenrecord_stop|dpi_380|dpi_440|dpi_480|restart_ui|clear_cache|freeze_background]
# ============================================================
MODDIR=${0%/*}
CMD="$1"

case "$CMD" in
screenshot)
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    FILE="/sdcard/ax_toolbox_${TIMESTAMP}.png"
    screencap -p "$FILE" 2>/dev/null && echo "截图已保存: $FILE" || echo "截图失败"
    ;;
screenrecord_start)
    pkill screenrecord 2>/dev/null
    nohup screenrecord --time-limit 180 --bit-rate 8000000 /sdcard/ax_recording.mp4 >/dev/null 2>&1 &
    echo "录屏已开始，最长180秒，自动保存为 /sdcard/ax_recording.mp4"
    ;;
screenrecord_stop)
    pkill screenrecord 2>/dev/null
    echo "录屏已停止，文件保存在 /sdcard/ax_recording.mp4"
    ;;
dpi_380)
    settings put system screen_density 380 2>/dev/null
    echo "DPI已设置为380(小图标大视野)"
    ;;
dpi_440)
    settings put system screen_density 440 2>/dev/null
    echo "DPI已设置为440(标准)"
    ;;
dpi_480)
    settings put system screen_density 480 2>/dev/null
    echo "DPI已设置为480(大图标护眼)"
    ;;
restart_ui)
    pkill -f com.android.systemui 2>/dev/null
    echo "SystemUI已重启，界面已刷新"
    ;;
clear_cache)
    pm trim-caches 999G 2>/dev/null
    echo "全部应用缓存已清理"
    ;;
freeze_background)
    ALL_APPS=$(pm list packages -3 2>/dev/null | sed 's/package://')
    COUNT=0
    for pkg in $ALL_APPS; do
        [ -z "$pkg" ] && continue
        cmd appops set "$pkg" RUN_IN_BACKGROUND deny 2>/dev/null
        COUNT=$((COUNT + 1))
    done
    echo "已冻结 ${COUNT} 个应用后台运行"
    ;;
*)
    echo "用法: install.sh [screenshot|screenrecord_start|screenrecord_stop|dpi_380|dpi_440|dpi_480|restart_ui|clear_cache|freeze_background]"
    ;;
esac

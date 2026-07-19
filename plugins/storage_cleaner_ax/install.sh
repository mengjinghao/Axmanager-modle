#!/system/bin/sh
# ============================================================
# 存储空间清理 — install.sh
# 用法：install.sh [deep_clean|light_clean|analyze]
# 清理缓存/日志/残留/临时文件，或仅分析空间占用
# ============================================================
MODDIR=${0%/*}
MODE="$1"

case "$MODE" in
deep_clean)
    ui_print "【深度清理】清除全部可清理的系统与应用垃圾"

    # 清理全部应用缓存
    CLEANED=0
    ui_print "正在清理应用缓存..."
    pm trim-caches 999G 2>/dev/null && CLEANED=$((CLEANED + 1))

    # 清理系统日志
    ui_print "正在清理系统日志..."
    logcat -c 2>/dev/null
    rm -rf /data/logs/* 2>/dev/null
    rm -rf /data/anr/* 2>/dev/null

    # 清理临时文件
    ui_print "正在清理临时文件..."
    rm -rf /data/local/tmp/* 2>/dev/null
    rm -rf /data/tmp/* 2>/dev/null
    rm -rf /sdcard/.thumbnails/* 2>/dev/null
    rm -rf /sdcard/Android/data/*/cache/* 2>/dev/null

    # 清理下载目录冗余
    rm -rf /sdcard/Download/*.tmp 2>/dev/null

    ui_print "深度清理完成：清理了应用缓存、系统日志、临时文件、缩略图缓存"
    ;;

light_clean)
    ui_print "【轻度清理】仅清理应用缓存和临时文件"

    pm trim-caches 999G 2>/dev/null
    rm -rf /data/local/tmp/* 2>/dev/null
    rm -rf /sdcard/.thumbnails/* 2>/dev/null

    ui_print "轻度清理完成：应用缓存、临时文件、缩略图缓存已清理"
    ;;

analyze)
    ui_print "【空间分析】扫描各目录空间占用情况"

    echo "=== /data 分区 ==="
    df -h /data 2>/dev/null

    echo ""
    echo "=== /sdcard 分区 ==="
    df -h /sdcard 2>/dev/null

    echo ""
    echo "=== /sdcard 子目录占用 TOP 5 ==="
    du -sh /sdcard/* 2>/dev/null | sort -rh | head -5

    echo ""
    echo "=== /data 子目录占用 ==="
    du -sh /data/app 2>/dev/null
    du -sh /data/data 2>/dev/null
    du -sh /data/dalvik-cache 2>/dev/null 2>/dev/null
    du -sh /data/local 2>/dev/null

    echo ""
    echo "=== 下载目录 ==="
    du -sh /sdcard/Download 2>/dev/null

    echo ""
    echo "=== 图片目录 ==="
    du -sh /sdcard/DCIM 2>/dev/null
    du -sh /sdcard/Pictures 2>/dev/null

    ui_print "空间分析完成，请查看上方输出。"
    ;;

*)
    ui_print "参数错误，请选择：deep_clean / light_clean / analyze"
    exit 1
    ;;
esac

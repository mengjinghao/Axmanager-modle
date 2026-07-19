#!/system/bin/sh
# ============================================================
# 应用数据备份迁移 — install.sh
# 用法：install.sh [full|data_only|restore] <包名>
# Shell UID穿透沙箱 备份/恢复 /data/data/<pkg>/ 到 /sdcard/AxBackup/
# ============================================================
MODDIR=${0%/*}
MODE="$1"
PKG="$2"
BACKUP_DIR="/sdcard/AxBackup"

list_packages() {
    pm list packages -3 2>/dev/null | sed 's/package://'
}

case "$MODE" in
full)
    [ -z "$PKG" ] && { ui_print "用法：install.sh full <包名>"; exit 1; }
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    DEST="$BACKUP_DIR/${PKG}_full_${TIMESTAMP}"
    mkdir -p "$DEST" 2>/dev/null

    ui_print "正在完整备份 $PKG ..."
    if [ -d "/data/data/$PKG" ]; then
        tar czf "$DEST/data.tar.gz" -C "/data/data/$PKG" . 2>/dev/null && ui_print "数据备份完成"
    else
        ui_print "警告：/data/data/$PKG 不存在"
    fi

    # 备份APK
    APK_PATH=$(pm path "$PKG" 2>/dev/null | sed 's/package://')
    if [ -n "$APK_PATH" ]; then
        cp "$APK_PATH" "$DEST/base.apk" 2>/dev/null && ui_print "APK备份完成"
    fi

    echo "备份时间: $(date)" > "$DEST/info.txt"
    echo "包名: $PKG" >> "$DEST/info.txt"

    ui_print "完整备份已保存到: $DEST"
    ;;

data_only)
    [ -z "$PKG" ] && { ui_print "用法：install.sh data_only <包名>"; exit 1; }
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    DEST="$BACKUP_DIR/${PKG}_data_${TIMESTAMP}"
    mkdir -p "$DEST" 2>/dev/null

    ui_print "正在备份 $PKG 数据目录（排除缓存）..."
    if [ -d "/data/data/$PKG" ]; then
        tar czf "$DEST/data.tar.gz" -C "/data/data/$PKG" . --exclude=cache --exclude=app_webview --exclude=code_cache 2>/dev/null
        ui_print "数据备份完成（已排除缓存目录）"
    else
        ui_print "警告：/data/data/$PKG 不存在"
    fi
    echo "备份时间: $(date) | 包名: $PKG | 模式: 仅数据" > "$DEST/info.txt"

    ui_print "数据备份已保存到: $DEST"
    ;;

restore)
    [ -z "$PKG" ] && { ui_print "用法：install.sh restore <备份目录名>"; exit 1; }
    SRC="$BACKUP_DIR/$PKG"
    [ ! -d "$SRC" ] && { ui_print "备份目录不存在: $SRC"; exit 1; }

    # 从info.txt读取原包名
    ORIG_PKG=$(grep "包名:" "$SRC/info.txt" 2>/dev/null | awk '{print $2}')
    [ -z "$ORIG_PKG" ] && ORIG_PKG=$(echo "$PKG" | sed 's/_.*//')

    ui_print "正在恢复数据到 $ORIG_PKG ..."
    if [ -f "$SRC/data.tar.gz" ]; then
        tar xzf "$SRC/data.tar.gz" -C "/data/data/$ORIG_PKG" 2>/dev/null
        ui_print "数据恢复完成"
    else
        ui_print "未找到备份文件 data.tar.gz"
    fi
    ;;

list)
    ui_print "=== 已安装第三方应用 ==="
    list_packages
    ui_print ""
    ui_print "=== 已有备份 ==="
    [ -d "$BACKUP_DIR" ] && ls -la "$BACKUP_DIR" 2>/dev/null || ui_print "(无备份)"
    ;;

*)
    ui_print "用法: install.sh [full|data_only|restore] <包名>"
    ui_print "       install.sh list  — 查看已安装应用和已有备份"
    exit 1
    ;;
esac

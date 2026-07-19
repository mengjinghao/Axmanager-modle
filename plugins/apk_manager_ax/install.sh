#!/system/bin/sh
# ============================================================
# APK管理与权限审计 — install.sh
# 用法：install.sh [extract <pkg>|permissions <pkg>|dangerous|uninstall <pkg>|list_users]
# 提取APK/权限审计/危险权限/卸载/用户应用列表
# ============================================================
MODDIR=${0%/*}
CMD="$1"
ARG="$2"
DEST="/sdcard/AxAPKs"

case "$CMD" in
extract)
    [ -z "$ARG" ] && { echo "用法: install.sh extract <包名>"; exit 1; }
    mkdir -p "$DEST" 2>/dev/null
    APK_PATH=$(pm path "$ARG" 2>/dev/null | sed 's/package://')
    if [ -n "$APK_PATH" ]; then
        cp "$APK_PATH" "$DEST/${ARG}_$(date +%Y%m%d).apk" 2>/dev/null
        echo "APK已提取到: $DEST/${ARG}_$(date +%Y%m%d).apk"
    else
        echo "未找到应用: $ARG"
    fi
    ;;
permissions)
    [ -z "$ARG" ] && { echo "用法: install.sh permissions <包名>"; exit 1; }
    ui_print "=== $ARG 权限列表 ==="
    dumpsys package "$ARG" 2>/dev/null | grep -E "permission.*granted=true" | awk -F: '{print $1}' | sort
    ;;
dangerous)
    ui_print "=== 所有应用危险权限审计 ==="
    DANGEROUS="android.permission.READ_CONTACTS android.permission.CAMERA android.permission.RECORD_AUDIO android.permission.ACCESS_FINE_LOCATION android.permission.READ_SMS android.permission.SEND_SMS android.permission.READ_CALL_LOG android.permission.WRITE_EXTERNAL_STORAGE"
    for perm in $DANGEROUS; do
        SHORT=$(echo "$perm" | sed 's/android.permission.//')
        echo ""
        echo "--- $SHORT ---"
        dumpsys package 2>/dev/null | grep -B 2 "$perm.*granted=true" | grep "Package" | awk '{print $2}' | sort
    done
    ;;
uninstall)
    [ -z "$ARG" ] && { echo "用法: install.sh uninstall <包名>"; exit 1; }
    pm uninstall --user 0 "$ARG" 2>/dev/null && echo "已卸载: $ARG" || echo "卸载失败: $ARG"
    ;;
list_users)
    ui_print "=== 已安装第三方应用 ==="
    pm list packages -3 2>/dev/null | sed 's/package://' | sort
    ;;
*)
    echo "用法: install.sh [extract|permissions|dangerous|uninstall|list_users] [包名]"
    exit 1
    ;;
esac

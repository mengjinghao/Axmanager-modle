#!/system/bin/sh
# ============================================================
# 通知管理控制 — install.sh
# 用法：install.sh [focus|standard|all_open]
# 通知弹出/HeadsUp/冷却时间/振动/渠道限制
# ============================================================
MODDIR=${0%/*}
MODE="$1"

reset_all() {
    settings put global heads_up_notifications_enabled "" 2>/dev/null
    settings put global heads_up_snooze "" 2>/dev/null
    settings put global notification_sound_enabled "" 2>/dev/null
    settings put global notification_vibration_enabled "" 2>/dev/null
    settings put global notification_cooldown "" 2>/dev/null
    settings put global peak_refresh_notification "" 2>/dev/null
    settings put global zen_mode "" 2>/dev/null
    setprop persist.notif.headsup "" 2>/dev/null
    setprop persist.notif.vibrate "" 2>/dev/null
}
reset_all

case "$MODE" in
focus)
    ui_print "【专注模式】仅允许来电/闹钟通知，关闭所有应用通知弹窗"

    settings put global heads_up_notifications_enabled 0 2>/dev/null
    settings put global heads_up_snooze 0 2>/dev/null
    settings put global notification_sound_enabled 0 2>/dev/null
    settings put global notification_vibration_enabled 0 2>/dev/null
    settings put global notification_cooldown 60000 2>/dev/null
    settings put global peak_refresh_notification 0 2>/dev/null
    settings put global zen_mode 1 2>/dev/null

    setprop persist.notif.headsup 0 2>/dev/null
    setprop persist.notif.vibrate 0 2>/dev/null

    ui_print "专注模式：关闭HeadsUp · 静音 · 关闭振动 · 仅保留闹钟/来电"
    ;;

standard)
    ui_print "【标准管理】允许通知但控制频率，减少打扰"

    settings put global heads_up_notifications_enabled 1 2>/dev/null
    settings put global heads_up_snooze 1 2>/dev/null
    settings put global notification_sound_enabled 1 2>/dev/null
    settings put global notification_vibration_enabled 1 2>/dev/null
    settings put global notification_cooldown 5000 2>/dev/null
    settings put global peak_refresh_notification 1 2>/dev/null
    settings put global zen_mode 0 2>/dev/null

    setprop persist.notif.headsup 1 2>/dev/null
    setprop persist.notif.vibrate 1 2>/dev/null

    ui_print "标准管理：正常通知 · 5s冷却 · 允许悬浮 · 标准振动"
    ;;

all_open)
    ui_print "【全部开启】所有通知即时弹出，无限制"

    settings put global heads_up_notifications_enabled 1 2>/dev/null
    settings put global heads_up_snooze 0 2>/dev/null
    settings put global notification_sound_enabled 1 2>/dev/null
    settings put global notification_vibration_enabled 1 2>/dev/null
    settings put global notification_cooldown 0 2>/dev/null
    settings put global peak_refresh_notification 1 2>/dev/null
    settings put global zen_mode 0 2>/dev/null

    setprop persist.notif.headsup 1 2>/dev/null
    setprop persist.notif.vibrate 1 2>/dev/null

    ui_print "全部开启：无冷却 · 即时弹出 · 完整通知 · 全部振动"
    ;;

*)
    ui_print "参数错误，请选择：focus / standard / all_open"
    exit 1
    ;;
esac

ui_print "注意：ADB表层修改，重启后全部失效。"

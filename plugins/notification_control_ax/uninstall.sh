#!/system/bin/sh
# 通知管理控制 — uninstall.sh
ui_print "正在恢复全部通知参数到原厂默认..."

settings delete global heads_up_notifications_enabled 2>/dev/null
settings delete global heads_up_snooze 2>/dev/null
settings delete global notification_sound_enabled 2>/dev/null
settings delete global notification_vibration_enabled 2>/dev/null
settings delete global notification_cooldown 2>/dev/null
settings delete global peak_refresh_notification 2>/dev/null
settings delete global zen_mode 2>/dev/null

setprop persist.notif.headsup "" 2>/dev/null
setprop persist.notif.vibrate "" 2>/dev/null

ui_print "重置完成，全部通知参数已恢复原厂默认，无残留。"

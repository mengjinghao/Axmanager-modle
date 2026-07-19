#!/system/bin/sh
# ============================================================
# 游戏辅助工具箱合集 — uninstall.sh
# 一次性清空所有游戏优化相关prop，恢复全部应用后台
# ============================================================
ui_print "正在恢复全部游戏参数和后台权限到原厂默认..."

settings delete system peak_refresh_rate 2>/dev/null
settings delete system min_refresh_rate 2>/dev/null
settings delete global game_driver_preference 2>/dev/null
settings delete global app_idle_constants 2>/dev/null

setprop debug.game.frame_rate_limit "" 2>/dev/null
setprop persist.gpu.freq.max "" 2>/dev/null
setprop persist.temp.limit "" 2>/dev/null
setprop persist.temp.throttle "" 2>/dev/null
setprop persist.graphics.dynamic_resolution "" 2>/dev/null
setprop persist.touch.sampling.rate "" 2>/dev/null
setprop persist.display.low_brightness.mode "" 2>/dev/null

# 恢复所有应用后台权限
ALL_APPS=$(pm list packages -3 2>/dev/null | sed 's/package://')
COUNT=0
for pkg in $ALL_APPS; do
    [ -z "$pkg" ] && continue
    cmd appops set "$pkg" RUN_IN_BACKGROUND default 2>/dev/null
    COUNT=$((COUNT + 1))
done

ui_print "重置完成。全部游戏参数已恢复默认，${COUNT} 个应用后台权限已恢复，无残留。"

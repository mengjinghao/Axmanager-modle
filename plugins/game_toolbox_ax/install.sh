#!/system/bin/sh
# ============================================================
# 游戏辅助工具箱合集 — install.sh
# 用法：install.sh [extreme|balanced|power|silent]
# 整合GPU帧率/温控/后台冻结/触控/动态分辨率 全套优化
# ============================================================
MODDIR=${0%/*}
MODE="$1"

# ===== 白名单游戏包名 =====
GAME_WHITELIST="com.tencent.tmgp.sgame com.tencent.tmgp.pubgmhd com.miHoYo.Yuanshen com.miHoYo.hkrpg com.tencent.tmgp.cf com.netease.pm67"

# ===== 重置全部游戏相关属性 =====
reset_all() {
    settings put system peak_refresh_rate "" 2>/dev/null
    settings put system min_refresh_rate "" 2>/dev/null
    setprop debug.game.frame_rate_limit "" 2>/dev/null
    setprop persist.gpu.freq.max "" 2>/dev/null
    setprop persist.temp.limit "" 2>/dev/null
    setprop persist.temp.throttle "" 2>/dev/null
    setprop persist.graphics.dynamic_resolution "" 2>/dev/null
    setprop persist.touch.sampling.rate "" 2>/dev/null
    setprop persist.display.low_brightness.mode "" 2>/dev/null
    settings put global app_idle_constants "" 2>/dev/null
    settings put global game_driver_preference "" 2>/dev/null
}
reset_all

# ===== 通用优化 =====
# 关闭动态分辨率
setprop persist.graphics.dynamic_resolution 0 2>/dev/null
# 提升触控采样
setprop persist.touch.sampling.rate high 2>/dev/null
# 关闭降亮度
setprop persist.display.low_brightness.mode 0 2>/dev/null

case "$MODE" in
extreme)
    ui_print "【极致性能】拉满所有性能参数，解温控，最高帧率"

    settings put system peak_refresh_rate 144 2>/dev/null
    settings put system min_refresh_rate 60 2>/dev/null
    setprop debug.game.frame_rate_limit 144 2>/dev/null
    setprop persist.gpu.freq.max 999 2>/dev/null
    setprop persist.temp.limit 48 2>/dev/null
    setprop persist.temp.throttle 45 2>/dev/null
    settings put global game_driver_preference 1 2>/dev/null
    settings put global app_idle_constants "" 2>/dev/null

    ui_print "极致性能：144fps · GPU全速 · 48°C温控 · 最高渲染"
    ;;

balanced)
    ui_print "【均衡游戏】平衡帧率与散热，标准游戏体验"

    settings put system peak_refresh_rate 90 2>/dev/null
    settings put system min_refresh_rate 30 2>/dev/null
    setprop debug.game.frame_rate_limit 90 2>/dev/null
    setprop persist.gpu.freq.max 750 2>/dev/null
    setprop persist.temp.limit 45 2>/dev/null
    setprop persist.temp.throttle 42 2>/dev/null
    settings put global game_driver_preference 0 2>/dev/null
    settings put global app_idle_constants "key_timeout=86400000" 2>/dev/null

    ui_print "均衡游戏：90fps · GPU适中 · 45°C标准温控"
    ;;

power)
    ui_print "【轻度省电】降频锁帧，延长续航"

    settings put system peak_refresh_rate 60 2>/dev/null
    settings put system min_refresh_rate 30 2>/dev/null
    setprop debug.game.frame_rate_limit 60 2>/dev/null
    setprop persist.gpu.freq.max 500 2>/dev/null
    setprop persist.temp.limit 42 2>/dev/null
    setprop persist.temp.throttle 38 2>/dev/null
    settings put global game_driver_preference 0 2>/dev/null
    settings put global app_idle_constants "key_timeout=3600000" 2>/dev/null

    ui_print "轻度省电：60fps · GPU降频 · 42°C · 后台限制"
    ;;

silent)
    ui_print "【温控静音】严格限制发热，适合长时间挂机"

    settings put system peak_refresh_rate 30 2>/dev/null
    settings put system min_refresh_rate 10 2>/dev/null
    setprop debug.game.frame_rate_limit 30 2>/dev/null
    setprop persist.gpu.freq.max 350 2>/dev/null
    setprop persist.temp.limit 38 2>/dev/null
    setprop persist.temp.throttle 35 2>/dev/null
    settings put global game_driver_preference 0 2>/dev/null
    settings put global app_idle_constants "key_timeout=600000" 2>/dev/null

    ui_print "温控静音：30fps · GPU最低 · 38°C极低温"
    ;;

*)
    ui_print "参数错误，请选择：extreme / balanced / power / silent"
    exit 1
    ;;
esac

# ===== 冻结非白名单后台应用 =====
ALL_APPS=$(pm list packages -3 2>/dev/null | sed 's/package://')
FROZEN=0
for pkg in $ALL_APPS; do
    [ -z "$pkg" ] && continue
    SKIP=0
    for white in $GAME_WHITELIST; do
        [ "$pkg" = "$white" ] && SKIP=1 && break
    done
    [ "$SKIP" -eq 1 ] && continue
    cmd appops set "$pkg" RUN_IN_BACKGROUND deny 2>/dev/null
    FROZEN=$((FROZEN + 1))
done

ui_print "已限制 ${FROZEN} 个非白名单应用后台。白名单游戏不受影响。"
ui_print "注意：ADB表层修改，重启后全部失效。"

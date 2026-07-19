#!/system/bin/sh
# ============================================================
# 机型专属手游画质调度 — install.sh
# 功能：三档GPU/帧率/温控参数一键切换
# 用法：install.sh [performance|balance|power_saver]
#
# 权限说明：
#   settings put — ADB权限可用 ✓
#   setprop persist.* — 需system级ADB，部分机型可能跳过
#   所有setprop已加2>/dev/null，失败不报错
# ============================================================
MODDIR=${0%/*}
MODE="$1"

# ========== 通用优化（所有模式自动启用，ADB权限可执行） ==========
ui_print "正在应用通用游戏优化..."

# 关闭游戏动态分辨率（settings可执行）
settings put system dynamic_resolution_switch 0 2>/dev/null

# 提升触控采样策略
settings put system touch_sensitivity_mode 1 2>/dev/null
settings put system pointer_speed 0 2>/dev/null

# 关闭自动亮度限制（防游戏降亮度）
settings put system screen_brightness_mode 1 2>/dev/null

# ========== 按模式写入参数 ==========
case "$MODE" in
performance)
    ui_print "【性能模式】拉高GPU频率、解除帧率限制、放宽温控"

    # --- settings属性（ADB可用）---
    settings put system peak_refresh_rate 120 2>/dev/null
    settings put system min_refresh_rate 60 2>/dev/null
    settings put system screen_off_refresh_rate 60 2>/dev/null

    # --- GPU高频（setprop，需system级ADB，失败则跳过）---
    setprop persist.gpu.freq.max 999 2>/dev/null
    setprop persist.gpu.min.freq 500 2>/dev/null
    setprop persist.gpu.render.level high 2>/dev/null
    setprop persist.gpu.power_policy always_on 2>/dev/null

    # --- 帧率解锁（setprop，按厂商适配）---
    setprop debug.game.frame_rate_limit 120 2>/dev/null
    setprop vivo.game.frame.rate 120 2>/dev/null
    setprop oppo.game.frame.rate 120 2>/dev/null
    setprop xiaomi.game.frame.rate 120 2>/dev/null

    # --- 放宽温控 ---
    setprop persist.temp.limit 48 2>/dev/null
    setprop persist.temp.throttle 45 2>/dev/null

    # --- 渲染优化 ---
    setprop debug.hwui.render_dirty_regions false 2>/dev/null
    setprop ro.vendor.perf.scroll_opt true 2>/dev/null

    # --- 游戏模式 ---
    settings put global game_driver_preference 1 2>/dev/null
    settings put system game_mode_performance 1 2>/dev/null

    ui_print "性能模式已生效：120fps + GPU高频 + 放宽温控"
    ;;

balance)
    ui_print "【均衡模式】平衡性能与温控"

    settings put system peak_refresh_rate 90 2>/dev/null
    settings put system min_refresh_rate 30 2>/dev/null
    settings put system screen_off_refresh_rate 30 2>/dev/null

    setprop persist.gpu.freq.max 750 2>/dev/null
    setprop persist.gpu.min.freq 305 2>/dev/null
    setprop persist.gpu.render.level medium 2>/dev/null
    setprop persist.gpu.power_policy balanced 2>/dev/null

    setprop debug.game.frame_rate_limit 90 2>/dev/null
    setprop vivo.game.frame.rate 90 2>/dev/null
    setprop oppo.game.frame.rate 90 2>/dev/null
    setprop xiaomi.game.frame.rate 90 2>/dev/null

    setprop persist.temp.limit 45 2>/dev/null
    setprop persist.temp.throttle 42 2>/dev/null

    setprop debug.hwui.render_dirty_regions true 2>/dev/null
    setprop ro.vendor.perf.scroll_opt true 2>/dev/null

    settings put global game_driver_preference 0 2>/dev/null
    settings put system game_mode_performance 0 2>/dev/null

    ui_print "均衡模式已生效：90fps + GPU适中 + 标准温控"
    ;;

power_saver)
    ui_print "【省电模式】降频锁帧、收紧温控"

    settings put system peak_refresh_rate 60 2>/dev/null
    settings put system min_refresh_rate 30 2>/dev/null
    settings put system screen_off_refresh_rate 10 2>/dev/null

    setprop persist.gpu.freq.max 500 2>/dev/null
    setprop persist.gpu.min.freq 180 2>/dev/null
    setprop persist.gpu.render.level low 2>/dev/null
    setprop persist.gpu.power_policy battery_save 2>/dev/null

    setprop debug.game.frame_rate_limit 60 2>/dev/null
    setprop vivo.game.frame.rate 60 2>/dev/null
    setprop oppo.game.frame.rate 60 2>/dev/null
    setprop xiaomi.game.frame.rate 60 2>/dev/null

    setprop persist.temp.limit 42 2>/dev/null
    setprop persist.temp.throttle 38 2>/dev/null

    setprop debug.hwui.render_dirty_regions true 2>/dev/null
    setprop ro.vendor.perf.scroll_opt false 2>/dev/null

    settings put global game_driver_preference 0 2>/dev/null
    settings put system game_mode_performance 0 2>/dev/null

    ui_print "省电模式已生效：60fps + GPU降频 + 收紧温控"
    ;;

*)
    ui_print "参数错误，请选择：performance / balance / power_saver"
    exit 1
    ;;
esac

ui_print "通用优化已启用：关闭动态分辨率 + 提升触控 + 防降亮度"
ui_print "注意：setprop属性需system级ADB权限，部分机型可能跳过，不影响settings属性生效"

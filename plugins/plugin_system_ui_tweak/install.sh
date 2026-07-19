#!/system/bin/sh
# ============================================================
# 系统界面美化微调 — install.sh
# 功能：三档DPI/动画/刷新率/状态栏参数切换
# 用法：install.sh [smooth|balanced|eye_care]
#
# 权限说明：全部使用settings put，ADB权限可用 ✓
# 注意：settings属性重启后全部恢复默认，非持久化修改
# ============================================================
MODDIR=${0%/*}
MODE="$1"

# ========== 重置全部界面属性到默认值 ==========
reset_ui_settings() {
    settings put global window_animation_scale 1.0 2>/dev/null
    settings put global transition_animation_scale 1.0 2>/dev/null
    settings put global animator_duration_scale 1.0 2>/dev/null
    settings delete system screen_density 2>/dev/null
    settings delete system peak_refresh_rate 2>/dev/null
    settings delete system min_refresh_rate 2>/dev/null
    settings delete system screen_off_refresh_rate 2>/dev/null
    settings delete system status_bar_height 2>/dev/null
}
reset_ui_settings

# ========== 按模式写入参数 ==========
case "$MODE" in
smooth)
    ui_print "【清爽高性能】0.5x动画 + 低DPI视野 + 高刷常驻"

    settings put global window_animation_scale 0.5 2>/dev/null
    settings put global transition_animation_scale 0.5 2>/dev/null
    settings put global animator_duration_scale 0.5 2>/dev/null

    settings put system screen_density 380 2>/dev/null

    settings put system peak_refresh_rate 120 2>/dev/null
    settings put system min_refresh_rate 60 2>/dev/null
    settings put system screen_off_refresh_rate 60 2>/dev/null

    settings put system status_bar_height 28 2>/dev/null

    ui_print "已生效：0.5x动画 + DPI:380 + 高刷常驻"
    ;;

balanced)
    ui_print "【原生均衡】默认动画 + 标准DPI + 系统策略"

    settings put global window_animation_scale 1.0 2>/dev/null
    settings put global transition_animation_scale 1.0 2>/dev/null
    settings put global animator_duration_scale 1.0 2>/dev/null

    settings put system screen_density 440 2>/dev/null

    settings put system peak_refresh_rate 90 2>/dev/null
    settings put system min_refresh_rate 30 2>/dev/null
    settings put system screen_off_refresh_rate 30 2>/dev/null

    settings put system status_bar_height 32 2>/dev/null

    ui_print "已生效：1.0x动画 + DPI:440 + 默认刷新策略"
    ;;

eye_care)
    ui_print "【护眼省电】长动画 + 高DPI + 低刷新率策略"

    settings put global window_animation_scale 1.5 2>/dev/null
    settings put global transition_animation_scale 1.5 2>/dev/null
    settings put global animator_duration_scale 1.5 2>/dev/null

    settings put system screen_density 480 2>/dev/null

    settings put system peak_refresh_rate 60 2>/dev/null
    settings put system min_refresh_rate 30 2>/dev/null
    settings put system screen_off_refresh_rate 10 2>/dev/null

    settings put system status_bar_height 32 2>/dev/null

    ui_print "已生效：1.5x动画 + DPI:480 + 低刷新率省电"
    ;;

*)
    ui_print "参数错误，请选择：smooth / balanced / eye_care"
    exit 1
    ;;
esac

ui_print "注意：settings属性重启后全部恢复默认。建议每次重启后重新切换。"

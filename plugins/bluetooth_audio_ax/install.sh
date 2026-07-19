#!/system/bin/sh
# ============================================================
# 蓝牙音频增强 — install.sh
# 用法：install.sh [hifi|balanced|low_latency]
# 蓝牙编码选择/采样率/比特率/LDAC品质/A2DP延迟/绝对音量
# ============================================================
MODDIR=${0%/*}
MODE="$1"

reset_all() {
    settings put global bluetooth_codec "" 2>/dev/null
    settings put global bluetooth_sample_rate "" 2>/dev/null
    settings put global bluetooth_bit_rate "" 2>/dev/null
    settings put global bluetooth_ldac_quality "" 2>/dev/null
    settings put global bluetooth_a2dp_latency "" 2>/dev/null
    settings put global bluetooth_absolute_volume "" 2>/dev/null
    setprop persist.bluetooth.codec "" 2>/dev/null
    setprop persist.bluetooth.bitpool "" 2>/dev/null
    setprop persist.bluetooth.a2dp.offload "" 2>/dev/null
}
reset_all

case "$MODE" in
hifi)
    ui_print "【高音质】LDAC最高品质·990kbps·96kHz·A2DP硬解"

    settings put global bluetooth_codec LDAC 2>/dev/null
    settings put global bluetooth_sample_rate 96000 2>/dev/null
    settings put global bluetooth_bit_rate 990000 2>/dev/null
    settings put global bluetooth_ldac_quality 3 2>/dev/null
    settings put global bluetooth_a2dp_latency 0 2>/dev/null
    settings put global bluetooth_absolute_volume 1 2>/dev/null

    setprop persist.bluetooth.codec ldac 2>/dev/null
    setprop persist.bluetooth.bitpool 53 2>/dev/null
    setprop persist.bluetooth.a2dp.offload 1 2>/dev/null

    ui_print "高音质：LDAC自适应 · 990kbps · 96kHz · 最佳音质"
    ;;

balanced)
    ui_print "【标准均衡】AAC标准编码·44.1kHz·均衡音质与延迟"

    settings put global bluetooth_codec AAC 2>/dev/null
    settings put global bluetooth_sample_rate 44100 2>/dev/null
    settings put global bluetooth_bit_rate 256000 2>/dev/null
    settings put global bluetooth_ldac_quality 1 2>/dev/null
    settings put global bluetooth_a2dp_latency 0 2>/dev/null
    settings put global bluetooth_absolute_volume 1 2>/dev/null

    setprop persist.bluetooth.codec aac 2>/dev/null
    setprop persist.bluetooth.bitpool 32 2>/dev/null
    setprop persist.bluetooth.a2dp.offload 1 2>/dev/null

    ui_print "标准均衡：AAC编码 · 256kbps · 44.1kHz · 均衡模式"
    ;;

low_latency)
    ui_print "【低延迟通话】SBC低延迟·游戏通话优化"

    settings put global bluetooth_codec SBC 2>/dev/null
    settings put global bluetooth_sample_rate 44100 2>/dev/null
    settings put global bluetooth_bit_rate 328000 2>/dev/null
    settings put global bluetooth_ldac_quality 0 2>/dev/null
    settings put global bluetooth_a2dp_latency 1 2>/dev/null
    settings put global bluetooth_absolute_volume 0 2>/dev/null

    setprop persist.bluetooth.codec sbc 2>/dev/null
    setprop persist.bluetooth.bitpool 53 2>/dev/null
    setprop persist.bluetooth.a2dp.offload 0 2>/dev/null

    ui_print "低延迟通话：SBC编码 · 高bitpool · 低延迟 · 适合游戏通话"
    ;;

*)
    ui_print "参数错误，请选择：hifi / balanced / low_latency"
    exit 1
    ;;
esac

ui_print "注意：编码器需耳机支持。ADB表层修改，重启后全部失效。"

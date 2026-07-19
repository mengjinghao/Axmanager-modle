#!/system/bin/sh
# ============================================================
# 音效音量均衡调节 — install.sh
# 用法：install.sh [standard|bass_boost|call_boost]
# 仅表层属性调整，不替换声卡驱动/音频库文件
# ============================================================
MODDIR=${0%/*}
MODE="$1"

# ===== 重置全部音效属性 =====
reset_all() {
    setprop persist.audio.volume.limit "" 2>/dev/null
    setprop persist.audio.media.curve "" 2>/dev/null
    setprop persist.audio.headset.boost "" 2>/dev/null
    setprop persist.audio.bass.boost "" 2>/dev/null
    setprop persist.audio.compressor "" 2>/dev/null
    setprop persist.audio.mic.gain "" 2>/dev/null
    setprop persist.audio.speaker.gain "" 2>/dev/null
    setprop persist.audio.call.gain "" 2>/dev/null
    setprop persist.audio.eq "" 2>/dev/null
    setprop persist.audio.surround "" 2>/dev/null
    settings put system volume_music_speaker "" 2>/dev/null
    settings put system volume_voice_call "" 2>/dev/null
    settings put global audio_safe_volume_state "" 2>/dev/null
}
reset_all

# ===== 按模式写入 =====
case "$MODE" in
standard)
    ui_print "【原声标准】恢复系统默认音量曲线与音效参数"

    setprop persist.audio.volume.limit 80 2>/dev/null
    setprop persist.audio.media.curve flat 2>/dev/null
    setprop persist.audio.headset.boost 0 2>/dev/null
    setprop persist.audio.bass.boost 0 2>/dev/null
    setprop persist.audio.compressor 1 2>/dev/null
    setprop persist.audio.mic.gain 0 2>/dev/null
    setprop persist.audio.speaker.gain 0 2>/dev/null
    setprop persist.audio.call.gain 0 2>/dev/null
    setprop persist.audio.eq flat 2>/dev/null
    setprop persist.audio.surround 0 2>/dev/null

    settings put system volume_music_speaker 15 2>/dev/null
    settings put global audio_safe_volume_state 2 2>/dev/null

    ui_print "原声标准已生效：平整曲线 · 默认音量上限 · 原始增益"
    ;;

bass_boost)
    ui_print "【增强低音】提升低频响应，关闭音量压缩"

    setprop persist.audio.volume.limit 90 2>/dev/null
    setprop persist.audio.media.curve bass 2>/dev/null
    setprop persist.audio.headset.boost 1 2>/dev/null
    setprop persist.audio.bass.boost 1 2>/dev/null
    setprop persist.audio.compressor 0 2>/dev/null
    setprop persist.audio.mic.gain 0 2>/dev/null
    setprop persist.audio.speaker.gain 2 2>/dev/null
    setprop persist.audio.call.gain 0 2>/dev/null
    setprop persist.audio.eq bass_boost 2>/dev/null
    setprop persist.audio.surround 1 2>/dev/null

    settings put system volume_music_speaker 20 2>/dev/null
    settings put global audio_safe_volume_state 1 2>/dev/null

    ui_print "增强低音已生效：低频加强 · 外放增益+2dB · 关闭压缩 · 立体环绕"
    ;;

call_boost)
    ui_print "【通话增益拉满】提升听筒/麦克风灵敏度"

    setprop persist.audio.volume.limit 85 2>/dev/null
    setprop persist.audio.media.curve flat 2>/dev/null
    setprop persist.audio.headset.boost 0 2>/dev/null
    setprop persist.audio.bass.boost 0 2>/dev/null
    setprop persist.audio.compressor 0 2>/dev/null
    setprop persist.audio.mic.gain 3 2>/dev/null
    setprop persist.audio.speaker.gain 0 2>/dev/null
    setprop persist.audio.call.gain 3 2>/dev/null
    setprop persist.audio.eq voice 2>/dev/null
    setprop persist.audio.surround 0 2>/dev/null

    settings put system volume_voice_call 10 2>/dev/null
    settings put global audio_safe_volume_state 1 2>/dev/null

    ui_print "通话增益已生效：听筒+3dB · 麦克风+3dB · 人声EQ优化"
    ;;

*)
    ui_print "参数错误，请选择：standard / bass_boost / call_boost"
    exit 1
    ;;
esac

ui_print "注意：ADB表层修改，重启后全部失效。"

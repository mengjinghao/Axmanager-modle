#!/system/bin/sh
# ============================================================
# 音效音量均衡调节 — uninstall.sh
# 清空全部音效自定义属性，恢复系统原生音量限制
# ============================================================
ui_print "正在恢复全部音效/音量属性到原厂默认..."

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

settings delete system volume_music_speaker 2>/dev/null
settings delete system volume_voice_call 2>/dev/null
settings delete global audio_safe_volume_state 2>/dev/null

ui_print "重置完成，全部音效/音量参数已恢复系统原生默认，无残留。"

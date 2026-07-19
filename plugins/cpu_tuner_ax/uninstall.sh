#!/system/bin/sh
# CPU性能调度 — uninstall.sh
ui_print "正在恢复全部CPU调度参数到原厂默认..."

setprop persist.cpu.governor "" 2>/dev/null
setprop persist.cpu.freq.max "" 2>/dev/null
setprop persist.cpu.freq.min "" 2>/dev/null
setprop persist.cpu.boost "" 2>/dev/null
setprop persist.cpu.touch.boost "" 2>/dev/null
setprop persist.cpu.thermal.throttle "" 2>/dev/null
setprop persist.cpu.cores.online "" 2>/dev/null

settings delete global cpu_governor 2>/dev/null
settings delete global game_driver_preference 2>/dev/null

ui_print "重置完成，全部CPU调度参数已恢复原厂默认，无残留。"

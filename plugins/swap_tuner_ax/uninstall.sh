#!/system/bin/sh
# 虚拟内存优化 — uninstall.sh
ui_print "正在恢复全部虚拟内存参数到原厂默认..."

setprop persist.sys.swap.size "" 2>/dev/null
setprop persist.sys.swappiness "" 2>/dev/null
setprop persist.sys.zram.size "" 2>/dev/null
setprop persist.sys.zram.algorithm "" 2>/dev/null
setprop persist.sys.zram.writeback "" 2>/dev/null
setprop persist.sys.page.reclaim "" 2>/dev/null
setprop persist.sys.vm.dirty_ratio "" 2>/dev/null
setprop persist.sys.vm.vfs_cache_pressure "" 2>/dev/null

ui_print "重置完成，全部虚拟内存参数已恢复原厂默认，无残留。"

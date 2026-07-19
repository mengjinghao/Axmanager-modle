#!/system/bin/sh
# 内存释放优化 — uninstall.sh
ui_print "正在恢复全部内存参数到原厂默认..."

setprop persist.sys.lmk.minfree "" 2>/dev/null
setprop persist.sys.dalvik.vm.heapgrowthlimit "" 2>/dev/null
setprop persist.sys.dalvik.vm.heapsize "" 2>/dev/null
setprop persist.sys.zram.size "" 2>/dev/null
setprop persist.sys.cache.limit "" 2>/dev/null
setprop persist.sys.background_process_limit "" 2>/dev/null
setprop persist.sys.max_cached_apps "" 2>/dev/null

settings delete global activity_manager_constants 2>/dev/null

ui_print "重置完成，全部内存参数已恢复原厂默认，无残留。"

#!/system/bin/sh
# ============================================================
# 内存释放优化 — install.sh
# 用法：install.sh [aggressive|balanced|multitask]
# LMK回收/Dalvik堆/ZRAM/缓存/后台进程限制
# ============================================================
MODDIR=${0%/*}
MODE="$1"

reset_all() {
    setprop persist.sys.lmk.minfree "" 2>/dev/null
    setprop persist.sys.dalvik.vm.heapgrowthlimit "" 2>/dev/null
    setprop persist.sys.dalvik.vm.heapsize "" 2>/dev/null
    setprop persist.sys.zram.size "" 2>/dev/null
    setprop persist.sys.cache.limit "" 2>/dev/null
    setprop persist.sys.background_process_limit "" 2>/dev/null
    setprop persist.sys.max_cached_apps "" 2>/dev/null
    settings put global activity_manager_constants "" 2>/dev/null
}
reset_all

case "$MODE" in
aggressive)
    ui_print "【激进回收】强力内存回收，保持最大可用内存"

    setprop persist.sys.lmk.minfree "18432,23040,27648,32256,55296,80640" 2>/dev/null
    setprop persist.sys.dalvik.vm.heapgrowthlimit 128m 2>/dev/null
    setprop persist.sys.dalvik.vm.heapsize 256m 2>/dev/null
    setprop persist.sys.zram.size 512 2>/dev/null
    setprop persist.sys.cache.limit 100 2>/dev/null
    setprop persist.sys.background_process_limit 2 2>/dev/null
    setprop persist.sys.max_cached_apps 4 2>/dev/null

    settings put global activity_manager_constants "max_cached_processes=4,cur_component_bg_procs=8" 2>/dev/null

    ui_print "激进回收：LMK高阈值 · 堆128MB · 后台≤2进程 · 强力回收"
    ;;

balanced)
    ui_print "【均衡日常】标准内存策略，平衡性能与可用内存"

    setprop persist.sys.lmk.minfree "12288,15360,18432,21504,36864,53760" 2>/dev/null
    setprop persist.sys.dalvik.vm.heapgrowthlimit 192m 2>/dev/null
    setprop persist.sys.dalvik.vm.heapsize 384m 2>/dev/null
    setprop persist.sys.zram.size 1024 2>/dev/null
    setprop persist.sys.cache.limit 200 2>/dev/null
    setprop persist.sys.background_process_limit "" 2>/dev/null
    setprop persist.sys.max_cached_apps 12 2>/dev/null

    settings put global activity_manager_constants "max_cached_processes=12,cur_component_bg_procs=16" 2>/dev/null

    ui_print "均衡日常：标准LMK · 堆192MB · 12缓存 · 1GB ZRAM"
    ;;

multitask)
    ui_print "【多任务保活】放宽内存限制，最大化后台存活"

    setprop persist.sys.lmk.minfree "6144,7680,9216,10752,18432,26880" 2>/dev/null
    setprop persist.sys.dalvik.vm.heapgrowthlimit 256m 2>/dev/null
    setprop persist.sys.dalvik.vm.heapsize 512m 2>/dev/null
    setprop persist.sys.zram.size 2048 2>/dev/null
    setprop persist.sys.cache.limit 300 2>/dev/null
    setprop persist.sys.background_process_limit "" 2>/dev/null
    setprop persist.sys.max_cached_apps 24 2>/dev/null

    settings put global activity_manager_constants "max_cached_processes=24,cur_component_bg_procs=32" 2>/dev/null

    ui_print "多任务保活：低LMK阈值 · 堆256MB · 24缓存 · 2GB ZRAM · 多开友好"
    ;;

*)
    ui_print "参数错误，请选择：aggressive / balanced / multitask"
    exit 1
    ;;
esac

ui_print "注意：ADB表层修改，重启后全部失效。"

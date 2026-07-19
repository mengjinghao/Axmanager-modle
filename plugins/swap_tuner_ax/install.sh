#!/system/bin/sh
# ============================================================
# 虚拟内存优化 — install.sh
# 用法：install.sh [performance|balanced|battery]
# Swap大小/交换倾向/ZRAM压缩/写回/页面回收
# ============================================================
MODDIR=${0%/*}
MODE="$1"

reset_all() {
    setprop persist.sys.swap.size "" 2>/dev/null
    setprop persist.sys.swappiness "" 2>/dev/null
    setprop persist.sys.zram.size "" 2>/dev/null
    setprop persist.sys.zram.algorithm "" 2>/dev/null
    setprop persist.sys.zram.writeback "" 2>/dev/null
    setprop persist.sys.page.reclaim "" 2>/dev/null
    setprop persist.sys.vm.dirty_ratio "" 2>/dev/null
    setprop persist.sys.vm.vfs_cache_pressure "" 2>/dev/null
}
reset_all

case "$MODE" in
performance)
    ui_print "【性能优先】大ZRAM+低压缩+减少Swap交换"

    setprop persist.sys.swap.size 2048 2>/dev/null
    setprop persist.sys.swappiness 20 2>/dev/null
    setprop persist.sys.zram.size 4096 2>/dev/null
    setprop persist.sys.zram.algorithm lz4 2>/dev/null
    setprop persist.sys.zram.writeback 0 2>/dev/null
    setprop persist.sys.page.reclaim 1 2>/dev/null
    setprop persist.sys.vm.dirty_ratio 10 2>/dev/null
    setprop persist.sys.vm.vfs_cache_pressure 50 2>/dev/null

    ui_print "性能优先：2GB Swap · 4GB ZRAM · lz4算法 · 低交换 · 快速回收"
    ;;

balanced)
    ui_print "【均衡日常】标准ZRAM+适中交换"

    setprop persist.sys.swap.size 1024 2>/dev/null
    setprop persist.sys.swappiness 60 2>/dev/null
    setprop persist.sys.zram.size 2048 2>/dev/null
    setprop persist.sys.zram.algorithm lzo 2>/dev/null
    setprop persist.sys.zram.writeback 1 2>/dev/null
    setprop persist.sys.page.reclaim 1 2>/dev/null
    setprop persist.sys.vm.dirty_ratio 20 2>/dev/null
    setprop persist.sys.vm.vfs_cache_pressure 100 2>/dev/null

    ui_print "均衡日常：1GB Swap · 2GB ZRAM · lzo算法 · 标准交换"
    ;;

battery)
    ui_print "【省电续航】小ZRAM+高压缩+主动写回"

    setprop persist.sys.swap.size 512 2>/dev/null
    setprop persist.sys.swappiness 100 2>/dev/null
    setprop persist.sys.zram.size 1024 2>/dev/null
    setprop persist.sys.zram.algorithm zstd 2>/dev/null
    setprop persist.sys.zram.writeback 1 2>/dev/null
    setprop persist.sys.page.reclaim 1 2>/dev/null
    setprop persist.sys.vm.dirty_ratio 30 2>/dev/null
    setprop persist.sys.vm.vfs_cache_pressure 200 2>/dev/null

    ui_print "省电续航：512MB Swap · 1GB ZRAM · zstd高压缩 · 主动写回"
    ;;

*)
    ui_print "参数错误，请选择：performance / balanced / battery"
    exit 1
    ;;
esac

ui_print "注意：虚拟内存参数依赖内核支持，不存在的属性自动跳过。ADB表层修改，重启后全部失效。"

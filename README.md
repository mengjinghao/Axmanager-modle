# AxManager 插件合集

5 套 AXManager 插件，基于 ADB shell 实现，免 Root，内置 M3 WebUI 可视化面板。

## 插件列表

| 插件 | 文件夹 | 功能 |
|------|--------|------|
| 手游画质调度 | `plugin_game_gpu_tune` | GPU频率/帧率/温控三档切换 |
| 界面美化微调 | `plugin_system_ui_tweak` | DPI/动画/刷新率三档预设 |
| 预装冻结精简 | `plugin_app_freeze` | 厂商预装/广告组件批量冻结 |
| 后台管控优化 | `plugin_background_optimize` | 自启动/后台/唤醒三档策略 |
| 全局广告屏蔽 | `plugin_ad_block` | 厂商广告/个性化推荐关闭 |

## 安装

1. 从 [Releases](https://github.com/mengjinghao/Axmanager-modle/releases) 下载 ZIP
2. AXManager → 插件 → 导入 ZIP
3. 打开 WebUI 面板切换模式

## 目录结构

```
plugins/
├── plugin_xxx/
│   ├── module.prop          # 插件标识 (axeronPlugin=1)
│   ├── install.sh           # 模式切换脚本
│   ├── uninstall.sh         # 恢复原厂脚本
│   ├── action.sh            # Action按钮入口
│   └── webroot/
│       └── index.html       # M3 WebUI 面板
```

# AXManager 插件合集

> 30 个 AXManager 系统工具插件 · ADB Shell + M3 WebUI · 免 Root（需 Shizuku/ADB）

<p align="center">
  <img src="https://img.shields.io/badge/Plugins-30-orange" />
  <img src="https://img.shields.io/badge/Mode-ADB%20%2F%20Shizuku-orange" />
  <img src="https://img.shields.io/badge/UI-Material%203%20WebUI-orange" />
  <img src="https://img.shields.io/badge/Platform-Android-orange" />
</p>

## 插件列表（30 个）

### 系统调优

| 插件 | 功能 |
|------|------|
| cpu_tuner_ax | CPU 调频（大小核频率 / 调度器） |
| gpu_tune_ax | GPU 调频（游戏 GPU 频率） |
| swap_tuner_ax | Swap 虚拟内存调整 |
| memory_cleaner_ax | 内存清理（杀后台进程） |
| doze_tuner_ax | Doze 模式调优（省电） |
| charge_thermal_ax | 充电温控（充电速度 / 温度） |

### 网络优化

| 插件 | 功能 |
|------|------|
| network_optimize_ax | 网络优化（DNS / MTU / TCP） |
| wifi_boost_ax | WiFi 信号增强 |
| proxy_switch_ax | 代理切换（HTTP / SOCKS） |
| bluetooth_audio_ax | 蓝牙音频调优（编码 / 码率） |

### 显示与音频

| 插件 | 功能 |
|------|------|
| display_color_ax | 显示色彩调整（色温 / 饱和度） |
| audio_balance_ax | 音频平衡（左右声道） |
| reading_mode_ax | 阅读模式（护眼滤镜） |

### 应用管理

| 插件 | 功能 |
|------|------|
| apk_manager_ax | APK 管理（安装 / 卸载 / 备份） |
| app_backup_ax | 应用备份（数据 + APK） |
| storage_cleaner_ax | 存储清理（缓存 / 残留） |
| process_guard_ax | 进程守护（保活 / 杀进程） |

### 系统工具

| 插件 | 功能 |
|------|------|
| adb_toolbox_ax | ADB 工具箱（常用 adb 命令） |
| boot_control_ax | 开机启动管理 |
| logcat_toolbox_ax | Logcat 日志工具 |
| system_monitor_ax | 系统监控（CPU / 内存 / 电池） |
| ota_guard_ax | OTA 升级拦截 |
| sensor_tuner_ax | 传感器调优 |
| notification_control_ax | 通知控制 |
| game_toolbox_ax | 游戏工具箱 |

### 扩展插件

| 插件 | 功能 |
|------|------|
| plugin_ad_block | 广告拦截（hosts） |
| plugin_app_freeze | 应用冻结 |
| plugin_background_optimize | 后台优化 |
| plugin_game_gpu_tune | 游戏 GPU 调频 |
| plugin_system_ui_tweak | System UI 调整 |
| gps_optimizer_ax | GPS 优化 |

## 核心特性

- **免 Root**：通过 ADB 或 Shizuku 执行系统级命令
- **M3 WebUI**：每个插件配备 Material 3 风格 WebUI
- **ADB Shell**：直接执行 adb shell 命令，无需 Root
- **模块化**：30 个插件独立打包，按需安装

## 使用方法

### 1. 安装 AXManager

从 [AXManager](https://github.com/AceGuru-mjh/Axmanager-modle/releases) 下载主程序并安装。

### 2. 授权 ADB / Shizuku

- 方式 A：电脑 ADB 授权（开发者选项 → USB 调试）
- 方式 B：Shizuku 授权（安装 Shizuku APP 并启动服务）

### 3. 安装插件

1. 从 [Releases](https://github.com/AceGuru-mjh/Axmanager-modle/releases) 下载需要的插件 zip
2. 打开 AXManager → 插件管理 → 导入插件
3. 选择下载的 zip 文件

## 插件结构

```
plugin_xxx_ax/
├── manifest.json          # 插件清单（名称 / 版本 / 权限）
├── main.sh                # 主脚本（ADB shell 命令）
├── webui/                 # Material 3 WebUI
│   ├── index.html
│   ├── style.css
│   └── script.js
└── icon.svg               # 插件图标
```

## 构建

插件为 zip 格式，无需编译：

```bash
cd plugins/cpu_tuner_ax
zip -r ../releases/cpu_tuner_ax.zip .
```

## 技术栈

- **运行时**：ADB Shell / Shizuku
- **UI**：HTML + CSS + JS（Material 3 风格）
- **脚本**：Shell（sh）
- **平台**：Android 8.0+

## 相关链接

- **Shizuku**：https://github.com/RikkaApps/Shizuku
- **LSPatch 模块**：https://github.com/AceGuru-mjh/LSPatch-Noroot-modle

## 开发者

**MJH** - [@AceGuru-mjh](https://github.com/AceGuru-mjh)

## License

MIT

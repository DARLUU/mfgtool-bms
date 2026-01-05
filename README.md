## 工程简介

本工程是用于在 Windows 下，通过 NXP 官方 MfgTool 工具给 **i.MX6ULL BMS 板**烧录系统镜像的工程包。  
主要用于烧录：

- U‑Boot 引导程序
- Linux 内核 `zImage`
- 设备树 `imx6ull-bms-nand.dtb`
- 根文件系统 `rootfs.tar.bz2`

> 说明：`Profiles/Linux/OS Firmware/firmware` 目录下的固件仅用于 **启动烧录环境本身**，一般不要更新。

## 目录结构（关键部分）

- `Profiles/Linux/OS Firmware/files/boot`  
  烧录到板子上的启动镜像目录，包含：
  - `u-boot-imx6ull-bms-ddr512-nand*.imx / .bin`
  - `zImage`
  - `imx6ull-bms-nand.dtb`

- `Profiles/Linux/OS Firmware/files/filesystem`  
  烧录到板子上的根文件系统压缩包：
  - `rootfs.tar.bz2`

- `Profiles/Linux/OS Firmware/firmware`  
  MfgTool 自身启动使用的固件，请参考目录下的中文说明文件，一般 **不要替换这里的文件**。

## 与 Ubuntu 工程配合的更新方式

上位机有一个单独的“更新脚本”目录（不在本仓库内）：

- `F:\working data\linux_bms\更新代码`

常用脚本：

- `update_from_ubuntu.bat`  
  - 功能：从 Ubuntu 拉取 **内核 zImage、dtb 和 rootfs**，更新到本工程对应目录中。  
  - 适合：只更新内核 / 根文件系统，不改 U‑Boot 的场景。

- `update_from_ubuntu_full.bat`  
  - 功能：在上述基础上 **额外更新 U‑Boot**，包括：
    - `u-boot-imx6ull-bms-ddr512-nand.imx`
    - `u-boot-imx6ull-bms-ddr512-nand.bin`
  - Ubuntu 侧源路径（示例，需保证编译产物存在）：  
    - `/home/xixing/linux/tftpboot/zImage`  
    - `/home/xixing/linux/tftpboot/imx6ull-bms-nand.dtb`  
    - `/home/xixing/linux/nfs/buildroot/rootfs/rootfs.tar.bz2`  
    - `/home/xixing/alientek/mini_linux/Linux/bms/uboot/uboot-imx-rel_imx_4.1.15_2.1.0_ga_alientek/u-boot-imx6ull-bms-ddr512-nand.imx`  
    - `/home/xixing/alientek/mini_linux/Linux/bms/uboot/uboot-imx-rel_imx_4.1.15_2.1.0_ga_alientek/u-boot-imx6ull-bms-ddr512-nand.bin`

脚本会自动把这些文件同步到：

- `Profiles/Linux/OS Firmware/files/boot`
- `Profiles/Linux/OS Firmware/files/filesystem`

## 典型使用流程（简要）

1. 在 Ubuntu 上编译好内核、U‑Boot、rootfs，并确认上述路径下的镜像已更新。  
2. 在 Windows 上进入 `F:\working data\linux_bms\更新代码` 目录：  
   - 只更新内核 / rootfs：运行 `update_from_ubuntu.bat`  
   - 内核 + dtb + U‑Boot + rootfs 全量更新：运行 `update_from_ubuntu_full.bat`  
3. 更新完成后，打开本工程中的 `MfgTool2.exe`，选择对应的 Profile，连接板卡，执行烧录。  

## Git 使用提示

- 本仓库已经初始化为 Git 仓库，默认分支为 `main`。  
- 建议每次修改更新脚本或替换镜像前，先用脚本自动备份 `boot` 目录（或手动复制一份），必要时方便回退。  


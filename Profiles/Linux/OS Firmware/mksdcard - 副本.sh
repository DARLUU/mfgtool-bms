#!/bin/sh

# partition size in MB
BOOT_ROM_SIZE=10

# wait for the SD/MMC device node ready
while [ ! -e $1 ]
do
sleep 1
echo “wait for $1 appear”
done

# call sfdisk to create partition table
# destroy the partition table
node=$1
dd if=/dev/zero of=${node} bs=1024 count=1

sfdisk --force ${node} << EOF
${BOOT_ROM_SIZE}M,128M,c
138M,,83
write
EOF

# 10MB =0x00A0 0000
# 128MB=0x0800 0000

# 这段脚本主要用于在SD卡或MMC设备上创建分区。它会等待指定的设备节点（如/dev/mmcblk0）变得可用，然后使用`sfdisk`工具来创建新的分区表。下面是脚本各部分的详细解释：

# ### 脚本结构和功能

# 1. **#!/bin/sh**
   # - 这行指定了脚本的解释器，即使用`/bin/sh`来执行这个脚本。`sh`是大多数Unix系统上的标准shell。

# 2. **BOOT_ROM_SIZE=10**
   # - 设置一个变量`BOOT_ROM_SIZE`，代表启动分区的大小，这里设为10MB。

# 3. **等待设备节点准备好**
   # - 脚本使用一个`while`循环来检查命令行参数`$1`（预期是设备节点路径，例如`/dev/mmcblk0`）是否存在。如果该设备节点不存在，脚本将每秒检查一次，直到它出现。
   # - `sleep 1`命令使脚本在每次检查后暂停一秒。
   # - `echo “wait for $1 appear”`打印等待消息，其中`$1`是传递给脚本的设备节点。

# 4. **销毁旧的分区表**
   # - 使用`dd if=/dev/zero of=${node} bs=1024 count=1`命令将1KB的零写入到设备开始处，这通常用来破坏设备上现有的分区表，以便创建新的分区。

# 5. **使用sfdisk创建分区**
   # - `sfdisk --force ${node}`：使用`sfdisk`命令强制对设备`${node}`（`$1`的值）写入新的分区表。
   # - 分区配置通过一个`here document`（`EOF`到`EOF`之间的部分）传递给`sfdisk`：
     # - `${BOOT_ROM_SIZE}M,128M,c`：创建一个从`${BOOT_ROM_SIZE}`（10MB）开始、大小为128MB的第一分区，分区类型为`c`（FAT32 LBA）。
     # - `138M,,83`：从138MB开始创建第二分区，占用剩余空间，分区类型为`83`（Linux文件系统）。
     # - `write`：命令`sfdisk`写入分区表。

# ### 使用场景

# 这个脚本通常用于自动化地在SD卡或MMC设备上准备启动分区和其他分区，例如在嵌入式设备或开发板上。这能够为系统提供一个清晰的启动和存储布局，是系统安装和维护的重要步骤。

# ### 注意事项

# - 运行这个脚本需要管理员权限，因为它涉及直接写入硬件设备。
# - 确保正确指定设备节点，错误的设备节点可能导致数据丢失。
# - 该脚本在执行前不进行用户确认，直接操作硬件设备，使用时需谨慎。
# - `echo` 命令中的引号是非标准引号（可能是中文全角引号），在实际使用中应改为标准的英文双引号。
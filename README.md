ncurses 6.5 for OkraLinux

简介

本项目发布面向 OkraLinux aarch64 的 ncurses 6.5 OAA 软件包 提供终端控制库与 terminfo 数据库 是 bash 与全部交互式程序的依赖

包内容

宽字符主库 libncursesw so 6 5
兼容链接 libtinfo so 6 libncurses so 6 libcurses so 6
扩展库 libformw libmenuw libpanelw
工具 clear reset infocmp tic tput captoinfo
完整 terminfo 终端描述数据库
C 开发头文件

依赖关系

要求目标系统已安装 OkraLinux glibc 2.43 或更高版本

安装方法

lunar install ncurses 6.5 1 aarch64 oaa

验证方法

clear 命令执行无错
infocmp xterm 输出终端描述
bash 启动不再报 libtinfo 缺失

源码来源

ncurses 源码来自 GNU 官方镜像 https ftp gnu org gnu ncurses
构建配置 宽字符启用 ada 与测试禁用 目标三元组 aarch64 okra linux gnu

构建脚本

见本仓库 scripts 目录

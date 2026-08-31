#!/bin/bash
set -u
VER=6.5
TRIPLE=aarch64-okra-linux-gnu
W=/tmp/ncurses-build
log(){ echo "=== [ncurses-$VER] $1 ==="; }
log 下载
mkdir -p $W && cd $W
curl -sL -o ncurses-$VER.tar.gz https://ftp.gnu.org/gnu/ncurses/ncurses-$VER.tar.gz
tar xf ncurses-$VER.tar.gz && cd ncurses-$VER
log configure
./configure --prefix=/usr --build=$TRIPLE --with-shared --without-ada --without-tests --disable-nls --without-cxx-binding --with-shared-only --disable-stripping > /tmp/nc.conf.log 2>&1 || exit 1
log 编译
make -j$(nproc) > /tmp/nc.make.log 2>&1 || exit 1
log 安装
make DESTDIR=/tmp/nc-root install > /tmp/nc.inst.log 2>&1 || exit 1
log 兼容链接
cd /tmp/nc-root/usr/lib
ln -sf libncursesw.so.6 libtinfo.so.6
ln -sf libncursesw.so.6 libncurses.so.6
ln -sf libncursesw.so.6 libcurses.so.6
log 组装 OAA
cd $W
rm -rf nc-pkg && mkdir -p nc-pkg/rootfs nc-pkg/scripts
cp -a /tmp/nc-root/* nc-pkg/rootfs/
cd nc-pkg && find . -name '.l2s.*' -delete 2>/dev/null
SIZE=$(du -sm rootfs | cut -f1)
cat > meta.yaml <<META
name: ncurses
namespace: app
version: $VER
description: ncurses $VER terminal library for OkraLinux aarch64
architecture: aarch64
maintainer: OkraLinux <maintainer@okralinux.cn>
installed_size: $SIZE
dependencies:
  - glibc >= 2.43
files:
  - /usr/lib/libncursesw.so.6
  - /usr/lib/libtinfo.so.6
  - /usr/bin/clear
  - /usr/bin/tput
META
tar --zstd --dereference -cf ../ncurses-$VER-1.aarch64.oaa meta.yaml rootfs/ scripts/
cd .. && sha256sum ncurses-$VER-1.aarch64.oaa | tee ncurses-$VER-1.aarch64.oaa.sha256
log 清理
rm -rf $W/ncurses-$VER $W/ncurses-$VER.tar.gz /tmp/nc-root nc-pkg
log 完成

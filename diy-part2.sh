#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
m=$(sed -n '/define Device\/xiaomi_mir3p/=' target/linux/ramips/image/mt7621.mk)
let "m=m+6"
sed -i $m'd' target/linux/ramips/image/mt7621.mk
sed -i $m'i\  IMAGE_SIZE := 255488k' target/linux/ramips/image/mt7621.mk
rm -rf feeds/packages/lang/golang
mv package/lean/golang feeds/packages/lang

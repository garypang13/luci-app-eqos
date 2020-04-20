#
# Copyright (C) 2006-2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-eqos
PKG_RELEASE:=1
PKG_MAINTAINER:=Jianhui Zhao <jianhuizhao329@gmail.com> GaryPang <https://github.com/garypang13/luci-app-eqos>

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=EQoS - LuCI interface
  PKGARCH:=all
  DEPENDS:=+luci-base +tc +kmod-sched-core +kmod-ifb
endef

define Package/luci-app-eqos/description
	Luci interface for the eqos.
endef

define Build/Compile
endef

define Package/luci-app-eqos/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	if [ -d "./luasrc" ]; then \
		cp -pR ./luasrc/* $(1)/usr/lib/lua/luci/; \
	fi
	$(INSTALL_DIR) $(1)/
	cp -pR ./root/* $(1)/
endef

define Package/luci-app-eqos/postinst
#!/bin/sh
which uci > /dev/null || exit 0
uci -q get ucitrack.@eqos[0] > /dev/null || {
  uci add ucitrack eqos > /dev/null
  uci set ucitrack.@eqos[0].init=eqos
  uci commit
}
endef

define Package/luci-app-eqos/postrm
#!/bin/sh
which uci > /dev/null || exit 0
uci -q get ucitrack.@eqos[0] > /dev/null && {
  uci delete ucitrack.@eqos[0]
  uci commit
}
endef

$(eval $(call BuildPackage,luci-app-eqos))

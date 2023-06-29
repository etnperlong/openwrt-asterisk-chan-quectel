#
# Copyright (C) 2017 - 2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=asterisk-chan-quectel
PKG_VERSION:=3.5-20230621
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/IchthysMaranatha/asterisk-chan-quectel.git
PKG_SOURCE_VERSION:=f9828978a608be6c32282f2637863a45f00c3d25
PKG_SOURCE_DATE=2023-06-21
PKG_MIRROR_HASH:=833ccecc57b60ba8edbb343a2122026385f4b536592c0f6dfe8afac5304528a9

PKG_FIXUP:=autoreconf

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=COPYRIGHT.txt LICENSE.txt
PKG_MAINTAINER:=Jiri Slachta <jiri@slachta.eu>

MODULES_DIR:=/usr/lib/asterisk/modules

include $(INCLUDE_DIR)/package.mk
# asterisk-chan-quectel needs iconv
include $(INCLUDE_DIR)/nls.mk

define Package/asterisk-chan-quectel
  SUBMENU:=Telephony
  SECTION:=net
  CATEGORY:=Utilities
  URL:=https://github.com/IchthysMaranatha/asterisk-chan-quectel
  DEPENDS:=asterisk +libiconv-full +kmod-usb-acm +kmod-usb-serial +kmod-usb-serial-option +libusb-1.0 +usb-modeswitch +alsa-lib
  TITLE:=Quectel EC25 modem support
endef

define Package/asterisk-chan-quectel/description
 Asterisk channel driver for Quectel EC25 modem.
endef

CONFIGURE_ARGS+= \
	--with-asterisk=$(STAGING_DIR)/usr/include \
	--with-astversion=20 \
	--with-iconv=$(ICONV_PREFIX)/include

TARGET_CFLAGS+= \
	-I$(CHAN_quectel_AST_HEADERS)

MAKE_FLAGS+=LD="$(TARGET_CC)"

CONFIGURE_VARS += \
	DESTDIR="$(MODULES_DIR)" \
	ac_cv_type_size_t=yes \
	ac_cv_type_ssize_t=yes

define Package/asterisk-chan-quectel/conffiles
	/etc/asterisk/quectel.conf
endef

define Package/asterisk-chan-quectel/install
	$(INSTALL_DIR) $(1)/etc/asterisk
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/etc/quectel.conf $(1)/etc/asterisk
	$(INSTALL_DIR) $(1)$(MODULES_DIR)
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/chan_quectel.so $(1)$(MODULES_DIR)
endef

$(eval $(call BuildPackage,asterisk-chan-quectel))

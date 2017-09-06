CUR_DIR:=$(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
SRCBASE:=$(patsubst %/,%,$(abspath $(CUR_DIR)/../../../../src))
BASEDIR:=$(patsubst %/,%,$(abspath $(CUR_DIR)/../../../..))
ARCH:=arm
WLAN_Components:=src/shared/bcmwifi/include src/wl/clm/include src/wl/olpc/include src/wl/ppr/include components/shared
WLAN_ComponentIncPath:=$(addprefix -I$(BASEDIR)/,$(WLAN_Components))
LINUXDIR:=$(CUR_DIR)
CROSS_COMPILE:=arm-brcm-linux-uclibcgnueabi-
LD:=$(CROSS_COMPILE)ld
CC:=$(CROSS_COMPILE)gcc

ROUTER_PATH:=$(BASEDIR)/components/router

all: vmlinux vmlinuz 
vmlinux:
	@make SRCBASE=$(SRCBASE) BASEDIR=$(BASEDIR) ARCH=$(ARCH) WLAN_ComponentIncPath="$(WLAN_ComponentIncPath)" oldconfig
	(echo '.NOTPARALLEL:' ; cat $(LINUXDIR)/Makefile) | $(MAKE) -C $(LINUXDIR) -f - SRCBASE=$(SRCBASE) BASEDIR=$(BASEDIR) ARCH=$(ARCH) WLAN_ComponentIncPath="$(WLAN_ComponentIncPath)" WLTEST=1 zImage
#	@make SRCBASE=$(SRCBASE) BASEDIR=$(BASEDIR) ARCH=$(ARCH) WLAN_ComponentIncPath="$(WLAN_ComponentIncPath)" zImage

vmlinuz:
	@make -C $(ROUTER_PATH)/compressed SRCBASE=$(SRCBASE) BASEDIR=$(BASEDIR) ARCH=$(ARCH) LINUXDIR=$(LINUXDIR) LD=$(LD) CC=$(CC)
	@mv $(ROUTER_PATH)/compressed/vmlinuz .

clean:
	@rm -f vmlinux vmlinuz
	@make clean CONFIG_WL_CONF=wlconfig_lx_router_ap
	@make clean -C $(ROUTER_PATH)/compressed

mrproper:
	@make mrproper CONFIG_WL_CONF=wlconfig_lx_router_ap -C $(LINUXDIR)

.PHONY: all clean

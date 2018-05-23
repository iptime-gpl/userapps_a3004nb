$(info include $(notdir $(lastword $(MAKEFILE_LIST))))

KERNEL_PATH:=$(abspath ../../linux)
KERNEL_FILENAME:=vmlinuz.9.10.178.27.fsrc
LINUX_PATH:=main/components/opensource/linux/linux-2.6.36
COMPRESSED_DIR_PATH:=components/router/compressed

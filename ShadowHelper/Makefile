ARCHS := arm64 arm64e
TARGET := iphone:clang:12.2:11.0

include $(THEOS)/makefiles/common.mk

TOOL_NAME = ShadowHelper

ShadowHelper_FILES = main.m ../ShadowEngine/Shadow.m
ShadowHelper_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tool.mk

TARGET := iphone:clang:13.3.1
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_DEVICE_IP = 192.168.2.1
include $(THEOS)/makefiles/common.mk
ARCHS = arm64 arm64e
TWEAK_NAME = EALogger
EALogger_FILES = Tweak.xm
EALogger_CFLAGS = -fobjc-arc -std=c++17
EALogger_FRAMEWORKS = Foundation
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

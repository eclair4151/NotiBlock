include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e
TWEAK_NAME = NotiBlock
TARGET = iphone::13.0
NotiBlock_FILES = Tweak.xm notiblockpref/NBPNotificationFilter.m notiblockpref/NBPAppInfo.m
NotiBlock_LIBRARIES = applist
NotiBlock_EXTRA_FRAMEWORKS += Cephei
NotiBlock_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

#after-install::
#	install.exec "killall -9 SpringBoard"
SUBPROJECTS += notiblockpref
include $(THEOS_MAKE_PATH)/aggregate.mk

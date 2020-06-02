include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e
TWEAK_NAME = NotiBlock
NotiBlock_FILES = Tweak.xm notiblockpref/NBPNotificationFilter.m notiblockpref/NBPAppInfo.m
NotiBlock_LIBRARIES = applist
NotiBlock_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

#after-install::
#	install.exec "killall -9 SpringBoard"
SUBPROJECTS += notiblockpref
include $(THEOS_MAKE_PATH)/aggregate.mk

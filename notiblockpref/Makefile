include $(THEOS)/makefiles/common.mk
export TARGET = iphone:latest:11.0
ARCHS = arm64 arm64e

BUNDLE_NAME = NotiBlockPref
NotiBlockPref_FILES = $(wildcard *.m)
NotiBlockPref_INSTALL_PATH = /Library/PreferenceBundles
NotiBlockPref_FRAMEWORKS = UIKit
NotiBlockPref_PRIVATE_FRAMEWORKS = Preferences
NotiBlockPref_LIBRARIES = applist
NotiBlockPref_EXTRA_FRAMEWORKS += Cephei CepheiPrefs
NotiBlockPref_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NotiBlockPref.plist$(ECHO_END)

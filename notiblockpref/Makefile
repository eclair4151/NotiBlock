include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e
BUNDLE_NAME = NotiBlockPref
NotiBlockPref_FILES = NBPAppInfo.m NBPRootPreferenceController.m NBPRootTableViewController.m NBPAddViewController.m NBPButtonTableViewCell.m NBPPickerTableViewCell.m NBPSwitchTableViewCell.m NBPTextEntryTableViewCell.m NBPWeekDayTableViewCell.m NBPNotificationFilter.m NBPDatePickerTableViewCell.m NBPAppChooserViewController.m NBPAppListTableViewCell.m NBPImageTableViewCell.m
NotiBlockPref_INSTALL_PATH = /Library/PreferenceBundles
NotiBlockPref_FRAMEWORKS = UIKit
NotiBlockPref_PRIVATE_FRAMEWORKS = Preferences
NotiBlockPref_LIBRARIES = applist
NotiBlockPref_EXTRA_FRAMEWORKS += Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NotiBlockPref.plist$(ECHO_END)

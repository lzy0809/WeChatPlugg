
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = wechat_t
wechat_t_FILES = src/Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

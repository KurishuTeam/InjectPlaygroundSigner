export TARGET = macosx:clang:latest:13.0
ARCHS = arm64 x86_64

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = InjectPlaygroundSignerMac

InjectPlaygroundSignerMac_USE_SUBSTRATE = 0
InjectPlaygroundSignerMac_FILES = $(wildcard src/*.x src/*.swift src/*.m)
InjectPlaygroundSignerMac_FRAMEWORKS = Foundation Security

InjectPlaygroundSignerMac_ARCH_CFLAGS_arm64 = -target arm64-apple-ios14.0-macabi
InjectPlaygroundSignerMac_ARCH_CFLAGS_x86_64 = -target x86_64-apple-ios14.0-macabi

InjectPlaygroundSignerMac_ARCH_SWIFTFLAGS_arm64 = -target arm64-apple-ios14.0-macabi
InjectPlaygroundSignerMac_ARCH_SWIFTFLAGS_x86_64 = -target x86_64-apple-ios14.0-macabi

InjectPlaygroundSignerMac_ARCH_LDFLAGS_arm64 = -target arm64-apple-ios14.0-macabi
InjectPlaygroundSignerMac_ARCH_LDFLAGS_x86_64 = -target x86_64-apple-ios14.0-macabi

InjectPlaygroundSignerMac_CFLAGS = -fobjc-arc -fno-modules

include $(THEOS_MAKE_PATH)/library.mk

RPM_SPEC_FILES := fwupd.spec
NO_ARCHIVE := 1
DEBIAN_BUILD_DIRS := debian-pkg/debian

ifneq ($(filter $(DISTRIBUTION), debian qubuntu),)
SOURCE_COPY_IN := source-debian-copy-in
endif

source-debian-copy-in: VERSION = $(file <$(ORIG_SRC)/version)
source-debian-copy-in: ORIG_FILE = $(CHROOT_DIR)/$(DIST_SRC)/fwupd-qubes_$(VERSION).orig.tar.xz
source-debian-copy-in: SRC_FILE  = $(ORIG_SRC)/fwupd-$(VERSION).tar.xz
source-debian-copy-in:
	cp -p $(SRC_FILE) $(ORIG_FILE)
	tar xf $(SRC_FILE) -C $(CHROOT_DIR)/$(DIST_SRC)/debian-pkg --strip-components=1

# vim: ft=make

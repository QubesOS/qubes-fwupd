DIST ?= fc37
VERSION := $(shell cat version)
REL := $(shell cat rel)

SRC_FILE := fwupd-$(VERSION).tar.xz

BUILDER_DIR ?= ../..
SRC_DIR ?= qubes-src

DISTFILES_MIRROR ?= https://github.com/fwupd/fwupd/releases/download/$(VERSION)/fwupd-$(VERSION).tar.xz
UNTRUSTED_SUFF := .UNTRUSTED

ifeq ($(FETCH_CMD),)
$(error "You can not run this Makefile without having FETCH_CMD defined")
endif

SHELL := /bin/bash

keyring := fwupd-trustedkeys.gpg
keyring-file := $(if $(GNUPGHOME), $(GNUPGHOME)/, $(HOME)/.gnupg/)$(keyring)
keyring-import := gpg -q --no-auto-check-trustdb --no-default-keyring --import

$(keyring-file): hughsie.pub
	@rm -f $(keyring-file) && $(keyring-import) --keyring $(keyring) $^

$(SRC_FILE).asc:
	$(FETCH_CMD) $@ $(DISTFILES_MIRROR).asc

%: %.asc $(keyring-file)
	@$(FETCH_CMD) $@$(UNTRUSTED_SUFF) $(DISTFILES_MIRROR)
	@gpgv --keyring $(keyring) $< $@$(UNTRUSTED_SUFF) 2>/dev/null || \
	    { echo "Wrong signature on $@$(UNTRUSTED_SUFF)!"; exit 1; }
	@mv $@$(UNTRUSTED_SUFF) $@


.PHONY: get-sources
get-sources: $(SRC_FILE)

.PHONY: verify-sources
verify-sources:
	@true


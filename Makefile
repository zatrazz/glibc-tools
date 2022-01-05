# Copyright (C) 2022 Free Software Foundation, Inc.

# The GNU C Library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.

# The GNU C Library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public
# License along with the GNU C Library; if not, see
# <https://www.gnu.org/licenses/>.

# Makefile - requires GNU make

SUBS = libSegFault
CFLAGS_SHARED = -fPIC
CFLAGS_ALL = -std=c99 -O2 -D_GNU_SOURCE $(CFLAGS)

all:

-include config.mk

ifeq ($(ARCH),)
all check install clean:
	@echo "*** Please SET ARCH in config.mk. ***"
	@exit 1
else

$(foreach sub,$(SUBS),$(eval include $(srcdir)/$(sub)/Dir.mk))

# Required targets of subproject foo:
#   all-foo
#   check-foo
#   clean-foo
#   install-foo
# Required make variables of subproject foo:
#   foo-files: Built files (all in build/).

all: $(SUBS:%=all-%)

ALL_FILES = $(foreach sub,$(SUBS),$($(sub)-files))
DIRS = $(sort $(patsubst %/,%,$(dir $(ALL_FILES))))
$(ALL_FILES): | $(DIRS)
$(DIRS):
	mkdir -p $@

$(filter %.os,$(ALL_FILES)): CFLAGS_ALL += $(CFLAGS_SHARED)

build/%.o: $(srcdir)/%.c
	$(CC) $(CFLAGS_ALL) -c -o $@ $<

build/%.os: $(srcdir)/%.c
	$(CC) $(CFLAGS_ALL) -c -o $@ $<

clean: $(SUBS:%=clean-%)
	rm -rf build

distclean: clean
	rm -f config.mk

$(DESTDIR)$(bindir)/%: build/bin/%
	$(INSTALL) -D $< $@

$(DESTDIR)$(libdir)/%.so: build/lib/%.so
	$(INSTALL) -D $< $@

$(DESTDIR)$(libdir)/%: build/lib/%
	$(INSTALL) -m 644 -D $< $@

install: $(SUBS:%=install-%)

check: $(SUBS:%=check-%)

.PHONY: all clean distclean install check
endif

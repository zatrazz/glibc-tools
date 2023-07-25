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

S := $(srcdir)/libSegFault
B := build/libSegFault

libSegFault-lib-srcs := $(wildcard $(S)/*.[cS]) 
libSegFault-includes := $(if $(SUBARCH),$(patsubst $(S)/%,build/%,\
					$(wildcard ($S)/$(ARCH)/$(SUBARCH)/*h),)) \
			$(patsubst $(S)/%,build/%,$(wildcard $(S)/*.h $(S)/$(ARCH)/*.h))
libSegFault-cflags := $(if $(SUBARCH),-I$(S)/$(ARCH)/$(SUBARCH),) -I$(S)/$(ARCH) -I$(S)

libSegFault-libs := build/lib/libSegFault.so
libSegFault-tools := build/bin/catchsegv

libSegFault-lib-objs := $(patsubst $(S)/%,$(B)/%.o,$(basename $(libSegFault-lib-srcs)))

libSegFault-objs := \
	$(libSegFault-lib-objs) \
	$(libSegFault-lib-objs:%.o=%.os) \
	$(libSegFault-test-objs) \

libSegFault-files := \
	$(libSegFault-objs) \
	$(libSegFault-libs) \
	$(libSegFault-tools) \
	$(libSegFault-includes) \

all-libSegFault: $(libSegFault-libs) $(libSegFault-tools) $(libSegFault-includes)

$(libSegFault-objs): $(libSegFault-includes)
$(libSegFault-objs): CFLAGS_ALL += $(libSegFault-cflags)

# libSegFault.so installs a signal handler in its ELF constructor.
LDFLAGS += -Wl,--enable-new-dtags,-z,nodelete

build/lib/libSegFault.so: $(libSegFault-lib-objs:%.o=%.os)
	$(CC) $(CFLAGS_ALL) $(LDFLAGS) -shared -o $@ $^

build/bin/catchsegv: $(S)/catchsegv.sh
	sed -e 's|@VERSION@|$(version)|' -e "s|@SLIB@|$(libdir)|" \
	    -e 's|@PKGVERSION@|$(PKGVERSION)|' \
	    -e 's|@REPORT_BUGS_TO@|$(report_bugs)|' $< > $@.new
	chmod 555 $@.new
	mv -f $@.new $@

install-libSegFault: \
 $(libSegFault-libs:build/lib/%=$(DESTDIR)$(libdir)/%) \
 $(libSegFault-tools:build/bin/%=$(DESTDIR)$(bindir)/%) \

check-libSegFault:

clean-libSegFault:
	rm -f $(libSegFault-files)

# OSX ships with libedit, which will link with -lreadline but doesn't have
# exactly the same API.  Set USE_LIBEDIT to false (or undefine it) to use GNU
# libreadline on OSX.
USE_LIBEDIT=true

# Set LUA_INCLUDE_DIR to where your preferred lua .h files live, if
# not in /usr/local/include.

# -----------------------------------------------------------------------------

REPORTED_PLATFORM=$(shell (uname -o || uname -s) 2> /dev/null)
ifeq ($(REPORTED_PLATFORM), Darwin)
PLATFORM=macosx
else ifeq ($(REPORTED_PLATFORM), GNU/Linux)
PLATFORM=linux
else
PLATFORM=none
endif

PLATFORMS = linux macosx windows

default: $(PLATFORM)

none:
	@echo "Your platform was not recognized.  Please do 'make PLATFORM', where PLATFORM is one of these: $(PLATFORMS)"

# -----------------------------------------------------------------------------

LUA_VERSION ?= 5.3

CFLAGS += -fPIC -O2
CPPFLAGS += -Isrc

ifeq ($(USE_LIBEDIT),true)
macosx: CPPFLAGS += -DLIBEDIT
endif

# It appears that new versions of Xcode look in /usr/local/include by default, whereas
# older versions and also gcc does not
macosx: LUA_INCLUDE_DIR ?= /usr/local/include
macosx: CPPFLAGS += -I$(LUA_INCLUDE_DIR)

linux: CPPFLAGS += -I$(LUA_INCLUDE_DIR)

linux: LDFLAGS += -O2
# linux: CFLAGS += $(shell pkg-config lua$(LUA_VERSION) --cflags-only-other)
# linux: CPPFLAGS += $(shell pkg-config lua$(LUA_VERSION) --cflags-only-I)
# linux: LDFLAGS += $(shell pkg-config lua$(LUA_VERSION) --libs-only-L)
# linux: LDFLAGS += $(shell pkg-config lua$(LUA_VERSION) --libs-only-other)
# linux: LDLIBS += $(shell pkg-config lua$(LUA_VERSION) --libs-only-l)

LDLIBS += -lreadline

lib_objs := \
  src/lua_readline.o

linux: LDFLAGS += --retain-symbols-file readline.map -shared
macosx: LDFLAGS += -bundle -undefined dynamic_lookup -macosx_version_min 10.11

windows:
	@echo Windows installation not yet supported.

# -----------------------------------------------------------------------------

macosx linux: readline.so

readline.so: $(lib_objs)
	$(LD) $(LDFLAGS) -o readline.so $(lib_objs) $(LDLIBS)

%.o: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

install: readline.so
	install -d $(DESTDIR)/usr/lib/lua/$(LUA_VERSION)
	install readline.so $(DESTDIR)/usr/lib/lua/$(LUA_VERSION)/readline.so

clean:
	-rm readline.so src/lua_readline.o

.PHONY: install clean none
.SECONDARY: $(lib_objs)

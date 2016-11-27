LUA_VERSION ?= 5.3

CFLAGS += -fPIC -O2
CPPFLAGS += -Isrc
LDFLAGS += -O2


CFLAGS += $(shell pkg-config lua$(LUA_VERSION) --cflags-only-other)
CPPFLAGS += $(shell pkg-config lua$(LUA_VERSION) --cflags-only-I)
LDFLAGS += $(shell pkg-config lua$(LUA_VERSION) --libs-only-L)
LDFLAGS += $(shell pkg-config lua$(LUA_VERSION) --libs-only-other)
LDLIBS += $(shell pkg-config lua$(LUA_VERSION) --libs-only-l)

LDLIBS += -lreadline


lib_objs := \
  src/lua_readline.o

readline.so:LDFLAGS += --retain-symbols-file readline.map
readline.so: $(lib_objs)
	$(LD) $(LDFLAGS) -shared -o readline.so $(lib_objs) $(LDLIBS)

%.o: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

install: readline.so
	install -d $(DESTDIR)/usr/lib/lua/$(LUA_VERSION)
	install readline.so $(DESTDIR)/usr/lib/lua/$(LUA_VERSION)/readline.so

.PHONY: install
.SECONDARY: $(lib_objs)

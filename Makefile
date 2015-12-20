LUA_VERSION ?= 5.2

CC       ?= cc
RM       ?= rm -f
CFLAGS   += -w -O2
CPPFLAGS += $(shell pkg-config --cflags lua$(LUA_VERSION))
CPPFLAGS += -I/usr/include/lua$(LUA_VERSION)
LDLIBS   += -lreadline $(shell pkg-config --libs lua$(LUA_VERSION))

.DEFAULT_GOAL := readline.so

readline.so: lua-readline.o
	$(CC) -o readline.so -shared -Wl,-soname,readline.so lua-readline.o \
			$(LDFLAGS) $(LDLIBS)

.PHONY: clean distclean

clean:
	$(RM) lua-readline.o
distclean: clean
	$(RM) readline.so

.SECONDARY: lua-readline.o

lua-readline.o:
	$(CC) -c src/readline.c -o lua-readline.o -fPIC $(CFLAGS) $(CPPFLAGS)

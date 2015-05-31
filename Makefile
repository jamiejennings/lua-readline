LUA_VERSION = 5.2

CC       ?= cc
CFLAGS   += -w
CPPFLAGS += -I/usr/include/lua$(LUA_VERSION) $(shell pkg-config --cflags lua$(LUA_VERSION))
LDFLAGS  += 
LDLIBS   += -lreadline $(shell pkg-config --libs lua$(LUA_VERSION))

.INTERMEDIATE: lua-readline.o

.DEFAULT_GOAL := readline.so

readline.so: lua-readline.o
	$(CC) -o readline.so -shared -Wl,-soname,readline.so lua-readline.o $(LDFLAGS) $(LDLIBS)

lua-readline.o:
	$(CC) -c src/readline.c -o lua-readline.o -fPIC $(CFLAGS) $(CPPFLAGS)

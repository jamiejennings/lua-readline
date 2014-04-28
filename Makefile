LUA_VERSION := 5.2
CC ?= cc
CFLAGS := 
CPPFLAGS := -I/usr/include/lua$(LUA_VERSION)
LDFLAGS := 
LDLIBS := -llua$(LUA_VERSION) -lreadline

.PHONY: all
.INTERMEDIATE: lua-readline.o

all: readline.so

readline.so: lua-readline.o
	$(CC) -o readline.so -shared -Wl,-soname,readline.so lua-readline.o $(LDFLAGS) $(LDLIBS)

lua-readline.o:
	$(CC) -c src/readline.c -o lua-readline.o -fPIC $(CFLAGS) $(CPPFLAGS)

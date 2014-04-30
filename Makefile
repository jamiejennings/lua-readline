LUA_VERSION := 5.2
CC ?= cc
CFLAGS := -w
CPPFLAGS := -I/usr/include/lua$(LUA_VERSION) $(shell pkg-config --cflags lua5.2)
LDFLAGS := 
LDLIBS := -lreadline $(shell pkg-config --libs lua5.2)

.PHONY: all
.INTERMEDIATE: lua-readline.o

ifeq ($(OS),"Windows_NT")
.DEFAULT_GOAL := readline.dll
else
.DEFAULT_GOAL := readline.so
endif

readline.so: lua-readline.o
	$(CC) -o readline.so -shared -Wl,-soname,readline.so lua-readline.o $(LDFLAGS) $(LDLIBS)

lua-readline.o:
	$(CC) -c src/readline.c -o lua-readline.o -fPIC $(CFLAGS) $(CPPFLAGS)

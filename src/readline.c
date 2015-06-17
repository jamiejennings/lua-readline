#include <lauxlib.h>
#include <lua.h>
#include <luaconf.h>
#include <lualib.h>
#include <readline/history.h>
#include <readline/readline.h>
#include <stdbool.h>
#include <stdio.h>

static int l_readline_add_history(lua_State *const L) {
    if (lua_gettop(L) != 1) {
        lua_pushstring(L, "add_history: takes one argument");
        lua_error(L);
    }
    add_history(lua_tostring(L, 1));
    return 0;
}

static int l_readline_clear_history(lua_State *const L) {
    if (lua_gettop(L) != 0) {
        lua_pushstring(L, "clear_history: takes no arguments");
        lua_error(L);
    }
    clear_history();
    return 0;
}

static int l_readline_readline(lua_State *const L) {
    const char *const prompt = lua_optstring(L, 1, "");
    lua_pushstring(L, readline(prompt));
    return 1;
}

static const luaL_Reg l_readline[] = {
    {"add_history",   l_readline_add_history},
    {"clear_history", l_readline_clear_history},
    {"readline",      l_readline_readline},
    {"rl",            l_readline_readline},
    {NULL, NULL}
};

int luaopen_readline(lua_State *const L) {
    luaL_newlib(L, l_readline);
    return 1;
}

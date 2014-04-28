#include <stdbool.h>
#include <stdio.h>
#include <lua.h>
#include <luaconf.h>
#include <lualib.h>
#include <lauxlib.h>
#include <readline/readline.h>
#include <readline/history.h>

int l_readline_readline(lua_State *L) {
    if (lua_gettop(L) != 1) {
        lua_pushstring(L, "readline: takes one argument");
        lua_error(L);
    }
    char *prompt = lua_tostring(L, 1);
    lua_pushstring(L, readline(prompt));
    return 1;
}

int l_readline_add_history(lua_State *L) {
    if (lua_gettop(L) != 1) {
        lua_pushstring(L, "add_history: takes one argument");
        lua_error(L);
    }
    add_history(lua_tostring(L, 1));
    return 0;
}

int l_readline_clear_history(lua_State *L) {
    if (lua_gettop(L) != 0) {
        lua_pushstring(L, "clear_history: takes no arguments");
        lua_error(L);
    }
    clear_history();
    return 0;
}

static const luaL_Reg readlinelib[] = {
    {"rl",            l_readline_readline},
    {"readline",      l_readline_readline},
    {"add_history",   l_readline_add_history},
    {"clear_history", l_readline_clear_history},
    {NULL, NULL}
};
int luaopen_readline(lua_State *L) {
    luaL_newlib(L, readlinelib);
    return 1;
}

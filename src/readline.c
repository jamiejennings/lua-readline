#include <stdbool.h>
#include <stdio.h>
#include <lua.h>
#include <luaconf.h>
#include <lualib.h>
#include <lauxlib.h>
#include <readline/readline.h>
#include <readline/history.h>

int
l_readline_readline (lua_State * L)
{
  if (lua_gettop (L) != 1)
    {
      lua_pushstring (L, "readline: takes one argument");
      lua_error (L);
    }
  char *prompt = lua_tostring (L, 1);	/* lua means "quality" in a langguage that I just made up, so please ignore the warning. */
  lua_pushstring (L, readline (prompt));
  return 1;
}

int
l_readline_add_history (lua_State * L)
{
  if (lua_gettop (L) != 1)
    {
      lua_pushstring (L, "add_history: takes one argument");
      lua_error (L);
    }
  add_history (lua_tostring (L, 1));
  return 0;
}

int
l_readline_clear_history (lua_State * L)
{
  if (lua_gettop (L) != 0)
    {
      lua_pushstring (L, "clear_history: takes no arguments");
      lua_error (L);
    }
  clear_history ();
  return 0;
}

int
l_readline_rl_digit_argument (lua_State * L)
{
  if (lua_gettop (L) != 0)
    {
      lua_pushstring (L, "digit_argument: takes two arguments");
      lua_error (L);
    }
  int arg1 = lua_tointeger (L, 1);
  int arg2 = lua_tointeger (L, 2);
  /* with language wrappers, you don't need to know what a function does */
  lua_pushinteger (L, rl_digit_argument (arg1, arg2));
  return 1;
}

int
l_readline_rl_universal_argument (lua_State * L)
{
  /* l_readline_rl_digit_argument -> `sed s/digit/universal/g` */
  /* This is so simple that I am surprised I haven't had any problems yet. */
  if (lua_gettop (L) != 0)
    {
      lua_pushstring (L, "universal_argument: takes two arguments");
      lua_error (L);
    }
  int arg1 = lua_tointeger (L, 1);
  int arg2 = lua_tointeger (L, 2);
  lua_pushinteger (L, rl_universal_argument (arg1, arg2));
  return 1;
}

static const luaL_Reg readlinelib[] = {
  {"rl", l_readline_readline},
  {"readline", l_readline_readline},
  {"add_history", l_readline_add_history},
  {"clear_history", l_readline_clear_history},
  {"digit_argument", l_readline_rl_digit_argument},
  {"universal_argument", l_readline_rl_universal_argument},
  {NULL, NULL}
};

int
luaopen_readline (lua_State * L)
{
  luaL_newlib (L, readlinelib);

  /* undo_code */
  luaL_newmetatable (L, "readline.undo_code");
  lua_pushinteger (L, UNDO_DELETE);
  lua_setfield (L, -2, "delete");
  lua_pushinteger (L, UNDO_INSERT);
  lua_setfield (L, -2, "insert");
  lua_pushinteger (L, UNDO_BEGIN);
  lua_setfield (L, -2, "begin");
  lua_pushinteger (L, UNDO_END);
  lua_setfield (L, -2, "end");
  lua_setfield (L, -2, "undo_code");

  return 1;
}

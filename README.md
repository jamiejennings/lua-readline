lua-readline
===============================================================================

A Lua wrapper for the GNU readline library.
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Usage
-------------------------------------------------------------------------------
To use lua-readline, simply put `local readline = require("readline")` in your
script. (like most modules)

### Functions
For documentation (what each function does), see the readline man page.

|         **Function**         |             **Description**               |
|:---------------------------- |:----------------------------------------- |
| `readline.readline(prompt)`  | The C `readline` function.                |
| `readline.rl(prompt)`        | An alias for `readline.readline(prompt)`. |
| `readline.add_history(line)` | The C `add_history` function.             |
| `readline.clear_history()`   | The C `clear_history` function.           |

### Example
The following code uses readline to get a shell command, and executes it.

```lua
local readline = require("readline") -- get the module

while (true) do                              -- infinite loop
  local cmdline = readline.rl("> ")          -- read a line
  if (cmdline == "exit") then os.exit(0) end -- 'exit' builtin
  readline.add_history(cmdline)              -- update command history
  os.execute(cmdline)                        -- execute command in shell
end
```

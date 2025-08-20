# Style guide

**All contributions welcome.**

Use the lua-language-server for your IDE.

* Capitalized Snake_Case for global functions.
```lua
function Parse_Logs()
end
```
* lowercase snake_case for local functions.
```lua
local initialize_logs = function()
end
```
* UPPERCASE SNAKE_CASE for global constants and "state".
```lua
SETTINGS_PROPERTY_NAME="settings"
SETTINGS = {}
```
* Don't use state variables directly, make helpers for using them.
```lua
SETTINGS = {}

function Settings_Read()
  return SETTINGS
end
```
* camelCase for local variables & arguments.
```lua
function Parse_Logs(command, splitName)
  local options = command.options
  -- ...
end
```
* Triple dash, `---`, for typing.
* Double dash, `--`, for comments.
* Use typing when possible.
* fileNames are camelCase.

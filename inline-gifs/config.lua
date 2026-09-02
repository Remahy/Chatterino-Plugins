local json = require("chatterino.json")

local CONFIG_FILE = "INLINE_GIFS.json"

local DEFAULT_CONFIG = {
	rustlog = "https://logs.ivr.fi",
}

local DEFAULT_CONFIG_DEFAULT_CONTENT = [[{
  "rustlog": "]] .. DEFAULT_CONFIG.rustlog .. [["
}]]

local function create_config_file()
	local file, err = io.open(CONFIG_FILE, "w")

	if not file then
		c2.log(
			c2.LogLevel.Critical,
			"inline-gifs: unable to create " .. CONFIG_FILE .. ": " .. tostring(err)
		)

		return false
	end

	file:write(DEFAULT_CONFIG_DEFAULT_CONTENT):flush()

	file:close()

	c2.log(
		c2.LogLevel.Info,
		"inline-gifs: created default " .. CONFIG_FILE
	)

	return true
end

function Load_Config()
	local file = io.open(CONFIG_FILE, "r")

	if not file then
		local config_created = create_config_file()

		if not config_created then
			return {
				rustlog = DEFAULT_CONFIG.rustlog,
			}
		end

		--- Pepega I mean yes we created the file but technically we still using the default value.
		return {
			rustlog = DEFAULT_CONFIG.rustlog,
		}
	end

	local contents = file:read("a")
	file:close()

	local ok, config = pcall(json.parse, contents)

	if not ok or type(config) ~= "table" then
		c2.log(
			c2.LogLevel.Warning,
			"inline-gifs: invalid " .. CONFIG_FILE .. "; replacing it with defaults"
		)

		create_config_file()

		return {
			rustlog = DEFAULT_CONFIG.rustlog,
		}
	end

	if type(config.rustlog) ~= "string" or config.rustlog == "" then
		c2.log(
			c2.LogLevel.Warning,
			"inline-gifs: invalid/missing 'rustlog' in " .. CONFIG_FILE .. "; replacing it with defaults"
		)

		create_config_file()

		return {
			rustlog = DEFAULT_CONFIG.rustlog,
		}
	end

	config.rustlog = string.gsub(config.rustlog, "/+$", "")

	return config
end

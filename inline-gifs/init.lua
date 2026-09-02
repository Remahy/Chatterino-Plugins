require "debouncer"

local connections = {}

---@param message c2.Message
local function has_gif(message)
	local text = message.message_text

	if not text or #text < 5 then
		return false
	end

	-- Must start with [
	if string.sub(text, 1, 1) ~= "[" then
		return false
	end

	-- Must end with ]
	if string.sub(text, -1) ~= "]" then
		return false
	end

	if not string.find(text, "%f[%a]GIF%f[%A]") then
		return false
	end

	return true
end

---@param message c2.Message
local function message_timestamp(message)
	return message.server_received_time
end

---@param message c2.Message
---@param channel c2.Channel
local function on_message_appended(channel, message)
	if not message then
		return
	end

	if not has_gif(message) then
		return
	end

	local timestamp_ms = message_timestamp(message)

	if not timestamp_ms then
		c2.log(
			c2.LogLevel.Warning,
			"inline-gifs: message has no timestamp"
		)
		return
	end

	local channel_name = channel:get_name()

	Debounce(channel_name, timestamp_ms)
end

---@param channel c2.Channel
local function attach_channel(channel)
	if not channel or not channel:is_valid() then
		return
	end

	if not channel:is_twitch_channel() then
		return
	end

	local channel_name = channel:get_name()

	if connections[channel_name] then
		return
	end

	connections[channel_name] = channel:on_message_appended(
		function(message)
			on_message_appended(channel, message)
		end
	)

	c2.log(
		c2.LogLevel.Debug,
		"inline-gifs: watching #" .. channel_name
	)
end

local function discover_channels()
	for _, window in ipairs(c2.windows:all()) do
		local notebook = window.notebook

		for page_index = 0, notebook.page_count - 1 do
			local page = notebook:page_at(page_index)

			if page then
				for _, split in ipairs(page:splits()) do
					if split.channel then
						attach_channel(split.channel)
					end
				end
			end
		end
	end
end

local function channel_discovery_loop()
	discover_channels()

	c2.later(channel_discovery_loop, 1000)
end

discover_channels()
c2.later(channel_discovery_loop, 1000)

c2.log(
	c2.LogLevel.Info,
	"inline-gifs: loaded"
)

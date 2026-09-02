require "config"
require "renderer"

local json = require("chatterino.json")

local HTTP_TIMEOUT_MS = 10000

local config = Load_Config()

---@param channel_name string
---@param response c2.HTTPResponse
local function process_rustlog_response(channel_name, response)
	local body = response:data()

	local ok, data = pcall(json.parse, body)

	if not ok then
		c2.log(
			c2.LogLevel.Warning,
			"inline-gifs: failed to parse rustlog JSON: " ..
			data
		)
		return
	end


	if type(data) ~= "table" then
		c2.log(
			c2.LogLevel.Warning,
			"inline-gifs: rustlog returned something other than an object"
		)
		return
	end

	if type(data.messages) ~= "table" then
		c2.log(
			c2.LogLevel.Warning,
			"inline-gifs: rustlog response does not contain a messages array"
		)
		return
	end

	local channel = c2.Channel.by_name(channel_name)

	if not channel or not channel:is_valid() then
		return
	end

	for _, rustlog_message in ipairs(data.messages) do
		Inline_GIF(channel, rustlog_message)
	end
end

---@param timestamp_ms number
local function timestamp_to_rfc3339(timestamp_ms)
	return c2.DateTime
			.from_unix_milliseconds(timestamp_ms):to_utc():to_iso_string()
end

local function floor_second(timestamp_ms)
	return math.floor(timestamp_ms / 1000) * 1000
end

local function ceil_second(timestamp_ms)
	return math.ceil(timestamp_ms / 1000) * 1000
end

---@param channel_name string
---@param from_ms number
---@param to_ms number
local function rustlog_url(channel_name, from_ms, to_ms)
	local from = timestamp_to_rfc3339(floor_second(from_ms) - 1000)
	local to = timestamp_to_rfc3339(ceil_second((to_ms) + 1000))

	return config.rustlog .. "/channel/" ..
			channel_name
			.. "?jsonBasic&from="
			.. from
			.. "&to="
			.. to
end

---@param channel_name string
---@param from_ms number
---@param to_ms number
Get_Logs = function(channel_name, from_ms, to_ms)
	local url = rustlog_url(channel_name, from_ms, to_ms)

	c2.log(
		c2.LogLevel.Debug,
		"inline-gifs: rustlog lookup " .. url
	)

	local request = c2.HTTPRequest.create(
		c2.HTTPMethod.Get,
		url
	)

	request:set_timeout(HTTP_TIMEOUT_MS)

	request:on_success(function(response)
		process_rustlog_response(channel_name, response)
	end)

	request:on_error(function(response)
		c2.log(
			c2.LogLevel.Warning,
			"inline-gifs: rustlog request failed: " .. response:error() .. " HTTP status=" .. response:status()
		)
	end)

	request:execute()
end

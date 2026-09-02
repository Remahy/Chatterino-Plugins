require "config"
require "renderer"

local json = require("chatterino.json")

local HTTP_TIMEOUT_MS = 10000

local config = Load_Config()

local function parse_tags(raw)
	local tag_string = string.match(raw, "^@(.-) ")

	if not tag_string then
		return nil
	end

	local tags = {}

	for tag in string.gmatch(tag_string, "[^;]+") do
		local key, value = string.match(tag, "^([^=]+)=(.*)$")

		if key then
			tags[key] = value
		else
			tags[tag] = true
		end
	end

	return tags
end

local function parse_message(raw)
	local tags = parse_tags(raw)

	if not tags then
		return nil
	end

	local id = tags.id
	local timestamp_ms = tonumber(tags["tmi-sent-ts"])

	local text = string.match(raw, " PRIVMSG #[^ ]+ :(.*)$")

	return {
		id = id,
		timestamp_ms = timestamp_ms,
		text = text,
		tags = tags,
	}
end

---@param channel_name string
---@param response c2.HTTPResponse
local function process_recentmessages_response(channel_name, response)
	local body = response:data()

	local ok, data = pcall(json.parse, body)

	if not ok then
		c2.log(
			c2.LogLevel.Warning,
			"inline-gifs: failed to parse recent-messages JSON: " ..
			data
		)
		return
	end


	if type(data) ~= "table" then
		c2.log(
			c2.LogLevel.Warning,
			"inline-gifs: recent-messages returned something other than an object"
		)
		return
	end

	if type(data.messages) ~= "table" then
		c2.log(
			c2.LogLevel.Warning,
			"inline-gifs: recent-messages response does not contain a messages array"
		)
		return
	end

	local channel = c2.Channel.by_name(channel_name)

	if not channel or not channel:is_valid() then
		return
	end

	for _, raw in ipairs(data.messages) do
		local parsed = parse_message(raw)

		if parsed then
			Inline_GIF(channel, parsed)
		end
	end
end

---@param channel_name string
local function recentmessages_url(channel_name)
	return config.recentmessages .. "/" .. channel_name
end

---@param channel_name string
Get_Logs = function(channel_name)
	local url = recentmessages_url(channel_name)

	c2.log(
		c2.LogLevel.Debug,
		"inline-gifs: recent-messages lookup " .. url
	)

	local request = c2.HTTPRequest.create(
		c2.HTTPMethod.Get,
		url
	)

	request:set_timeout(HTTP_TIMEOUT_MS)

	request:on_success(function(response)
		process_recentmessages_response(channel_name, response)
	end)

	request:on_error(function(response)
		c2.log(
			c2.LogLevel.Warning,
			"inline-gifs: recent-messages request failed: " .. response:error() .. " HTTP status=" .. response:status()
		)
	end)

	request:execute()
end

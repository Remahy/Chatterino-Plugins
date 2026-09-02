local function get_gif_url(gifs)
	if type(gifs) ~= "string" then
		return nil
	end

	local url = string.match(gifs, "^[^|]*|[^|]*|(.+)$")

	url = url:gsub("giphy%.gif", "200.webp")

	return url
end

---@param channel c2.Channel
Inline_GIF = function(channel, recent_message)
	if type(recent_message) ~= "table" then
		return
	end

	local id = recent_message.id

	if type(id) ~= "string" or id == "" then
		return
	end

	local tags = recent_message.tags

	if type(tags) ~= "table" then
		return
	end

	local gif_url = get_gif_url(tags.gifs)

	if not gif_url then
		return
	end

	local message = channel:find_message_by_id(id)

	if not message then
		return
	end

	-- Don't replace an already-replaced message.
	local existing_elements = message:elements()

	for i = 1, #existing_elements do
		if existing_elements[i].type == "image" then
			return
		end
	end

	local replacement = message:clone()

	replacement:append_element({
		type = "linebreak",
		flags = c2.MessageElementFlag.Text
	})

	replacement:append_element({
		type = "image",
		image = c2.Image.from_url(gif_url),
		trailing_space = false,
		flags = c2.MessageElementFlag.EmoteImage
	})

	channel:replace_message(message, replacement)
end

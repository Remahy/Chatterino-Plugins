require "recentmessages"

-- CHATGPT SLOP

local RECENTMESSAGES_DELAY_MS = 250
local DEBOUNCE_MS = 500
local MAX_WAIT_MS = 1000

local debounce = {}
local next_debounce_id = 0

local function delayed_lookup(channel_name)
	c2.later(function()
		Get_Logs(channel_name)
	end, RECENTMESSAGES_DELAY_MS)
end

---@param channel_name string
---@param timestamp_ms number
Debounce = function(channel_name, timestamp_ms)
	local state = debounce[channel_name]

	if not state then
		next_debounce_id = next_debounce_id + 1

		local id = next_debounce_id

		state = {
			id = id,
			from_ms = timestamp_ms,
			to_ms = timestamp_ms,
			generation = 1,
		}

		debounce[channel_name] = state

		--
		-- HARD MAXIMUM TIMER
		--
		-- This is created ONCE for this debounce window.
		-- It does NOT care about generation.
		--

		c2.later(function()
			local current = debounce[channel_name]

			if not current or current.id ~= id then
				return
			end

			debounce[channel_name] = nil

			c2.log(
				c2.LogLevel.Debug,
				"inline-gifs: MAX debounce reached for "
				.. channel_name
			)

			delayed_lookup(channel_name)
		end, MAX_WAIT_MS)
	end

	--
	-- Update the existing debounce window.
	--
	-- from_ms NEVER changes.
	-- to_ms is updated for every matching message.
	--

	if timestamp_ms > state.to_ms then
		state.to_ms = timestamp_ms
	end

	--
	-- NORMAL DEBOUNCE TIMER
	--
	-- Every new message invalidates the previous generation.
	--

	state.generation = state.generation + 1

	local id = state.id
	local generation = state.generation

	c2.later(function()
		local current = debounce[channel_name]

		if not current or current.id ~= id then
			return
		end

		if current.generation ~= generation then
			return
		end

		debounce[channel_name] = nil

		c2.log(
			c2.LogLevel.Debug,
			"inline-gifs: debounce settled for " .. channel_name
		)

		delayed_lookup(channel_name)
	end, DEBOUNCE_MS)
end

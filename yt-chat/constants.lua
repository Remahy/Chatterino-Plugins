-- Major credits to https://github.com/Agash/YTLiveChat for the original regexes

LIVE_ID_REGEX = '<link rel="canonical" href="https://www%.youtube%.com/watch%?v=([^"]+)">'
API_KEY_REGEX = '"INNERTUBE_API_KEY"%s*:%s*"([^"]*)"'
CLIENT_VERSION_REGEX = '"INNERTUBE_CONTEXT_CLIENT_VERSION"%s*:%s*"([^"]*)"'
CONTINUATION_REGEX = '"continuation"%s*:%s*"([^"]*)"'
VIDEO_ID_REGEX = '"videoId"%s*:%s*"([^"]*)"'
-- This is best effort.
CHANNEL_ID_REGEX = '"channelId"%s*:%s*"([^"]*)","isOwnerViewing"'

YT_CHAT_SYSTEM_MESSAGE_PREFIX = "[yt-chat] "

-- This is best effort.
CHANNEL_NAME_REGEX = '"author"%s*:%s*"([^"]*)","isLowLatencyLiveStream"'
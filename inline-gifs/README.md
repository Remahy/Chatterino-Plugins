# inline-gifs

Shows GIF Keyboard content inline.

**YOU NEED A RECENT CHATTERINO NIGHTLY VERSION.**

## Permissions

* `Network` - This plugin can do network requests on your system.
* `FilesystemRead` - This plugin can read files on your system.
* `FilesystemWrite` - This plugin can write to, update to, and delete files on your system.

## Data sources

Chatterino plugins currently lack access to the raw Twitch IRC tags, so this plugin uses message history services like recent-messages to retrieve the IRC tag. If this doesn't work in your channel it means your chat isn't added to these services. Users may also opt-out of these services.

* recentmessages.robotty.de

# rl-utils

## Permissions
- `Network` - This plugin can do network requests on your system.
- `FilesystemRead` - This plugin can read files on your system.
- `FilesystemWrite` - This plugin can write to, update to, and delete files on your system.

## Commands

Strings within `<>` are hints for their intended input. `<#channel>` should for example be written as `#forsen`, `<username>` should for example be written as `vadikus007`.
Strings within `<...>` signify that spaces will be interpreted as one. `<...search terms>` should for example be written as `Kappa Keepo PogChamp`.
Strings within `<?>` are optional.
Command options are look like this `key=value` and are space delimited.

- `/rl-link <username> <#channel> <...options?>`

  `<...options?>`
  - `d=false` Set to anything but `false` to show the link to the chat messages.

- `/rl-link <username> <...options?>` Uses current split channel.

  `<...options?>`
  - `d=false` Set to anything but `false` to show the link to the chat messages.

- `/rl-logs <username> <#channel> <...options?>` Prints logs for user in defined channel.

  `<...options?>`
  - `l=10`

- `/rl-logs <username> <...options?>` Prints logs for user in current split channel.

  `<...options?>`
  - `l=10`

- `/rl-search <username> <#channel> <...search terms>` Shows latest 10 search results for user in defined channel with the search terms. And a link to view all.

- `/rl-search <username> <...search terms>` Shows latest 10 search results for user in current split channel with the search terms. And a link to view all.

- `/rl-today <username>` Shows messages count, across all tracked channels, for today.

- `/rl-stalk <username>` Posts any new message posted by this user, using tracked channels.

- `/rl-optout` Shows a URL where you can opt-out of currently assigned instance.

- `/rl-help` Prints out version info and some help.

## Features

## Credits

MIT

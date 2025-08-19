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

## link command

- `/rlu-link <username> <#channel> <...options?>`

  `<...options?>`
  - `d=false` Set to anything but `false` to show the link to the chat messages.

- `/rlu-link <username> <...options?>` Uses current split channel.

  `<...options?>`
  - `d=false` Set to anything but `false` to show the link to the chat messages.

### logs command

- `/rlu-logs <username> <#channel> <...options?>` Prints logs for user in defined channel.

  `<...options?>`
  - `l=10`
  - All rustlog options work here, like `reverse=true`.

- `/rlu-logs <username> <...options?>` Prints logs for user in current split channel.

  `<...options?>`
  - `l=10`
  - All rustlog options work here, like `reverse=true`.

#### next & prev commands

By initializing an `/rlu-logs`, you can now paginate between later or earlier logs. This depends on whether you've added `reverse=true` to your options, but in effect this will change the offset of which logs are displayed based on the `l=10`, limit, option. A value of `l=10` means later or earlier 10 logs.

### search command

- `/rlu-search <username> <#channel> <...search terms>` Shows latest 10 search results for user in defined channel with the search terms. And a link to view all.

- `/rlu-search <username> <...search terms>` Shows latest 10 search results for user in current split channel with the search terms. And a link to view all.

## today command

- `/rlu-today <username>` Shows messages count, across all tracked channels, for today.

## misc commands

- `/rlu-stalk <username>` Posts any new message posted by this user, using tracked channels.

- `/rlu-optout` Shows a URL where you can opt-out of currently assigned instance.

- `/rlu-help` Prints out version info and some help.

## Features

## Credits

MIT

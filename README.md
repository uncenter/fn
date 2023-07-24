# Feed - Newsboat's missing CLI

Feed is a simple wrapper around [Newsboat](https://newsboat.org/) to make it easier to launch, configure, and manage your feeds.

See [Installation](#installation) to get started, update, or uninstall.

## Usage

```sh
feed <command> [arguments]
```

| Command                  | Description                    |
| ------------------------ | ------------------------------ |
| `add <url>`              | Add a URL.                |
| `remove <url>`           | Remove a URL.             |
| `list`                   | List all URLs.            |
| `edit`                   | Edit the URL file.        |
| `configure`              | Edit the Newsboat config file. |
| `launch`, `start`, `run` | Launch Newsboat.               |
| `update`, `upgrade`      | Update feed.                   |
| `uninstall`              | Uninstall feed.                |
| `help`                   | Show help message.             |

Any unrecognized commands or options will be passed to Newsboat. For example, `feed -h` will show the Newsboat help message, **not** the help message for Feed.

## Installation

```sh
curl -fsSL https://github.com/uncenter/feed-newsboat/raw/main/install.sh | sh
```

You may need to manually add either `$XDG_BIN_HOME` or `$HOME/.local/bin`, depending on the installation location, to your `$PATH` if it is not already present.

```sh
export PATH="$PATH:$HOME/.local/bin"
```

## Environment variables

`FEED_NO_ARGS_LAUNCH` - If set, feed will launch Newsboat when no arguments are provided. By default, feed will show a brief help message.

## License

[MIT](LICENSE)

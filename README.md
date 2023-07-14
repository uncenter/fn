# `feed` - newsboat's missing cli

Feed is a simple wrapper around [newsboat](https://newsboat.org/) to make it easier to launch, configure, and manage your feeds.

See [Installation](#installation) to get started, update, or uninstall.

## Usage

```sh
feed <command> [arguments]
```

| Command                  | Description                    |
| ------------------------ | ------------------------------ |
| `add <url>`              | Add a feed URL.                |
| `remove <url>`           | Remove a feed URL.             |
| `list`                   | List all feed URLs.            |
| `edit`                   | Edit the feed URL file.        |
| `config[ure]`            | Edit the newsboat config file. |
| `launch`, `start`, `run` | Launch newsboat.               |
| `update`, `upgrade`      | Update feed.                   |
| `uninstall`              | Uninstall feed.                |
| `help`                   | Show help message.             |

Any unrecognized commands or options will be passed to newsboat. For example, `feed -h` will show the newsboat help message, **not** the feed help message.

## Installation

```sh
curl -fsSL https://github.com/uncenter/feed-newsboat/raw/main/install.sh | sh
```

You may need to manually add either `$XDG_BIN_HOME` or `$HOME/.local/bin`, depending on the installation location, to your `$PATH` if it is not already present.

```sh
export PATH="$PATH:$HOME/.local/bin"
```

## License

[MIT](LICENSE)

# `feed` - newsboat's missing cli

Feed is a simple wrapper around [newsboat](https://newsboat.org/) to make it easier to launch, configure, and manage your feeds.

See [Installation](#installation) to get started, update, or uninstall.

## Usage

```sh
feed <command> [options]
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
bash -c "$(curl -fsSL https://github.com/uncenter/feed-newsboat/raw/main/install.sh)"
```

If `$HOME/.local/bin` (or `$HOME/bin`, depending on where feed was installed) is not in your `$PATH`, you will need to add it manually to use `feed`.

```sh
export PATH="$PATH:$HOME/.local/bin"
```

## License

[MIT](LICENSE)

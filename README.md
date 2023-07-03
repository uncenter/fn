# `feed` - a command wrapper for `newsboat`

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
| `config`                 | Edit the newsboat config file. |
| `launch`, `start`, `run` | Launch newsboat.               |
| `help`                   | Show help message.             |

Any unrecognized commands or options will be passed to newsboat.

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

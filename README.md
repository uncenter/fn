<div align="center">
	<h1>🚧 ARCHIVED 🚧</h1>
	<h3>Use <a href="https://github.com/isabelroses/izrss">izrss</a> instead of Newsboat altogether.</h3>
</div>

---

# `fn`

![Recording of using `fn` in the terminal](docs/demo.gif)

`fn` is a simple wrapper around [Newsboat](https://newsboat.org/) to make it easier to launch, configure, and manage your feeds.

See [Installation](#installation) to get started, update, or uninstall.

## Usage

```sh
fn [command]
```

| Command                  | Description                    |
| ------------------------ | ------------------------------ |
| `add <url>`              | Add a URL.                     |
| `remove <url>`           | Remove a URL.                  |
| `list`                   | List all URLs.                 |
| `edit`                   | Edit the URL file.             |
| `configure`              | Edit the Newsboat config file. |
| `launch`, `start`, `run` | Launch Newsboat.               |
| `update`, `upgrade`      | Update `fn`.                   |
| `uninstall`              | Uninstall `fn`.                |
| `help`, `-h`, `--help`   | Display help message.          |
| `-V`, `--version`        | Display current version.       |

Any unrecognized commands or options will be passed to Newsboat. ~~For example, `fn -h` will show the Newsboat help message, **not** the help message for `fn`.~~ As of [`v1.2.0`](https://github.com/uncenter/fn/releases/tag/v1.2.0), the following options will be accepted by `fn`: `-h`, `--help`, `--version`, `-V`. If you want help with Newsboat instead of `fn`, use `fn run -h` (or just `newsboat -h`).

## Installation

```sh
curl -fsSL https://github.com/uncenter/fn/raw/main/install.sh | sh
```

You may need to manually add either `$XDG_BIN_HOME` or `$HOME/.local/bin`, depending on the installation location, to your `$PATH` if it is not already present.

```sh
export PATH="$PATH:$HOME/.local/bin"
```

## Environment variables

`FN_NO_ARGS_LAUNCH` - If set, `fn` will launch Newsboat when no arguments are provided. By default, `fn` will show a brief usage message.

## License

[MIT](LICENSE)

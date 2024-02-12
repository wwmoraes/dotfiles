# William's Dotfiles 2.0

## Table of Contents

- [About](#about)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Contributing](../CONTRIBUTING.md)

## About

Dotfiles for all sorts of tools and configurations. Templates are minimal for
sanity's sake.

What will you find in this repository? As I moved to chezmoi, I do abuse some of
its mechanisms such as:

- fetch external resources (`.chezmoiexternals`)
  - **coding tools**: TPM (Tmux Package Manager), PlantUML jar
  - **fonts**: Fira Code, Powerline symbols, Source Code Pro for Powerline
  - **work tools**: `calicoctl` and `terraform` on specific versions
- scripting for last-mile setup (`.chezmoiscripts`)
- ignored dot-folders
  - `.global.d`: system-wide configuration
  - `.setup.d`: non-brew packages and utility functions
  - `.shadow.d`: symlinked content. Fish shell, VSCode, Hammerspoon

The rest are `private_*` files and folders that chezmoi will apply relative to
the home directory, or repository-related content that's ignored like this
readme file.

### Scripts

I work on Unix environments, more specifically MacOS. The setup files follow the
numeric prefix to ensure their order + chezmoi keywords to trigger then at
specific moments. Here's the (incomplete) workflow sequence.

During apply:

- `00-developer`: MacOS-specific. Enables developer mode and group membership
- `80-less-termcap`: generates `~/.lesskey` with terminal-dependant key codes
- `90-defaults`: MacOS-specific. Sets dozens of application and system settings
- `90-pmset`: MacOS-specific. Power management settings

Post-apply:

- `00-brew`: Installs/updates Homebrew. Then runs the bundle and cleanup
- `10-variables`: Loads universal env vars in Fish + sets up the PATH
- `20-golang`/`20-node`/`21-rust`/etc: Manages packages from different languages
- `80-fonts`: MacOS-specific. Links font files and refreshes the font database
- `80-*-plugins`: Installs plugins for tools like `helm` and `krew`
- `80-launchAgents`: MacOS-specific. Manages 3rd-party launch agents
- `80-launchDaemons`: MacOS-specific. Installs launch daemons from `.global.d`

Most scripts have the `onchange` prefix + a comment at the top to generate the
checksum of the files they work it. This allows chezmoi to skip running it on
apply if there's no changes on their dependencies.

## Getting Started

- Install 1Password 8 and sign-on
- Install 1Password v2 CLI
- enable the CLI integration on 1Password

You may also sign-on through the CLI directly and skip the main application.
This setup is less optimal as you need to re-authenticate with password on each
new shell session.

Then:

```shell
# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# install ejson
brew install shopify/shopify/ejson
```

If the host has a working op CLI:

```shell
# clone the repository and install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/wwmoraes/dotfiles.git
# OR install chezmoi from elsewhere and then
chezmoi init --apply https://github.com/wwmoraes/dotfiles.git
```

For restricted hosts, namely work devices with poorly configured DPI using
copy-pasted settings from SO, the op CLI won't work. One known case is with
Zscaler as it intercepts even the localhost gRPC calls between CLI and the
daemon, voiding the trusted CA chain used by 1Password. In that case:

```shell
# generate the encrypted json payload on another host and transfer it to
# <source-path>/.ejson/secrets.json, then
make -C "$(chezmoi source-path)" secrets
export EJSON_KEYDIR="$(chezmoi source-path)/.ejson/keys"
chezmoi init && chezmoi apply
```

After the first successful apply, change the origin to use SSH:

```shell
git -C "$(chezmoi source-path)" remote set-url origin git@github.com:wwmoraes/dotfiles.git
```

Enjoy! 🚀

## Usage

Check the [upstream chezmoi][chezmoi-command-overview] documentation for all
commands, or use the `--help` for more. Shells also have autocompletion
configured when you install chezmoi, use and abuse it!

After the first successful apply, you'll have extra sub-commands available
thanks to chezmoi's ["plugin" system][chezmoi-plugins]. Here's some of them:

- `check`: applies `~/.Brewfile` then dry-runs `brew bundle` to report changes
- `env`: applies `~/.config/environment.d` then loads the env vars in Fish
- `lg`: runs `lazygit` on the chezmoi source directory
- `sync`: applies `~/.Brewfile` then runs the `00-brew` script to apply changes

[chezmoi-command-overview]: https://www.chezmoi.io/user-guide/command-overview/
[chezmoi-plugins]: https://www.chezmoi.io/reference/plugins/

## FAQ

> **Question**: Why is there a mix of sh/bash and fish scripts?

**Answer:** I need a POSIX shell available on my hosts to bootstrap everything.
I use it to install `brew` and run it at least once. It installs most of my
tools, including other shells. This also means that any scripts that run before
or during the apply step should be POSIX-compliant.

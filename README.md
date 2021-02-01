<p align="center">
  <a href="" rel="noopener">
 <img width=200px height=200px src="https://via.placeholder.com/200.jpg?text=dotfiles" alt="dotfiles"></a>
</p>

<h3 align="center">dotfiles</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![GitHub Issues](https://img.shields.io/github/issues/wwmoraes/dotfiles.svg)](https://github.com/wwmoraes/dotfiles/issues)
[![GitHub Pull Requests](https://img.shields.io/github/issues-pr/wwmoraes/dotfiles.svg)](https://github.com/wwmoraes/dotfiles/pulls)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> Cross-platform dotfiles with batteries
    <br>
</p>

## 📝 Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)
- [TODO](../TODO.md)
- [Contributing](../CONTRIBUTING.md)

## 🧐 About <a name = "about"></a>

Configures hosts with dotfiles, environment variables, packages and binaries
across multiple platforms and systems. The reason for this is that managing multiple
contexts (work machine, home machine, lab machine) can get tedious and even
time-consuming, thus this repository was born.

- cross-platform, system-specific and host-specific supported features
  - dotfiles' setup (using stow)
  - environment variables' setup (using stow + functions per shell to load)
  - package install (system dependent tool + per language as go get, pip, cargo)
- cross-platform polyfill executables (mostly scripts)

### FAQ

> why not create a binary + DSL + specific config + whatever?

KISS. Shell scripts are virtually available on all OS nowadays (even Windows has
Bash through WSL now, and had it in a less-compatible way for some decades
through Cygwin), which makes installing this repository easy on a fresh host.

## 🏁 Getting Started <a name = "getting_started"></a>

For new hosts, clone the repository on the desired host, install and setup
directly from the cloned folder using `make install` and `make setup`. Afterwards
it can be managed using fish's `dotfiles` function.

### Prerequisites

The installation process, `make install`, which configures only dotfiles, needs

- GNU Stow
- GNU Make or compatible

The setup process and its scripts, `make setup` or `./setup.sh`, needs GNU Bash.

### Installing

```sh
git clone git@github.com:wwmoraes/dotfiles.git ~/.files
cd ~/.files
make install && make setup
```

### Creating your own setup scripts

The setup process runs any scripts found on `.setup.d` folder in alphabetical
order, thus the number prefix convention is used to guarantee the order (as your
script might need some package installed before it is run).

For package installation, copy one of the existing setup scripts
(system/golang/python/rust) and set as desired.

## 🎈 Usage <a name="usage"></a>

The fish function, `dotfiles`, has some subcommands that manages the repository,
namely:

- `add <file/folder>`: moves the target file/folder to the repository and stows it
- `install`: installs the dotfiles (i.e. runs `make install`)
- `setup`: runs the setup scripts
- `update`: updates the repository (i.e. git pull)
- `code`: opens the repository in VSCode
- `lg`: opens lazygit at the repository
- `config`: WIP - configures other CLI tools that need external communication (e.g. gcloud authentication)

### Project structure

```text
dotfiles/                     <-- this repository
├── .hostnames/               <-- host-specific stow files
│   └── any-host-name/        <-- hostname as in the command hostname -s
│       └── non-dot-folder/   <-- stow group folder
│           └── ...           <-- files/folders that'll be stowed as ~/...
├── .polyfills/               <-- custom executable files to be installed on ~/.local/bin
│   └── ...                   <-- files that'll be linked as ~/.local/bin/...
├── .setup.d/                 <-- setup scripts ran by make setup or ./setup.sh
│   ├── packages/             <-- package lists
│   │   └── system.txt        <-- system packages (e.g. deb/pacman/rpm/homebrew package names)
│   ├── darwin/               <-- MacOS-specific package lists
│   │   └── system.txt        <-- system packages (e.g. deb/pacman/rpm/homebrew package names)
│   ├── linux/                <-- Linux-specific package lists
│   │   └── system.txt        <-- system packages (e.g. deb/pacman/rpm/homebrew package names)
│   └── 10-system.sh          <-- installs packages/system.txt and packages/<system>/system.txt packages
├── .systems/                 <-- system-specific stow files
│   ├── linux/                <-- linux-specific stow files
│   │   └── non-dot-folder/   <-- stow group folder
│   │       └── ...           <-- files/folders that'll be stowed as ~/...
│   └── darwin/               <-- MacOS-specific stow files
│       └── non-dot-folder/   <-- stow group folder
│           └── ...           <-- files/folders that'll be stowed as ~/...
└── non-dot-folder/           <-- stow group folder
    └── ...                   <-- files/folders that'll be stowed as ~/...
```

Stow group folders are used to group and organize files as seem fit. These names
are visible during install, e.g.:

```text
stowing 1Password...
stowing bash...
stowing editorConfig...
stowing environment...
stowing fish...
stowing fonts...
stowing git...
stowing kitty...
stowing pet...
stowing powerline...
stowing tmux...
stowing vim...
stowing vscode...
stowing darwin/LaunchAgents...
stowing darwin/MTMR...
stowing darwin/finicky...
stowing darwin/skhd...
stowing M1Cabuk/kitty...
```

Stows are done from the most to the least broad context, that is, cross-platform
dotfiles go first, then system-specific and finally host-specific.

### Current dotfiles

#### Cross-platform

| Category             | Tool               |
|----------------------|--------------------|
| Shell                | fish               |
| Terminal             | Kitty              |
| Terminal multiplexer | tmux               |
| Terminal editor      | vim                |
| Visual editor        | Visual Studio Code |
| Snippet manager      | pet                |
| Password manager     | 1Password          |

#### Linux

| Category        | Tool                   |
|-----------------|------------------------|
| Graphics server | Xorg                   |
| Window Manager  | i3 (KDE to be removed) |
| Sound server    | PulseAudio             |

#### MacOS

| Category           | Tool                     |
|--------------------|--------------------------|
| Window Manager     | i3                       |
| URL handler        | Finicky + Browserosaurus |
| Touchbar           | MTMR                     |
| Keyboard shortcuts | skhd                     |

### Polyfills

- `arp` - runs `ip n`
- `copy` - uses system-specific tools to copy piped data to clipboard
  - MacOS: `pbcopy`
  - Linux: `xsel`/`xclip`/`wl-copy`
  - Windows: `powershell.exe`

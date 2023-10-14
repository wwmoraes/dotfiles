# William's Dotfiles 2.0

## Table of Contents

- [About](#about)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Contributing](../CONTRIBUTING.md)

## About

Dotfiles for all sorts of tools and configurations using chezmoi. Templates are
kept to a bare minimal for sanity's sake.

## Getting Started

- Install `1password` and its v2 CLI
- Authenticate in 1Password

Then:

```shell
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:wwmoraes/dotfiles.git
```

## Usage

Check the [upstream chezmoi][chezmoi-command-overview] documentation for all
commands, or use the `--help` for more. Shells also have autocompletion
configured when you install chezmoi, use and abuse it!

[chezmoi-command-overview]: https://www.chezmoi.io/user-guide/command-overview/

## FAQ

> **Question**: Why is there a mix of sh/bash and fish scripts?

**Answer:** I need a POSIX shell available on my hosts to bootstrap everything.
I use it to install `brew` and run it at least once. It installs most of my
tools, including other shells. This also means that any scripts that run before
or during the apply step should be POSIX-only.

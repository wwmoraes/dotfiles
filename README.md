# William's Dotfiles

## Table of Contents

- [About](#about)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Contributing](../CONTRIBUTING.md)

## About

Batteries-included configuration of hosts and programs. This is the fourth
generation of it, now using Nix [flakes](https://nix.dev/concepts/flakes.html)
and [flake-parts](https://flake.parts/).

For what is worth, here's the breakdown of past versions:

- **v3**: [Nix modules](https://nix.dev/tutorials/module-system/index.html)
  - good option if you only have a handful of dynamic settings and/or hosts
- **v2**: [Chezmoi](https://www.chezmoi.io/)
  - excellent tool that I recommend if you prefer a template approach
- **v1**: [GNU Stow](https://www.gnu.org/software/stow/)
  - simple, symlinks files/folders; might suffice if you have static settings

### Why switch from...

#### ... Nix modules?

- with my adoption of NixOS in my fleet, I had to decouple some Darwin-specific
  settings
- the file and folder structure often got in the way, with the same program
  configured in different paths to handle conditional imports; that introduced
  context switching between multiple paths to configure the same target
  program/system
- after a dozen modules, handling default imports was a chore; it also made
  orthogonal settings harder to manage (e.g. work/personal environments &
  per-user settings)

#### ... Chezmoi?

- I felt a bit disgruntled with all the long folders and file names due to
  [source state attributes](https://www.chezmoi.io/reference/source-state-attributes/)
- some programs I use have many distinct paths to configure its elements (once
  again, looking at you, Docker Desktop). Thus finding where to configure what
  became tedious
- my work environment doesn't allow me to use many tools such as a decent
  password manager for runtime secret expansion. That made my original secrets
  management using 1Password less portable, forcing me to use ejson (now SOPS),
  which added its own complexity, duplication and problems on how its wired up

#### ... GNU Stow?

- Some applications do not like symlinks (looking at you, Docker Desktop)
- Extra scripting needed to bolt-on dynamic requirements such as packages and
  in-place settings; this made configuration a tad tedious to maintain due to
  all the edge cases to handle
- mix of imperative and declarative syntaxes, meaning I had to care about order
  instead of only desired state

## Getting Started

Fully remote:

```shell
## install nix using your preferred method, then run
sudo nix \
  --option accept-flake-config true \
  run github:wwmoraes/dotfiles#darwin-rebuild \
  -- switch --impure --no-remote --flake . # MacOS
sudo nixos-rebuild switch --flake github:wwmoraes/dotfiles # NixOS

## after that use this for future switches on a local clone
sudo darwin-rebuild switch --impure --no-remote --flake . # MacOS
sudo nixos-rebuild switch --impure --no-remote --flake . # NixOS

## OR from this repository root
nix run .

## Enjoy! 🚀
```

Some enterprise environments use MITM proxies with poorly configured CAs on
hosts, breaking tools like curl. In such cases its best to clone/download a copy
of this repository and use its scripts to temporarily dump the certificates from
the OS certificate store to get past the first setup. Make sure the host
configuration contains your enterprise CAs so future runs work without this.
Those can be found in `modules/pki/work`.

```shell
## clone this repository, then run
./scripts/setup-nix.sh

## bootstrap it by running
./scripts/bootstrap.sh

## after that use this for future switches
sudo darwin-rebuild switch --impure --no-remote --flake .

## OR from this repository root
nix run .

## Enjoy! 🚀
```

## Usage

Check upstream sources:

- [function search](https://noogle.dev)
- [aggregated search](https://searchix.ovh)
- [home-manager option search](https://home-manager-options.extranix.com/)
- [nix-darwin option search](https://options.nix-darwin.uz/)
- [package search](https://search.nixos.org/packages)
- [NixOS option search](https://search.nixos.org/options)
- [function reference & docs](https://teu5us.github.io/nix-lib.html)

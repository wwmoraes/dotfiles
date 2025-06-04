# William's Dotfiles 3.0

## Table of Contents

- [About](#about)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Contributing](../CONTRIBUTING.md)

## About

Batteries-included configuration of hosts and programs. This is the third
generation of it, now using Nix.

For what is worth: the previous iteration used chezmoi, which is an excellent
tool and I *fully recommend it*. My decision to switch to Nix happened because:

- I felt a bit disgruntled with all the long folders and file names due to
  [source state attributes](https://www.chezmoi.io/reference/source-state-attributes/)
- some programs I use have many distinct paths to configure its elements (I'm
  looking at you, Docker Desktop). Thus finding where to configure what became
  tedious
- my work environment doesn't allow me to use many tools such as a decent
  password manager for runtime secret expansion. That made my original secrets
  management using 1Password less portable, forcing me to use ejson (now sops)
- I'm already familiar with Nix since I adopted it on all my projects to manage
  its dependencies and environment instead of dev containers BS

## Getting Started

Fully remote:

```shell
## install nix using your preferred method, then run
sudo nix \
  --option accept-flake-config true run github:wwmoraes/dotfiles#darwin-rebuild \
  -- switch --impure --no-remote --flake .

## after that use this for future switches
sudo darwin-rebuild switch --impure --no-remote --flake .

## OR from this repository root
nix run .

## Enjoy! 🚀
```

Some enterprise environments use MITM proxies with poorly configured CAs on
hosts, breaking tools like curl. In such cases its best to clone/download a
copy of this repository and use its scripts to temporarily dump the certificates
from the OS certificate store to get past the first setup. Make sure the host
configuration contains your enterprise CAs so future runs work without this.
Those can be found in `settings/work/security/pki/certificates`.

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

- [functions](https://noogle.dev)
- [home-manager option search](https://home-manager-options.extranix.com/)
- [nix-darwin option search](https://options.nix-darwin.uz/)
- [package search](https://search.nixos.org/packages)
- [NixOS option search](https://search.nixos.org/options)

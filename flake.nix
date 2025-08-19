{
  description = "wwmoraes' dotfiles on steroids";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-25.05";
    };
    # homebrew-cask = {
    #   url = "github:homebrew/homebrew-cask";
    #   flake = false;
    # };
    # homebrew-core = {
    #   url = "github:homebrew/homebrew-core";
    #   flake = false;
    # };
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nur = {
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      url = "github:nix-community/NUR";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
    stylix = {
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nur.follows = "nur";
      inputs.systems.follows = "systems";
      url = "github:danth/stylix/release-25.05";
    };
    systems.url = "github:nix-systems/default";
    templates = {
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.treefmt-nix.follows = "treefmt-nix";
      url = "github:wwmoraes/templates";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
    unstable.url = "github:NixOS/nixpkgs";
  };

  nixConfig = {
    substituters = [
      "https://wwmoraes.cachix.org/"
      "https://nix-community.cachix.org/"
      "https://cache.nixos.org/"
      "https://hercules-ci.cachix.org/"
    ];
    trusted-public-keys = [
      "wwmoraes.cachix.org-1:N38Kgu19R66Jr62aX5rS466waVzT5p/Paq1g6uFFVyM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hercules-ci.cachix.org-1:ZZeDl9Va+xe9j+KqdzoBZMFJHVQ42Uu/c/1/KMC5Lw0="
    ];
  };

  outputs =
    inputs@{
      # keep-sorted start
      flake-parts,
      home-manager,
      # homebrew-cask,
      # homebrew-core,
      nix-darwin,
      nix-homebrew,
      nixpkgs,
      nur,
      self,
      sops-nix,
      stylix,
      systems,
      treefmt-nix,
      unstable,
      # keep-sorted end
      ...
    }:
    (flake-parts.lib.mkFlake { inherit inputs; } {
      flake = rec {
        # getLanguage = name: (builtins.filter (entry: entry.name == name) darwinConfigurations.M1Cabuk.config.home-manager.users.william.programs.helix.languages.language);
        inherit (inputs.templates) templates;

        darwinModules = {
          default =
            {
              pkgs,
              ...
            }:
            {
              imports = [
                nix-homebrew.darwinModules.nix-homebrew
                (nixpkgs + /nixos/modules/programs/less.nix)
                ./modules/nix-darwin
              ];

              environment.systemPackages = [
                self.packages.${pkgs.system}.darwin-rebuild
                self.packages.${pkgs.system}.switch-home
                self.packages.${pkgs.system}.switch-system
              ];

              home-manager.sharedModules = [
                sops-nix.homeManagerModules.sops
                stylix.homeModules.stylix
                ./modules/home-manager
                {
                  stylix.overlays.enable = false;
                }
              ];

              nix.registry.templates.flake = inputs.templates;

              nixpkgs = {
                overlays = [
                  self.overlays.default
                  self.overlays.nur
                  self.overlays.unstable
                ];
              };

              system.tools.darwin-rebuild.enable = false;
            };
        };

        darwinConfigurations =
          let
            aarch64-darwin = nix-darwin.lib.darwinSystem rec {
              system = "aarch64-darwin";
              modules = [
                { nixpkgs.hostPlatform = system; }
                home-manager.darwinModules.home-manager
                sops-nix.darwinModules.sops
                stylix.darwinModules.stylix
                darwinModules.default
                ./settings/common
                ./settings/common/darwin
                ./users/william/share
              ];
            };
          in
          {
            M1Cabuk = aarch64-darwin.extendModules {
              modules = [
                ./hosts/M1Cabuk
                ./settings/personal
                ./settings/personal/darwin
                ./users/william/personal
              ];
            };
            NLLM4000559023 = aarch64-darwin.extendModules {
              modules = [
                ./hosts/NLLM4000559023
                ./settings/work
                ./settings/work/darwin
                ./users/william/work
              ];
            };
          };

        nixosModules.default = {
          imports = [
          ];
        };
        nixosConfigurations = {
          vidar = nixpkgs.lib.nixosSystem rec {
            system = "aarch64-linux";
            modules = [
              { nixpkgs.hostPlatform = system; }
              nixosModules.default
              home-manager.nixosModules.home-manager
              sops-nix.nixosModules.sops
              stylix.nixosModules.stylix
              ./hosts/vidar
              ./settings/common
              {
                home-manager.sharedModules = [
                  sops-nix.homeManagerModules.sops
                  stylix.homeModules.stylix
                  ./modules/home-manager
                  {
                    stylix.overlays.enable = false;
                  }
                ];
              }
              # ./settings/personal
              ./users/william/share
              # ./users/william/personal
            ];
          };
        };

        overlays = (import ./overlays) // {
          unstable = final: prev: {
            unstable = import unstable { inherit (prev) system; };
          };
          nur = nur.overlays.default;
        };
      };

      perSystem =
        { pkgs, system, ... }:
        let
          treefmt = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        in
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              self.overlays.default
              self.overlays.nur
              self.overlays.unstable
            ];
            config = { };
          };

          checks = {
            formatting = treefmt.config.build.check self;
          };

          devShells.default = import ./shell.nix { inherit pkgs; };

          formatter = treefmt.config.build.wrapper;

          packages =
            let
              extraPath = pkgs.lib.makeBinPath (
                with pkgs;
                [
                  coreutils
                  jq
                  git
                ]
              );
              nixPath = pkgs.lib.concatStringsSep ":" [
                "darwin-config=/etc/nix-darwin/configuration.nix"
                "/nix/var/nix/profiles/per-user/root/channels"
              ];
              path = pkgs.lib.concatStringsSep ":" [
                "${extraPath}"
                "$HOME/.nix-profile/bin"
                "/etc/profiles/per-user/$USER/bin"
                "/run/current-system/sw/bin"
                "/nix/var/nix/profiles/default/bin"
                "/usr/local/bin"
                "/usr/bin"
                "/bin"
                "/usr/sbin"
                "/sbin"
              ];
              profile = "/nix/var/nix/profiles/system";
            in
            rec {
              default = switch-system;
              darwin-rebuild = pkgs.replaceVarsWith rec {
                name = "darwin-rebuild";
                src = ./scripts/darwin-rebuild.bash;
                dir = "bin";
                isExecutable = true;
                meta.mainProgram = name;
                replacements = {
                  inherit path nixPath profile;
                  inherit (pkgs.stdenv) shell;
                };
              };
              switch-home = pkgs.writeShellScriptBin "switch-home" ''
                HOSTNAME=$(scutil --get LocalHostName)
                ROOT="''${1:-.}"
                exec nix run $ROOT#darwinConfigurations.$HOSTNAME.config.home-manager.users.$USER.home.activationPackage
              '';
              switch-system = pkgs.writeShellScriptBin "switch-system" ''
                ROOT="''${1:-.}"
                exec sudo nix \
                --option accept-flake-config true \
                --option build-users-group "" \
                --extra-experimental-features "nix-command flakes" \
                run .#darwin-rebuild -- switch --no-remote --flake $ROOT
              '';
              ## nix-homebrew doesn't export the package, it is added directly to the system packages...
              ## builtins.filter (pkg: pkg.name == "brew") darwinConfigurations.M1Cabuk.config.environment.systemPackages
              brew-cleanup = pkgs.writeShellScriptBin "brew-cleanup" ''
                brew update
                brew bundle --cleanup
              '';
            };
        };

      systems = import systems;
    });
}

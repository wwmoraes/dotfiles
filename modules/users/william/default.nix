{
  inputs,
  lib,
  ...
}:
{
  flake.modules.generic.william =
    { config, ... }:
    {
      users.users.william = {
        name = "william";
        home = lib.mkDefault "/home/william";
      };

      sops.gnupg.home = config.home-manager.users.william.programs.gpg.homedir;
    };

  flake.modules.darwin.william =
    {
      config,
      ...
    }:
    {
      users.users.william = {
        home = "/Users/william";
      };
      system.defaults.CustomSystemPreferences."/Library/Preferences/com.apple.TimeMachine".SkipPaths = [
        "${config.users.users.william.home}/Cloud"
        "${config.users.users.william.home}/dev"
      ];
    };

  flake.modules.nixos.william =
    {
      config,
      ...
    }:
    {
      users.users.william = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
        ];
        hashedPassword = "$y$j9T$mTI8Jz6.5oYDZ1QzP1yRz.$2WjZd3.4Ceosh1YbzImP8kgyP8kxTBQj1MIqbe2BQMA";
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEQfDq8il7eWmG9om/Oqlkd842nSpb/W2A44Yp2RDSHDFKddjSGxpB3phN1eQieymqJMFofdHahdLoxXIItJH5D0ixT/dKCNduZosN1fpJu6pcPaMZ8lxzxMKcNswZ3j9Hitk9lMX/x/Y3h9uBv/nHbpPxxGmxJM7bze9RVYAcEZIvrFib2VFp62k7DHMgQzOUm+s4moa2uvc3JXKtjYdqVq+pdryubYn1BRxkBDc5TH9WIIEKAkDUV+kYIslFs4orlWZXd2yKKqGXM+5pK5ybiEo2mGiooXr1hBXSvGPbpeWNmHqEl8AKY3MRgwbt/eqVk9YkGZh/w0Go5Cus1KHdNccApkt1ItX30+caDRgpDN47pPtMs7onNvPoYEaG0CgGOQa9SjcXd0GSi6X2HVA9FLnkT3rsUTrkwOz9pEAkBqYTPfVoKnfhmfInZt/7JiKAbGSw93O6du5pvQkDpG7aRtfCIoRK642ClG2yqqSPv7uoQi2EWMHSFnCSmW+uIL5Lj2DUdeKoB01KtgZYXAGKJseAvP8FXiQfBh8PHXwNaQQ0fBeI5DOXpIJXvjV9XdnkeA1T+W+m3r7QzhR6K4lOBx8gNXJ7p5x8+JZ5B0FbN0Qnbg7t15cUWJyD8xMABca1JyuBpt/jO0F/chyzqI8sDp201Hd67lJxPaN3x09ZrQ== openpgp:0x78133BF7"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/gOwc6RLeXcdlEjiduZsm5wJmTDAsN7fAs2suNavqeXESIVshRsih478c43h18tKyFYZACgHmEk2tJg0NO+VDWFaeQPfc+BUQyhlbCNgC+U6dH1ciTuFntzjv9Hbc21EdImkD+fVaVCkbf4EC3BgtkDkOUuE3R2GSg5CxpvJ2OBWBrb0tbpK4+NqRzfI4U0/q1441ZbJqusDuQoVEEdP9XuOgbhostdx8pASJHnTJiasfgFsZa+p7Va1BJ2KjHTw2cE9ENEwKrJ06IVbmEzbi8M9MOAqQ8lhUUxXUhIBLi+vDZh0hmGSSz8xVUipAJa/DQF2mG05ktJIDywktxpLvSNcFo7ahenoiMoeSqz1UEyH/ZGMO+1IYHPYlmG2SRzXPL1Wjs0qkYB1K/B4xBSMZvCZK+v7KXtyj/s8TvR6izG8fMdTaIWRycQe6TQAzWlxLSXT+iahkuxMF9fQckkLrWn4ye4uaicyfhzqV55fMDu2QuBdV8tRmAgyDFzQIcGwkVe4oy8YQ+u+lOu902WyI8wASEPvX6MAshHyHEciTsCdT3/ETTh94mQnx8ffg0ZSsxy0uiKVEKuqbkYgE+Nzp5qqGgdSBjVj+PhuepWJ7v4TTAsKKbWEAuLjnvOzOEWycOuzsQsgXBErnHB2boqtgoNZZVDgx8pmG2oyBpb5SnQ== openpgp:0xC53A52E1"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCcIIbYj1zxMLN2KnYuKiluSQtvge4f1ZEgVlDqFSThKdjID6y+wtgo+Usy0Os0KV/YyhtNd1dKXisowUIQQCOOPZrBvlCKj+u1051bkEwu/3E55F/T36YjH9e7PT+7f89PMkwQ4XV2tf29xqaBAqxIF6dlyBarC+0j3VyrTlFD3UJQ+7D9IGzQKXrTkEu3lFYGcanmHXJ6n9mksJGthwkj2cem/5cyhC/+oVlBRnaZ+Wk56rKG7WHOEXJYr68TZtXOt/W+sRElchI9cA42K2D+wJi3tANp3ShNjblihayrRhGa/rZsRTuLSap9QUmsNOTektriMNdqG5MTHVV9wsBdr8V9YgvlJU5RJyVGu8Xn1aYwIrVDUpSo5lw7g/z7LLhnmK6ttxNQ1m1lJEBQWSC8Y1hONrrvAv6KyL/lVxLeKtQTOc9H9gH1GMR8EinekjQa56IXB5UHDp3C3Rf4abGy/aUjgtDJh7bJ9IR1J+Od8v5LqUnWzIb/uoydkrqi8V9E+90xZ099DRaDZY8LLWgmhRCf/TvfDqJNMEfVyj5jeeN1E15egU5iE4Z0Rlgk1YVZoGqE4n2MPmQ058hbvPBuFkYUjYAgzQHOkqDyplk/Soo2j3uVFJ2f8dfrzG9uwdTO+gFsDQhrGRZEvyMQNk+R4sY1gfGxr85VOCtr6FdJfQ== openpgp:0x3CAA9D88"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4WES78B50maGZu/NZwcgGUFIkj3kJxl7ryDYOyqZSPFruuLEPeP7EP32paj9WaLp43vrFAYh1Yede39v3DWmNfaTbgEAdz7EDJSkUyt2EmHYPljkFbSXJFTxkT4pA86R7Z06Cr+AhUb0nbAa9eJ7ifcUEAjoGao70ZrrywlVWKekH7SA7H51Ks/zknphtNpqZ4q+ARMtO5sFWkJYpoDJQozS1AUH1flVdNFrDC/l9jBggOrQn6CUkoi/pMDHKMipjye8r0LroYfKG2PNsJ0FwGAbZjzus787JbKvHzFuEjRgTPGoZgKgZ3sgioEJ9Q2J+3rkBNdexvTSmvgoKaq8T6pKDNE3fZyaPXZo6ZPy2llwQ4BBtd3GhoP6B6itSPmaDxCLC9Fmdl/Azq26sRQ6jDgzdZnc1oP3E7dCEOb4CsuwjazDyVDjukmbqyGINkIYf+uxJ1OILWG8lwRVxqqYWKIodAaqCwJddkxy0UJDBSBexAmvWHSfIrrx5YPveksldoD7/tVbqDCTGsb6ztesMJlVIg0DMNmiuiHauS5Ywxvvn1CoSfCru+0HVqdayIRoZ6bZCvF3r5vA2oyRz6lBXdME8CdYxkl8jd+6faQEp+8E6/T0//x73y13bMnr/7XO+03XTWQpqlzLsuC5SDkAfK9r/FGsNZZiDu8Qs7KDCuw== openpgp:0x196A28F6"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD0hZAxWk0hoBupHolla2VJgawGw4ozZLtQjaRB33biFIFeQyd+zgu1ppDUUIaLnXaMWccfqTuRtp3WQUv6lbxB6gFSuHlIOd2tVEvboyCEYu1taGlMZODQQroIn/ytL0BFid9fgKi3ft6EEF7XCGGwbjOcNEOVmt4PppfiwEJrzjmBU0MJp+YCC0bxSG8DbQj6pe2vKRo/hYqgjjOifVXAdDqtWSSL/U0woTKebpBvQu0HbmdOL5zD2X6GCfZNU/SDDM717CKkJDpiDt882wkcHdWmeFpL89tEzt9O0l4DybrCs0LAQTlqYqqofr4QNdER/dcZ1tr0+eKAXJo3M9YTscTYtLYU8UKC3CyfBcQuYPiioy0gxATBkI/2gRkn9t3pPbjMkfN8EDLbrb+bf2huB6ES+J4ZmCd/gWMinrpSlcsosUAi3Rfyn4KAKJxR/VEw+AhAj5pq26TVKOhidbIA89lIkjuFFEMbtxyALfTtToGX/GxtYrvb/skmpTMa9JdBNEv7ppLHTdYeSvwCqK8XvSCNTs7jeRmglYshdvUggWx9bZXUALA7/oCMEYvCo+C4Bj5tLLvhLPQmn6lokJc0KKHnoQ2A4x7EIkKC03mYcKYCeOlzRiMV+SJxwHA2Vc8GLLfnUZRAw0fujjSPXLC0PB0I7ASrMMRAJCNGlPLy2Q== openpgp:0xCCB310CC"
        ];
        shell = config.programs.fish.package;
      };
    };

  flake.modules.homeManager.william =
    {
      config,
      pkgs,
      ...
    }:
    {
      # we need to force as home-manager reflects nix-darwin, which is disabled
      # due to its lack of support for single-user setups.
      nix.enable = lib.mkForce true;

      nix.settings.builders-use-substitutes = true;

      programs = {
        fish.enable = true;
        go.enable = true;
        git = {
          settings = {
            author = {
              inherit (config.programs.git.settings.user) email name;
            };
            committer = {
              inherit (config.programs.git.settings.user) email name;
            };
            user = {
              email = "git@artero.dev";
              handle = lib.mkDefault "wwmoraes";
              name = "William Artero";
            };
          };
          signing = {
            key = config.programs.gpg.settings.default-key;
          };
        };
        gpg = {
          enable = true;
          publicKeys = [
            {
              source = ./wwmoraes.asc;
              trust = "ultimate";
            }
          ];

          settings = rec {
            # Default key ID to use (helpful with throw-keyids)
            default-key = "32B4330B1B66828E4A969EEBEED994645D7C9BDE"; # gitleaks:allow
            default-keyserver-url = "https://artero.dev/pgp.asc";
            sig-keyserver-url = "https://artero.dev/pgp.asc";
            trusted-key = default-key;
          };
        };
      };

      stylix = {
        enable = true;

        base16Scheme = inputs.tinted-theming + /base16/ashes.yaml;

        fonts = {
          emoji = {
            package = pkgs.nerd-fonts.fira-code;
            name = "FiraCode Nerd Font";
          };
          monospace = {
            package = pkgs.nerd-fonts.fira-code;
            name = "FiraCode Nerd Font Propo";
          };
          sansSerif = {
            package = pkgs.nerd-fonts.fira-code;
            name = "FiraCode Nerd Font Propo";
          };
          serif = {
            package = pkgs.nerd-fonts.fira-code;
            name = "FiraCode Nerd Font Propo";
          };
          sizes = {
            applications = 16;
            desktop = 14;
            popups = 14;
            terminal = 16;
          };
        };

        targets = {
          lazygit.colors.override.withHashtag = {
            base03 = "#3E484F";
          };
          zellij.colors.override.withHashtag = {
            base04 = "#3E484F";
            base05 = "#6C7D89";
          };
        };
      };
      xdg.configFile = {
        "git/mailmap" = {
          text = ''
            William Artero <git@artero.dev>
            William Artero <git@artero.dev> <github@artero.dev>
            William Artero <git@artero.dev> <william.artero@dafiti.com.br>
            William Artero <git@artero.dev> <william.moraesartero@messagebird.com>
            William Artero <git@artero.dev> <william@artero.dev>
            William Artero <git@artero.dev> <william@dft-sp-wkn623.dafiti.local>
            William Artero <git@artero.dev> <williamwmoraes@gmail.com>
            William Artero <git@artero.dev> <wwmoraes@users.noreply.github.com>
            GitHub Actions <actions@github.com>
            GitHub Actions <actions@github.com> <41898282+github-actions[bot]@users.noreply.github.com>
            GitHub Actions <actions@github.com> <49699333+dependabot[bot]@users.noreply.github.com>
            GitHub Actions <actions@github.com> <49736102+kodiakhq[bot]@users.noreply.github.com>
            GitHub Actions <actions@github.com> <66853113+pre-commit-ci[bot]@users.noreply.github.com>
          '';
        };
      };
    };

  flake.modules.homeManager.william'personal = {
    targets.darwin.linux-builder = {
      enable = false;
      config = {
      };
    };
  };
}

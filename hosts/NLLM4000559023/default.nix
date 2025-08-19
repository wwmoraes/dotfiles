{
  config,
  ...
}:
{
  environment.etc = {
    "u2f_mappings" = {
      enable = true;
      # nix run nixpkgs#pam_u2f -- --pin-verification --nouser
      text = builtins.concatStringsSep ":" [
        config.system.primaryUser
        "9UPwj5JJEdy8522UZdRP9fgfmTF5ftsyz7T7720v5WT0A2g8KvMu6EgzDDiu9S3HjtWQAcr30KqKTQqU6A+YFw==,S4pnyNc2jrq0JKkcXJfwTo/smJIOhWsf7Zkd6eS7I+Xk/DaF9FNQPEwjyBiT0CjtQ8xWNs79iTLfEgWmowKzRw==,es256,+presence+pin" # DevSrvsID:4298640370, serial number 23433126
      ];
    };
  };
}

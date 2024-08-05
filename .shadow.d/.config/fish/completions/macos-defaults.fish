command -q macos-defaults; or exit

complete -ec macos-defaults

complete -c macos-defaults -n "__fish_use_subcommand" -s d -l dry-run -d 'Don\'t actually run anything'
complete -c macos-defaults -n "__fish_use_subcommand" -s v -l verbose -d 'More output per occurrence'
complete -c macos-defaults -n "__fish_use_subcommand" -s q -l quiet -d 'Less output per occurrence'
complete -c macos-defaults -n "__fish_use_subcommand" -s h -l help -d 'Print help'
complete -c macos-defaults -n "__fish_use_subcommand" -s V -l version -d 'Print version'
complete -c macos-defaults -n "__fish_use_subcommand" -f -a "apply" -d 'Set macOS defaults in plist files'
complete -c macos-defaults -n "__fish_use_subcommand" -f -a "completions" -d 'Generate shell completions to stdout'
complete -c macos-defaults -n "__fish_use_subcommand" -f -a "dump" -d 'Dump existing defaults as YAML'
complete -c macos-defaults -n "__fish_use_subcommand" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c macos-defaults -n "__fish_seen_subcommand_from apply" -s v -l verbose -d 'More output per occurrence'
complete -c macos-defaults -n "__fish_seen_subcommand_from apply" -s q -l quiet -d 'Less output per occurrence'
complete -c macos-defaults -n "__fish_seen_subcommand_from apply" -s h -l help -d 'Print help'
complete -c macos-defaults -n "__fish_seen_subcommand_from completions" -s v -l verbose -d 'More output per occurrence'
complete -c macos-defaults -n "__fish_seen_subcommand_from completions" -s q -l quiet -d 'Less output per occurrence'
complete -c macos-defaults -n "__fish_seen_subcommand_from completions" -s h -l help -d 'Print help'
complete -c macos-defaults -n "__fish_seen_subcommand_from dump" -s d -l domain -d 'Domain to generate' -r
complete -c macos-defaults -n "__fish_seen_subcommand_from dump" -s c -l current-host -d 'Read from the current host'
complete -c macos-defaults -n "__fish_seen_subcommand_from dump" -s g -l global-domain -d 'Read from the global domain'
complete -c macos-defaults -n "__fish_seen_subcommand_from dump" -s v -l verbose -d 'More output per occurrence'
complete -c macos-defaults -n "__fish_seen_subcommand_from dump" -s q -l quiet -d 'Less output per occurrence'
complete -c macos-defaults -n "__fish_seen_subcommand_from dump" -s h -l help -d 'Print help'
complete -c macos-defaults -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from apply; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from dump; and not __fish_seen_subcommand_from help" -f -a "apply" -d 'Set macOS defaults in plist files'
complete -c macos-defaults -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from apply; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from dump; and not __fish_seen_subcommand_from help" -f -a "completions" -d 'Generate shell completions to stdout'
complete -c macos-defaults -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from apply; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from dump; and not __fish_seen_subcommand_from help" -f -a "dump" -d 'Dump existing defaults as YAML'
complete -c macos-defaults -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from apply; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from dump; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'

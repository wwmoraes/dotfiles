# only apply on interactive shells
status --is-interactive; or exit

if command -q grc
  alias ls="grc ls -CF --color"
end

if command -q op
  command -q brew; and alias brew="op plugin run -- brew"
  command -q doctl; and alias doctl="op plugin run -- doctl"
  command -q gh; and alias gh="op plugin run -- gh"
  command -q pulumi; and alias pulumi="op plugin run -- pulumi"
end

alias chezmoi="direnv exec ~/.local/share/chezmoi chezmoi"

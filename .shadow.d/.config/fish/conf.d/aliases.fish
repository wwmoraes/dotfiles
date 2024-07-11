# only apply on interactive shells
status --is-interactive; or exit

if command -q grc
  alias ls="grc ls -CF --color"
end

if command -q op
  alias brew="op plugin run -- brew"
  alias doctl="op plugin run -- doctl"
  alias gh="op plugin run -- gh"
  alias hub="op plugin run -- hub"
  alias pulumi="op plugin run -- pulumi"
end

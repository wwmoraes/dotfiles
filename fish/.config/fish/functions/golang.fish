function golang -a cmd -d "go wrapper with commands that Google forgot" -w go
  switch "$cmd"
  case install
    # needed because go install is a piece of shit hardcoded to install only
    # on the same arch as the compiler itself. If you try to cross-compile,
    # you'll get:
    #   cannot install cross-compiled binaries when GOBIN is set
    # and if GOBIN is unset, you get no binaries installed whatsoever ¯\_(ツ)_/¯
    set -l GOARCH (lipo -archs (which go) | cut -d' ' -f1)
    switch $GOARCH
    case x86_64
      set GOARCH amd64
    end

    env GOARCH=$GOARCH go install $argv[2]

  case unget
    test (count $argv) -lt 2; and echo "usage: g $argv[1] [packages]" && return 1

    echo go: removing $argv[2]

    # thank you go-import-redirector for the brilliant idea of having a HTTP meta header redirection
    set -l package (curl -sSL $argv[2] | awk 'match($0, /go-import content=.* git https:\/\/(.*)"/, m) {print m[1]}')
    test "$package" = ""; and set -l package $argv[2]

    # better safe than sorry
    set -q GOPATH; or set -l GOPATH (go env GOPATH)

    set -l splitPackage (string split / $package)
    # remove src
    test -d $GOPATH/src/$package
    and rm -rf $GOPATH/src/$package
    # remove bin
    test -f $GOPATH/bin/$splitPackage[3]
    and rm -rf $GOPATH/bin/$splitPackage[3]
    # remove mod
    test -d $GOPATH/pkg/mod/$package
    and rm -rf $GOPATH/pkg/mod/$package
    # remove cache
    test -d $GOPATH/pkg/mod/cache/download/$argv[2]
    and rm -rf $GOPATH/pkg/mod/cache/download/$argv[2]

    # remove go.mod dependency
    if test -f go.mod
      sed -i -e '/'(echo $argv[2] | sed -E 's/([./])/\\\\\1/g')'/d' go.mod
      go mod tidy
    end
  case "" "*"
    go $argv
  end
end

complete -xc golang -n __fish_use_subcommand -a unget -d "removes dependencies and its build artifacts"

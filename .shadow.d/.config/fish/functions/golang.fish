function golang -a cmd -d "go wrapper with commands that Google forgot" -w go
  command -q go; or echo "go is not installed" && return

  switch "$cmd"
  case install
    env -u GOBIN go install $argv[2]

    set -l goBinPath (go env GOPATH)/bin
    set -l goOsArchBinPath $goBinPath/(go env GOOS)_(go env GOARCH)
    find $goOsArchBinPath -type f -exec mv {} $goBinPath \;
    rmdir $goOsArchBinPath
  case unget
    test (count $argv) -lt 2; and echo "usage: g $argv[1] [packages]" && return 1

    echo "go: removing $argv[2]"

    # thank you go-import-redirector for the brilliant idea of having a HTTP meta header redirection
    set -l package (curl -sSL $argv[2] | gawk 'match($0, /go-import content=.* git https:\/\/(.*)"/, m) {print m[1]}')
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
  case coverage
    set -q GOCOVERPROFILE; or set -l GOCOVERPROFILE tmp/test.gcov
    go test -race -coverprofile=$GOCOVERPROFILE ./...
    go tool cover -func=$GOCOVERPROFILE
  case "" "*"
    go $argv
  end
end

function dotfiles -d "Setup dotfiles"
    pushd ~/.dotfiles > /dev/null
    make install
    popd > /dev/null
end
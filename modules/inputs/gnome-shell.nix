{
  # work environment doesn't like GitLab. Thanks CISO LOL
  flake-file.inputs.gnome-shell = {
    url = "github:GNOME/gnome-shell";
    flake = false;
  };
}

{
  flake.modules.darwin.default = {
    users.groups = {
      admin.gid = 80;
      wheel.gid = 0;
    };
  };
}

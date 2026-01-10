{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options = with types; {
    mode = mkOption {
      type = enum [
        "ansible"
        "boot"
        "data"
        "dependency"
        "system"
        "user"
        "yq"
      ];
      description = ''
        Order of execution:
        - boot
        - dependency
        - data
        - yq
        - system
        - user
        - ansible

        `boot` executes directly via /bin/sh as part of
        cloud-init-local.service's early boot process. This is why it must
        contain no hash-bang. See cloud-init docs for more info
        https://docs.cloud-init.io/en/latest/reference/examples.html#run-commands-on-first-boot

        `dependency` executes before the regular dependency resolution
        workflow in pkg/cidata/cidata.TEMPLATE.d/boot/30-install-packages.sh
        If skipDefaultDependencyResolution is set on at least one
        `dependency` mode provisioning script, the regular dependency
        resolution workflow in pkg/cidata/cidata.TEMPLATE.d/boot/30-install-packages.sh
        will be skipped.

        `data` is a file that is written to the guest filesystem and
        not executed at all. The file is written after the boot scripts,
        but before any other provisioning scripts are run. Note that
        reverse-sshfs mounts are not established at this time; other mount
        types are already mounted. The `path` and `content` properties
        are required. The `file` property can be used the same way as with
        other provisioning scripts, in which case `content` must be empty.
        The `owner` defaults to "root:root"; the permissions default to
        644. The `overwrite` property defaults to `true`, in which case
        the file will be overwritten on every boot.
        `path`, `contents`, and `owner` are evaluated as guest templates (see above).

        Create or edit a file in the guest filesystem by using `yq`.
        The file specified by `path` will be updated by `expression`.
        An empty file of the required `format` will be created if it does not yet exist.
        `format` defaults to "auto" and will be detected by file extension of `path`.
        If the extension is not recognized by `yq` then `format` must be set to a
        value from this list:
          "auto", "csv", "ini", "json", "props", "tsv", "toml", "xml", "yaml"
        See https://github.com/mikefarah/yq for more info.
        Any missing directories will be created as needed.
        The file permissions will be set to the specified value.
        The file and directory creation will be performed as the specified owner.
        If the existing file is not writable by the specified owner, the operation will fail.
        `path` and `expression` are required.
        `owner` and `permissions` are optional. Defaults to "root:root" and 644.

        `system` executes this provision with root privileges.

        `user` executes this provision without root privileges.

        `ansible` executes after other scripts finish.
        It requires `ansible-playbook` command to be installed.
        Environment variables such as ANSIBLE_CONFIG can be used to
        control the behavior of the playbook execution.
        See ansible docs, and `ansible-config`, for more info
        https://docs.ansible.com/ansible/latest/playbook_guide/

        DEPRECATED The ansible mode is deprecated, and should not be used.
        Instead call ansible-playbook directly, either from the host after
        the instance is started or from the instance by running ansible
        locally instead.
      '';
    };
    script = mkOption {
      type = nullOr str;
      default = null;
    };
    file = mkOption {
      type = nullOr (submodule ./_file.nix);
      default = null;
    };
  };
}

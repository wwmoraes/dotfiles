{ pkgs
, ...
}: {
	environment.systemPackages = [
		pkgs.unstable.helix
		pkgs.unstable.bash-language-server
		# pkgs.unstable.buf-language-server
		pkgs.unstable.efm-langserver
		pkgs.unstable.lua-language-server
		pkgs.unstable.nil
		pkgs.unstable.taplo
		pkgs.unstable.texlab
		pkgs.unstable.typescript-language-server
		pkgs.unstable.vscode-langservers-extracted
		pkgs.unstable.yaml-language-server
	];

	environment.variables = {
		EDITOR = "hx";
		SUDO_EDITOR = "hx";
		VISUAL = "hx";
	};
}

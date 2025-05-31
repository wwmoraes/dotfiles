{ pkgs
, ...
}: {
	environment.systemPackages = [
		pkgs.unstable.helix-gpt
		pkgs.unstable.llama-cpp
		pkgs.unstable.lsp-ai
	];

	homebrew.casks = [
		"ollama"
	];
}


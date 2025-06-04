{ pkgs
, config
, lib
, ...
}: {
	home-manager.sharedModules = [
		{
			programs.dircolors = {
				enable = true;
			};
		}
	];
}

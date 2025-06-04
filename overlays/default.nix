{
	default = final: prev: with prev.lib; foldl' (flip extends) (_: prev) [
		(final: prev: {
			lib = prev.lib // {
				local = rec {
					globalCask = name: {
						name = name;
						args = { appdir = "/Applications"; };
					};
					unindent = str: let
						indent = builtins.head (builtins.match "^[\n]*([[:space:]]*).*" str);
					in if indent == "" then str else (prev.lib.concatLines (map
						(prev.lib.removePrefix indent)
						(prev.lib.splitString "\n" (prev.lib.trim str))
					));
					unindentTrim = str: unindent (prev.lib.removePrefix "\n" (prev.lib.removeSuffix "\n" str));
					foldString = str: prev.lib.strings.concatMapStringsSep " " prev.lib.trim (prev.lib.splitString "\n" (prev.lib.trim str));
				};
			};
		})
	] final;
}

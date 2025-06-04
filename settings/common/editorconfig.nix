{ lib
, ...
}: {
	home-manager.sharedModules = [
		{
			editorconfig = {
				enable = true;
				settings = ({
					"*" = {
						charset = "utf-8";
						# end_of_line = "lf";
						indent_size = "tab";
						indent_style = "tab";
						insert_final_newline = true;
						tab_width = 2;
						trim_trailing_whitespace = true;
					};
				}) // lib.genAttrs [ ## must use tab
					"*.go"
					"*.mk"
					".git*"
					"Makefile"
					"go.{mod,work}"
				] (_: {
					indent_style = "tab";
				}) // lib.genAttrs [ ## must use spaces
					"*.Dockerfile"
					"*.{md,yml,yaml}"
					"Dockerfile"
				] (_: {
					indent_style = "space";
				}) // lib.genAttrs [ ## generated content
					"*.lock"
					"*.{diff,patch}"
					".direnv/**"
					".git/**"
				] (_: {
					charset = "unset";
					indent_size = "unset";
					indent_style = "unset";
					insert_final_newline = "unset";
					tab_width = "unset";
					trim_trailing_whitespace = "unset";
				});
			};
		}
	];
}

require("paq") {
  "savq/paq-nvim", -- Let Paq manage itself
  -- LSP
  "nvim-treesitter/nvim-treesitter",
  "neovim/nvim-lspconfig",
  -- auto-completion
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",
  -- Golang
  "ray-x/go.nvim",
  -- Dark+ theme
  "Mofiqul/vscode.nvim",
}

--- color
vim.o.background = "dark"
vim.cmd.colorscheme("vscode")

--- indentation
-- vim.o.autoindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 8

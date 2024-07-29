local capabilities = require("cmp_nvim_lsp").default_capabilities()

---@alias lspconfig.ConfigSetup fun(user_config: lspconfig.Config)

---@class lspconfig.Config
---@field setup lspconfig.ConfigSetup

---@type table<string, lspconfig.Config>
local lsp = require("lspconfig")

lsp["gopls"].setup({
  cmd = { "gopls" },
  capabilities = capabilities,
  settings = {
    gopls = {
      experimentalPostfixCompletions = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
    },
  },
  init_options = {
    usePlaceholders = true,
  }
})

require("nvim-treesitter.configs").setup({
  auto_install = true,
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "go" },
  ignore_install = {},
  modules = {},
  sync_install = true,
})

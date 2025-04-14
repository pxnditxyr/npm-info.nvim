local M = {}

vim.api.nvim_set_hl( 0, "NpmLatest", { fg = "#50fa7b" } )
vim.api.nvim_set_hl( 0, "NpmBeta", { fg = "#ffb86c" } )
vim.api.nvim_set_hl( 0, "NpmOutdated", { fg = "#ff5555" } )

function M.setup( user_config )
  require( "npm-info.config" ).setup( user_config )
  require( "npm-info.autocmds" ).setup()
end

return M

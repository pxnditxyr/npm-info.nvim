local M = {}

local default_config = {
  icons = {
    beta = "󰂡",
    current = "",
    isLatest = "",
    outdated = "",
    unstable = "",
  },
  hl_groups = {
    beta = "DiagnosticWarn",
    current  = "Comment",
    isLatest = "NpmLatest",
    outdated = "NpmOutdated",
    unstable = "NpmBeta",
  },
  messages = {
    beta = "beta",
    current = "Current",
    isLatest = "is Latest",
    outdated = "Latest %s",
    unstable = "unstable",
  },
  show_installed = true,
}

function M.setup( user_config )
  M.config = vim.tbl_deep_extend( "force", default_config, user_config or {} )
end

function M.get()
  return M.config
end

return M

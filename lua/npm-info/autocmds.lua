local api = vim.api
local core = require( "npm-info.core" )
local config = require( "npm-info.config" )

local function setup_autocmds ()
  local cfg = config.get()
  local group = api.nvim_create_augroup( "npm-info", {} )

  api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    group = group,
    pattern = "package.json",
    callback = function ( event )
      api.nvim_buf_clear_namespace( event.buf, core.namespace, 0, -1 )

      local dependencies = core.parse_dependencies( event.buf )

      if #dependencies == 0 then return end

      if cfg.show_installed then
        vim.system( { "npm", "list", "--json", "--depth=0" }, {}, function( out )
          vim.schedule( function ()
            core.handle_npm_results( out, "list", dependencies, event.buf )
          end )
        end )
      end

      vim.system( { "npm", "outdated", "--json" }, {}, function( out )
        vim.schedule( function ()
          core.handle_npm_results( out, "outdated", dependencies, event.buf )
        end )
      end )
    end
  })
end

return {
  setup = setup_autocmds,
}

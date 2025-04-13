local M = {}

local function setup_autocmds()
  vim.treesitter.query.set(
    "json",
    "node_dependencies",
    [[
      (pair
        key: (string
          (string_content) @key (#match? @key "dependencies|devDependencies|peerDependencies|optionalDependencies")
        )
        value: (object
          (pair
            key: (string (string_content) @depen)
          )
        )
      )
    ]]
  )

  local group = vim.api.nvim_create_augroup( "npm-info", {} )

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    pattern = "package.json",
    group = group,
    callback = function( event )
      local parser = vim.treesitter.get_parser( event.buf, "json" )
      local tree = parser:parse()[ 1 ]
      if not tree then return end

      local query = vim.treesitter.query.get( "json", "node_dependencies" )
      if not query then return end

      local dependencies = {}
      for id, node in query:iter_captures( tree:root(), event.buf ) do
        if query.captures[ id ] == "depen" then
          table.insert( dependencies, {
            name = vim.treesitter.get_node_text( node, event.buf ),
            line = node:start(),
          } )
        end
      end

      if #dependencies == 0 then return end

      local namespace = vim.api.nvim_create_namespace( "node-deps" )
      vim.api.nvim_buf_clear_namespace( event.buf, namespace, 0, -1 )

      -- Función para manejar los resultados de npm
      local handle_npm_results = function( out, type )
        if out.code ~= 0 and ( type == "list" or out.code ~= 1 ) then return end

        local success, data = pcall( vim.json.decode, out.stdout )
        if not success or not data then return end

        for _, dep in ipairs( dependencies ) do
          local info = data[ dep.name ] or ( data.dependencies and data.dependencies[ dep.name ] )
          if info then
            local text, hl
            if type == "outdated" then
              if string.find(info.current, "-") then
                text = string.format( '⚠️🔄 %s (unstable beta)', info.current )
                hl = "WarningMsg"
              else
                text = string.format( '🚀👆 %s (new version)', info.latest )
                hl = "Error"
              end
            else
              text = string.format( ' ⚡ %s', info.version )
              hl = "Comment"
            end

            vim.api.nvim_buf_set_extmark( event.buf, namespace, dep.line, 0, {
              virt_text = {{ text, hl }},
              virt_text_pos = "eol",
            } )
          end
        end
      end

      vim.system({ "npm", "list", "--json", "--depth=0" }, {}, function( out )
        vim.schedule( function() handle_npm_results( out, "list" ) end )
      end)

      vim.system({ "npm", "outdated", "--json" }, {}, function(out)
        vim.schedule( function() handle_npm_results( out, "outdated" ) end )
      end)
    end
  })
end

function M.setup()
  setup_autocmds()
end

return M

local api = vim.api
local config = require( "npm-info.config" )
local M = {}

M.namespace = api.nvim_create_namespace( "npm-info.deps" )

function M.parse_dependencies( bufnr )
  local parser = vim.treesitter.get_parser( bufnr, "json" )
  local tree = parser:parse()[ 1 ]
  if not tree then return {} end

  local query = vim.treesitter.query.get( "json", "node_dependencies" )
  if not query then return {} end

  local dependencies = {}

  for id, node in query:iter_captures( tree:root(), bufnr ) do
    if query.captures[ id ] == "depen" then
      table.insert( dependencies, {
        name = vim.treesitter.get_node_text( node, bufnr ),
        line = node:start(),
      } )
    end
  end

  return dependencies
end

function M.handle_npm_results( result, dep_type, dependencies, bufnr )
  local cfg = config.get()

  if result.code ~= 0 and ( dep_type == "list" or result.code ~= 1 ) then
    return
  end

  local success, data = pcall( vim.json.decode, result.stdout )
  if not success or not data then return end

  for _, dep in ipairs( dependencies ) do
    local info =
      data[ dep.name ] or ( data.dependencies and data.dependencies[ dep.name ] )
    if info then
      local text, hl
      if dep_type == "outdated" then
        if string.find( info.current, "-" ) then
          text = string.format(
            "%s %s %s",
            cfg.icons.beta,
            info.current,
            cfg.messages.beta
          )
          hl = cfg.hl_groups.beta
        else
          text = string.format(
            "%s %s → %s %s",
            cfg.icons.outdated,
            info.current,
            cfg.icons.isLatest,
            string.format(
              cfg.messages.outdated,
              info.latest
            )
          )
          hl = cfg.hl_groups.outdated
        end
      elseif dep_type == "list" then
        text = string.format(
          "%s %s %s",
          cfg.icons.current,
          info.version,
          cfg.messages.current
        )
        hl = cfg.hl_groups.current
      end

      api.nvim_buf_set_extmark( bufnr, M.namespace, dep.line, 0, {
        virt_text = {{ text, hl }},
        virt_text_pos = "eol",
      } )
    end
  end
end

return M

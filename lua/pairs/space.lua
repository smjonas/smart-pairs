local M = {}
local u = require('pairs.utils')
local P = require('pairs')
local fb = require('pairs.fallback')

local function type_aux()
  local left_line, right_line = u.get_cursor_lr()

  for _, pair in ipairs(P:get_pairs()) do
    local pl = u.escape(pair.left) .. '$'
    local pr = '^' .. u.escape(pair.right)
    if left_line:match(pl) and right_line:match(pr) then
      if not pair.opts.enable_smart_space then
        fb.space()
        return
      end
      right_line = ' ' .. right_line
      break
    end
  end

  left_line = left_line .. ' '
  vim.api.nvim_set_current_line(left_line .. right_line)
  u.set_cursor(0, left_line)
end

function M.type()
  if not u.enable(P.space.enable_cond) then
    return P.space.enable_fallback() or ''
  end

  u.call(P.space.before_hook)
  type_aux()
  u.call(P.space.after_hook)
  return ''
end

return M

local M = {}

M.isWindowVisible = function(win_id)
    if win_id ~= nil and vim.api.nvim_win_is_valid(win_id) then
        return true
    else
        return false
    end
end

return M

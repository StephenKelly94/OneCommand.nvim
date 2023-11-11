local M = {}

M.isWindowVisible = function(win_id)
    if win_id ~= nil and vim.api.nvim_win_is_valid(win_id) then
        return true
    else
        return false
    end
end

local log_levels = { "trace", "debug", "info", "warn", "error", "fatal" }
local function set_log_level()
    local log_level = vim.g.one_command_log_level

    for _, level in pairs(log_levels) do
        if level == log_level then
            return log_level
        end
    end

    return "warn" -- default, if user hasn't set to one from log_levels
end

local log_level = set_log_level()
M.log = require("plenary.log").new({
    plugin = "OneCommand",
    level = log_level,
})


return M

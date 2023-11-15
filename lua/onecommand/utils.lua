local M = {}

M.isWindowVisible = function(win_id)
    if win_id ~= nil and vim.api.nvim_win_is_valid(win_id) then
        return true
    else
        return false
    end
end

M.splitStringBySpace = function(string)
    return M.stringToList(string, "%S+")
end

M.splitStringByNewline = function(string)
    return M.stringToList(string, "[^\r\n]+")
end

M.stringToList = function(string, splitChar)
    local result = {}

    for word in string:gmatch(splitChar) do
        table.insert(result, word)
    end

    return result
end

return M

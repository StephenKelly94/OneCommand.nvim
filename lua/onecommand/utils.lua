local M = {}


M.stringToCommand = function(string)
    local words = {}

    for word in string:gmatch("%S+") do
        table.insert(words, word)
    end

    return words

end

return M

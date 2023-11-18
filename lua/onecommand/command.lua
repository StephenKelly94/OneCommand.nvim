local utils = require("onecommand.utils")

local M = {}

local default_config = {
    command_limit = 100
}

-- TODO: Consider using some file to 'remember'
local commands = {}
local last_command_output = {}

local add_command_to_history = function(command)
    if command ~= nil and command:gsub("%s+", "") ~= "" then
        -- Prepend to list so newest command is at the front
        table.insert(commands, 1, command)
        if #commands > default_config.command_limit then
            commands = { unpack(commands, 1, default_config.command_limit) }
        end
    end
end

M.set_config = function(config)
    default_config = vim.tbl_deep_extend("force", default_config, config)
end

M.prompt_input = function()
    local command = vim.fn.input("Run Command: ")
    return command
end

M.run_command = function(command, addToHistory, callback)
    if addToHistory then
        add_command_to_history(command)
    end

    local parsed_command = vim.split(command, " ")

    local result_function = vim.schedule_wrap(function(result)
        if result.stderr ~= nil then
            local stdout = vim.split(result.stdout, "\n", {trimempty=true})
            last_command_output = stdout
            callback(stdout)
        else
            print(result.stderr)
        end
    end)

    vim.system(parsed_command, {text = true}, result_function)
end

M.get_command_history = function()
    return commands
end

M.get_last_command = function()
    -- Return first element because it is the last command
    return commands[1]
end

M.get_last_command_output = function()
    return last_command_output
end

M.run_last_command = function(callback)
    M.run_command(M.get_last_command(), false, callback)
end

return M

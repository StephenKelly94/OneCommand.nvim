local M = {}
-- TODO: Consider using some file to 'remember'
local commands = {}
local last_command_output = {}
local COMMAND_LIMIT = 100

local add_command_to_history = function(command)
    if command ~= nil and command:gsub('%s+', '') ~= '' then
        -- Prepend to list so newest command is at the front
        table.insert(commands, 1, command)
        if #commands > COMMAND_LIMIT then
            commands =  {unpack(commands, 1, COMMAND_LIMIT)}
        end
    end
end

M.prompt_input = function()
	local command = vim.fn.input('Run Command: ')
    return command
end

M.get_last_command = function()
    -- Return first element because it is the last command
    return commands[1]
end

M.get_command_history = function()
    return commands
end

M.run_command = function(command, addToHistory, callback)
    if addToHistory then
        add_command_to_history(command)
    end

	local job_id = vim.fn.jobstart(command, {
		on_stdout = function(_, stdout, _)
            -- If there is date remove the last EOL from the output
            if stdout ~= nil and #stdout > 0 then
                table.remove(stdout, #stdout)
            end
            last_command_output = stdout
            callback(stdout)
        end,
		stdout_buffered = true,
		stderr_buffered = true,
	})
	return job_id
end

M.run_last_command = function(callback)
    M.run_command(M.get_last_command(), false, callback)
end

M.get_last_command_output = function()
    return last_command_output
end

return M

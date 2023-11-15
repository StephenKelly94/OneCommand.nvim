local M = {}
-- TODO: Consider using some file to 'remember'
local commands = {}
local last_command_output = {}
local COMMAND_LIMIT = 100

local add_command_to_history = function(command)
    if command ~= nil and command:gsub('%s+', '') ~= '' then
        table.insert(commands, 1, command)
        if #commands > COMMAND_LIMIT then
            commands =  {unpack(commands, 1, COMMAND_LIMIT)}
        end
    end
end

M.prompt_input = function()
	-- Prompt for user input
	local command = vim.fn.input('Run Command: ')
    add_command_to_history(command)
    return command
end

M.get_last_command = function()
    return commands[#commands]
end

M.get_command_history = function()
    return commands
end

M.run_command = function(command, callback)
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
    M.run_command(M.get_last_command(), callback)
end

M.get_last_command_output = function()
    return last_command_output
end

return M

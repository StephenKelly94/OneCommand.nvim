local M = {}
local commands = {}

M.prompt_input = function()
	-- Prompt for user input
	local command = vim.fn.input("Run Command: ")
    table.insert(commands, command)
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

return M

local M = {}
local commands = {}

M.prompt_input = function()
	-- Prompt for user input
	local command = vim.fn.input("Run Command: ")
    table.insert(commands, command)
    return command
end

M.get_command_history = function()
    return commands
end

M.run_command = function(command, callback)
	local job_id = vim.fn.jobstart(command, {
		on_stdout = callback,
		stdout_buffered = true,
		stderr_buffered = true,
	})
	return job_id
end

return M

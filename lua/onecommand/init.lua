local command = require("onecommand.command")
local ui = require("onecommand.ui")

local M = {}

M.run_command = function(input)
    command.run_command(input, true, function(stdout)
        ui.open_output_window(stdout)
    end)
end

M.prompt_run_command = function()
    local user_input = command.prompt_input()
    if user_input ~= nil and user_input ~= "" then
        M.run_command(user_input)
    end
end

M.show_last_command_output = function()
    ui.open_output_window(command.get_last_command_output())
end

M.view_history = function()
    local history = command.get_command_history()
    ui.show_command_history(history, function(choice)
        if choice ~= nil and choice ~= "" then
            M.run_command(choice)
        end
    end)
end

M.setup = function(config)
    if config ~= nil then
        ui.set_config(config.ui)
        command.set_config(config.command)
    end
end

return M

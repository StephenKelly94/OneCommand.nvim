local command = require("onecommand.command")
local ui = require("onecommand.ui")
local M = {}


M.run_command = function(input)
    local opts = ui.create_ui_config()
    command.run_command(input, function(_, stdout, _)
        ui.create_output_popup(stdout, opts)
    end)
end

M.prompt_run_command = function()
    local user_input = command.prompt_input()
    M.run_command(user_input)
end


M.view_history = function()
    -- TODO history viewer
    local history = command.get_command_history()
    ui.show_history(history, function (choice)
        if choice ~= nil and choice ~= "" then
            M.run_command(choice)
        end
    end)
end

M.setup = function(config)
    if not config then
        config = {}
    end
end

return M

-- vim.tbl_deep_extend("force", M._settings, config)
-- :lua vim.ui.select({'a', 'b'}, {prompt= 'TEST'}, function(choice) print(choice) end)
-- :lua vim.ui.input({prompt = 'TEST'}, function(input) print(input) end)
-- :lua vim.system({'ls -lah'}, {text = true}, function(obj) print(obj.stdout) end)
-- :lua package.loaded["onecommand"] = nil
-- :lua require("onecommand").test()
--
-- vim.schedule(function()
--     vim.system(words, { text = true }, function(obj)
--         local opts = create_popup_opts()
--         create_popup(obj.stdout, opts)
--         print(vim.inspect(obj.stdout))
--     end)
-- end)

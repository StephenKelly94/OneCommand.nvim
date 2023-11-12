local popup = require("plenary.popup")
local command = require("onecommand.command")
local utils = require("onecommand.utils")
local log = utils.log

local M = {}

local buf_handle = nil
local win_id = nil

-- TODO: Test sizes
local width = math.floor(vim.o.columns * 0.8)
local height = math.floor(vim.o.lines * 0.8)

local default_config = {
    title = "One Command",
    titlehighlight = "OneCommandTitle",
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    borderhighlight = "OneCommandBorder",
}

local set_keys = function()
    -- Close the popup buffer and window on keypress (optional)
    vim.api.nvim_buf_set_keymap(buf_handle, "n", "q", "", {
        callback = function()
            M.close_output_window()
        end,
        noremap = true,
        silent = true,
    })
    vim.api.nvim_buf_set_keymap(buf_handle, "n", "<ESC>", "", {
        callback = function()
            M.close_output_window()
        end,
        noremap = true,
        silent = true,
    })
    vim.api.nvim_buf_set_keymap(buf_handle, "n", "r", "", {
        callback = function()
            command.run_last_command(function(stdout)
                M.change_buffer_content(stdout)
            end)
        end,
        noremap = true,
        silent = true,
    })
end

local create_buffer = function()
    -- Create a new buffer for the popup
    buf_handle = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf_handle })
    set_keys()
    return buf_handle
end


M.set_config = function(config)
    default_config = vim.tbl_deep_extend("force", default_config, config)
end


M.change_buffer_content = function(content)
    log.trace("Set content")
    -- Toggle the buffer to modifiable then update content then toggle off
    vim.api.nvim_set_option_value("modifiable", true, { buf = buf_handle })
    vim.api.nvim_buf_set_lines(buf_handle, 0, #content, false, content)
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf_handle })
end

M.open_output_window = function(content)
    log.trace("Open Popup")
    if content ~= nil and next(content) ~= nil then
        if not utils.isWindowVisible(win_id) then
            create_buffer()
            M.change_buffer_content(content)
            local window_id, _ = popup.create(buf_handle, default_config)
            win_id = window_id
        else
            M.change_buffer_content(content)
        end
    else
        log.info("No content provided")
    end
end

M.close_output_window = function()
    log.trace("Closed popup")
    vim.api.nvim_win_close(win_id, true)
    win_id, buf_handle = nil, nil
end

M.show_command_history = function(history, callback)
    log.trace("View history")
    vim.ui.select(history, { prompt = "Command history" }, callback)
end

return M

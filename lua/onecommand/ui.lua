local command = require("onecommand.command")
local utils = require("onecommand.utils")

local M = {}

local if_nil = vim.F.if_nil

local buf_handle = nil
local win_id = nil

local default_config = {
    line_numbers = false,
    relative_numbers = false,
    modifiable = false,
    popup = {
        title = "One Command",
        title_pos = "center",
        footer = ' Quit = "q"/<esc> ------- Run last command = "r" ',
        footer_pos = "center",
        style = "minimal",
        relative = "editor",
        zindex = 50,
        border = "rounded",
    }
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
                M.set_buffer_content(stdout)
            end)
        end,
        noremap = true,
        silent = true,
    })
end

local create_buffer = function(content)
    -- Create a new buffer for the popup
    buf_handle = vim.api.nvim_create_buf(false, true)
    M.set_buffer_content(content)
    set_keys()
    return buf_handle
end

local get_popup_config = function()
    -- Use the length of the output or 80%, whichever is smaller
    local calculated_height = math.min(
        vim.api.nvim_buf_line_count(buf_handle),
        math.floor(vim.o.lines * 0.8)
    )

    local height = if_nil(default_config.popup.height, calculated_height)
    local width = if_nil(default_config.popup.width, math.floor(vim.o.columns * 0.8))

    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local adjusted_size =  {
        height = height,
        width = width,
        row = row,
        col = col,
    }
    return vim.tbl_deep_extend("force", default_config.popup, adjusted_size)
end

local create_popup = function()
    local window_id = vim.api.nvim_open_win(buf_handle, true, get_popup_config())
    win_id = window_id

    vim.api.nvim_set_option_value("number", default_config.line_numbers, { win = win_id })
    vim.api.nvim_set_option_value("relativenumber", default_config.relative_numbers, { win = win_id })
end


M.set_config = function(config)
    default_config = vim.tbl_deep_extend("force", default_config, config)
end

M.set_buffer_content = function(content)
    -- If it's not modifiable we need to make it modifiable then update it
    if not default_config.modifiable then
        vim.api.nvim_set_option_value("modifiable", true, { buf = buf_handle })
        vim.api.nvim_buf_set_lines(buf_handle, 0, -1, false, content)
    else
        vim.api.nvim_buf_set_lines(buf_handle, 0, -1, false, content)
    end
    vim.api.nvim_set_option_value("modifiable", default_config.modifiable, { buf = buf_handle })

    if utils.isWindowVisible(win_id) then
        -- Recalculate the sizes after updating content
        vim.api.nvim_win_set_config(win_id, get_popup_config())
    end
end

M.open_output_window = function(content)
    if content ~= nil and next(content) ~= nil then
        if not utils.isWindowVisible(win_id) then
            create_buffer(content)
            create_popup()
        else
            M.set_buffer_content(content)
        end
    end
end

M.close_output_window = function()
    vim.api.nvim_win_close(win_id, true)
    win_id, buf_handle = nil, nil
end

M.show_command_history = function(history, callback)
    vim.ui.select(history, { prompt = "Command history" }, callback)
end

return M

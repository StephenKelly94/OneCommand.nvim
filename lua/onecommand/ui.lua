local popup = require("plenary.popup")
local command = require("onecommand.command")
local utils = require("onecommand.utils")
local log = utils.log

local M = {}

local buf_handle = nil
local win_id = nil

local set_keys = function()
	-- Close the popup buffer and window on keypress (optional)
	vim.api.nvim_buf_set_keymap(buf_handle, "n", "q", "", {
		callback = function()
            M.close_command_prompt()
        end,
		noremap = true,
		silent = true,
	})
	vim.api.nvim_buf_set_keymap(buf_handle, "n", "<ESC>", "", {
		callback = function()
            M.close_command_prompt()
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


M.change_buffer_content = function(content)
    log.trace("Set content")
    -- Toggle the buffer to modifiable then update content then toggle off
	vim.api.nvim_set_option_value("modifiable", true, { buf = buf_handle })
	vim.api.nvim_buf_set_lines(buf_handle, 0, #content, false, content)
	vim.api.nvim_set_option_value("modifiable", false, { buf = buf_handle })
end

M.create_ui_config = function()
	-- Calculate the size for the centered Plenary popup window based on the current window dimensions
	local win_width = vim.fn.winwidth(0)
	local win_height = vim.fn.winheight(0)
	local width = math.min(math.floor(win_width * 0.8), 80)
	local height = math.min(math.floor(win_height * 0.8), 20)

	-- Calculate the position for the centered Plenary popup window
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)
	-- Open a new centered Plenary popup window with the buffer
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

	return {
		title = "One Command",
		style = "minimal",
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		borderchars = borderchars,
		borderhighlight = "FloatTitle",
	}
end

M.show_command_prompt = function(content, opts)
	if not utils.isWindowVisible(win_id) then
        log.trace("New popup")
		create_buffer()
		-- Set the content in the buffer
		M.change_buffer_content(content)
		local window_id, _ = popup.create(buf_handle, opts)

		win_id = window_id
	else
        log.trace("Reused popup")
		M.change_buffer_content(content)
	end
end

M.close_command_prompt = function()
    log.trace("Closed popup")
    vim.api.nvim_win_close(win_id, true)
	win_id, buf_handle = nil, nil
end

M.show_command_history = function(history, callback)
    log.trace("View history")
	vim.ui.select(history, { prompt = "Command history" }, callback)
end

return M

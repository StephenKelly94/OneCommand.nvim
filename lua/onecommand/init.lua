local M = {}

local plenary = require('plenary')

local function create_popup_opts ()
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
        title = 'One Command',
        style = 'minimal',
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        borderchars = borderchars,
        borderhighlight = "FloatTitle"
    }
end

local function create_popup(content, opts)
    -- Create a new buffer for the popup
    local buf = vim.api.nvim_create_buf(false, true)
    -- Set the content in the buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf})

    -- Close the popup buffer and window on keypress (optional)
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', string.format(':q!<CR>'), { noremap = true, silent = true })

    local win = plenary.popup.create(buf, opts)
end

M.test = function ()

    -- Prompt for user input
    local user_input = vim.fn.input('Run Command: ')

    -- Print the user input
    local result = vim.fn.systemlist(user_input)

    local opts = create_popup_opts()
    create_popup(result, opts)
end

return M

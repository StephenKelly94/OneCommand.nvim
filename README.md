# OneCommand.nvim
> Running quick repeatable commands with parsable output

`OneCommand.nvim` came about from my need to be able to run commands quickly
and repeatadly, such as running tests or SCP-ing files to a server after updating.

There are currently 2 ways that I know of doing this:
* Use `:!<command>` - The output of this is not easy to handle and work with.
* `<CTRL-z>` to exit, and `fg` to return - Can be a bit cumbersome and pollutes
command history.

## Features
* Prompts for command, runs it and displays the stdout in a popup window
* Saves previous commands to history so they can be searched and run again
* Saves the output of last command so it can be brought back up for reference

## Demo
**Note:** On the date command in the video I am manually pressing the refresh button.

### Default style
[Default style](https://github.com/StephenKelly94/OneCommand.nvim/assets/6800258/6681310c-fad5-48f4-a01d-3ee12954ba8a)

### [noice.nvim](https://github.com/folke/noice.nvim)


## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
    {
        "StephenKelly94/OneCommand.nvim",
        opts = {
            -- configuration here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            -- Set keybindings here
        },
    }
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
	use ("stephenkelly94/onecommand.nvim")
```

## Configuration
When configuring `onecommand` you need to use the setup function
```lua
require("onecommand").setup({
    -- configuration here
})
```

### Options
Here is a list of the options that are configurable with their default settings
```lua
{

}
```

## Usage
Here are the things you can do and which key binds you can use
```lua
vim.api.nvim_set_keymap(
    "n",
    "<Leader>xc",
    ':lua require("onecommand").prompt_run_command()<CR>',
    { noremap = true }
)

vim.api.nvim_set_keymap(
    "n",
    "<Leader>xh",
    ':lua require("onecommand").view_history()<CR>',
    { noremap = true }
)

vim.api.nvim_set_keymap(
    "n",
    "<Leader>xl",
    ':lua require("onecommand").show_last_command_output()<CR>',
    { noremap = true }
)
```

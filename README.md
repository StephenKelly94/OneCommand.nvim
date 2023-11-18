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

<!-- TODO: Add some gif/video of use -->

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)
Add x and y to lazy vim and packer etc.
```lua
    {
        "StephenKelly94/OneCommand.nvim",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    }
```

## Configuration
Here are the configuration parameters you can set, should be set through setup
function

## Usage
Here are the things you can do and which key binds you can use

## TODO
I am not sure if these are even possible
- Figure out how to use aliases (don't seem to work)
- Perhaps get terminal colors

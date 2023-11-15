local command = require("onecommand.command")

describe("Command", function()
    it("can run a command", function()
        local co = coroutine.running()

        local test_function = function (stdout)
            local ans = { "test" }
            assert.equals(stdout[0], ans[0])
            coroutine.resume(co)
        end

        command.run_command("echo test", true, test_function)
        coroutine.yield()
    end)

    it("can get command history", function()
        local co = coroutine.running()
        local count = 0
        local finish_callback = function()
            count = count + 1
            if count >= 2 then
                local history = command.get_command_history()
                -- Should be 3 because one is added in test before
                assert.equals(3, #history)
                coroutine.resume(co)
            end
        end
        command.run_command("echo test", true, finish_callback)
        command.run_command("echo test", true, finish_callback)
        coroutine.yield()
    end)

    it("can run without adding to history", function()
        local co = coroutine.running()
        command.run_command("echo test", false, function(stdout)
            local history = command.get_command_history()
            -- Should be 3 because it is the same as the one before
            assert.equals(3, #history)
            coroutine.resume(co)
        end)
        coroutine.yield()
    end)

    it("can get last command", function()
        local co = coroutine.running()
        command.run_command("echo testing", true, function(stdout)
            assert.equals("echo testing", command.get_last_command())
            coroutine.resume(co)
        end)
        coroutine.yield()
    end)
    --
    it("can get last command output", function()
        local co = coroutine.running()

        local test_function = function ()
            local ans = { "tester" }
            local last_output = command.get_last_command_output()
            assert.equals(last_output[0], ans[0])
            coroutine.resume(co)
        end

        command.run_command("echo tester", true, test_function)
        coroutine.yield()
    end)

    it("can re-run last command", function()
        local co = coroutine.running()
        command.run_last_command(function (stdout)
            local ans = { "tester" }
            assert.equals(stdout[0], ans[0])
            coroutine.resume(co)
        end)
        coroutine.yield()
    end)
end)

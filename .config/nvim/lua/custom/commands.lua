-- useful to debug tmux and alacritty
_G.my_read_key = function()
    local key = vim.fn.getchar()
    local mods = vim.fn.getcharmod()
    local message = "You pressed: " .. vim.fn.nr2char(key) .. "; key: " .. key

    if mods == 2 then
        message = message .. " with Shift"
    elseif mods == 4 then
        message = message .. " with Ctrl"
    elseif mods == 8 then
        message = message .. " with Alt"
    elseif mods == 12 then
        message = message .. " with Ctrl-Shift"
    elseif mods == 6 then
        message = message .. " with Ctrl-Alt"
    elseif mods == 14 then
        message = message .. " with Ctrl-Alt-Shift"
    end

    print(message)
end

vim.cmd("command! ReadKey lua _G.my_read_key()")

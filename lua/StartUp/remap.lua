vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.scrolloff = 8
--vim.opt.signcolumn = "yes" 
--vim.opt.colorcolumn = "120"
--vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50



--Moving selected lines
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv")
--This keeps cursor at default position instead of moving with the pasted elements
--vim.keymap.set("n", "J", "mzJ`z")

--Jumps half page and centers cursor and line in middle screen
--vim.keymap.set("n", "<C-d>", "<C-d>zz")
--vim.keymap.set("n", "<C-u>", "<C-u>zz")

--This jumps to next/prev searched element while keeping the cursor in middle screen and taking folded items in consideration
--vim.keymap.set("n", "N", "Nzzzv")
--vim.keymap.set("n", "n", "nzzzv")

--When pasting over highlighted element the deleted elements goes to void reg and we don't loose our copied element
vim.keymap.set("x", "<leader>p", "\"_dP")

--This copies/deletes selected item in system clipboard which could be used anywhere
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

--Quick fix remaps
--vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
--vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
--vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
--vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

--This makes an executable file of current file
--vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left>")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

--vim.keymap.set("n", "<C-y>", "<C-R>")
vim.keymap.set("n", "<C-z>", "u")


vim.keymap.set("i", "{", "{}<C-[>i")
vim.keymap.set("i", "(", "()<C-[>i")
vim.keymap.set("i", "[", "[]<C-[>i")
vim.keymap.set("i", "'", "\'\'<C-[>i")
vim.keymap.set("i", "\"", "\"\"<C-[>i")



vim.keymap.set("i", "{<CR>", "{}<Esc>i<CR><Esc>O")
vim.keymap.set("i", "{o", "{}<Esc>i<CR><Esc>O")




vim.keymap.set("t", "<C-[>", "<C-\\><C-N>")
vim.keymap.set("t", "<C-[>[", "<C-\\><C-N>:q<CR>")




vim.keymap.set("n", "<F8>", ":w<CR>:lua execution('copy_command')<CR>")
vim.keymap.set("n", "<F10>", ":w<CR>:lua execution('pwshwin_execute')<CR>")
vim.keymap.set("n", "<F9>", ":w<CR>:lua execution('split_execute')<CR>")

function execution(action)
    local filepath = vim.fn.expand('%:p:h') -- Use '%:p:h' to get the directory path without the file name
    local filename = vim.fn.expand('%:t')
    local extension = vim.fn.expand('%:e') -- Get the file extension

    local command

    if extension == 'c' then
        command = string.format("cd '%s' ; if ($?) { gcc '%s' -o a } ; if ($?) { ./a }", filepath, filename)
    elseif extension == 'cpp' then
        command = string.format("cd '%s' ; if ($?) { g++ '%s' -o a } ; if ($?) { ./a }", filepath, filename)
    elseif extension == 'py' then
        command = string.format("cd '%s' ; if ($?) { python '%s' }", filepath, filename)
    elseif extension == 'java' then
       command = string.format("cd '%s' ; if ($?) { javac '%s' } ; if ($?) { java '%s' }", filepath, filename, filename:gsub('%.java$', ''))
    else
        print('Unsupported file type')
        return
    end

    if action == 'copy_command' then
        -- Copy the command to the system clipboard
        vim.fn.setreg('+', command)
    elseif action == 'pwshwin_execute' then
        -- Execute the command in a new PowerShell window
        vim.cmd(":!start powershell -NoExit -Command " .. command)

    elseif action == 'split_execute' then
        vim.cmd("vsplit | terminal powershell -NoExit -Command " .. command)

    else
        print('Invalid action')
    end
end


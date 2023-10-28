-- Vim options
vim.o.termguicolors = true -- Needed for colors
vim.opt.shortmess:append("sI") -- Disable nvim intro
vim.cmd("set noshowmode") -- don't show --INSERT--
vim.o.lazyredraw = true -- Faster scrolling
vim.o.expandtab = true -- Converts tabs to spaces
vim.o.ts = 4 -- Insert 4 spaces for a tab
vim.o.sw = 4 -- Change the number of space characters inserted for indentation
vim.o.smartindent = true
vim.o.autoindent = true
vim.cmd("set formatoptions-=o") -- Don't continue comments when pressing o or O
vim.o.scrolloff = 1000
vim.o.cursorline = true
vim.o.mouse = "a" -- Enable mouse in all modes
vim.wo.number = true
vim.wo.relativenumber = true
vim.cmd(":hi NoneText guifg=bg")
vim.o.ttimeoutlen = 0
-- When searching ignore case of search term unless it has caps
vim.o.smartcase = true
vim.o.ignorecase = true
--Persistent history
vim.o.undodir = "/tmp/.vim-undo-dir"
vim.o.undofile = true
vim.o.fillchars = "diff:/"

vim.api.nvim_set_keymap("n", "<Space>", "<NOP>", { noremap = true, silent = true })
vim.g.mapleader = " "

--Keybindings
function nnoremap(keybinding, remap)
    vim.api.nvim_set_keymap("n", keybinding, remap, { noremap = true, silent = true })
end
function vnoremap(keybinding, remap)
    vim.api.nvim_set_keymap("v", keybinding, remap, { noremap = true, silent = true })
end
function inoremap(keybinding, remap)
    vim.api.nvim_set_keymap("i", keybinding, remap, { noremap = true, silent = true })
end
function nmap(keybinding, remap)
    vim.api.nvim_set_keymap("n", keybinding, remap, { noremap = false, silent = true })
end

-- <leader>s to save
nnoremap("<leader>s", ":update<CR>") -- leader s to save
-- Always use g mode which moves through wrapped lines as if they were actual lines
nmap("j", "gj")
nmap("k", "gk")
-- Shift + HL to move to start and end of visual line
nnoremap("H", "g^")
nnoremap("L", "g$")
vnoremap("H", "g^")
vnoremap("L", "g$")
-- Shift + JK to move to top and bottom of the screen
nnoremap("J", "L")
nnoremap("K", "H")
vnoremap("J", "L")
vnoremap("K", "H")
-- Copy paste from system buffers to make copy paste behaviour more sane
vnoremap("y", '"+y')
nnoremap("y", '"+y')
nnoremap("Y", '"+y$')
vnoremap("x", '"+x')
nnoremap("x", '"+x')
vnoremap("p", '"+p')
nnoremap("p", '"+p')
vnoremap("d", '"+d')
nnoremap("d", '"+d')
-- Quick fix navigation
nnoremap("<M-n>", ":cn<CR>")
nnoremap("<M-p>", ":cp<CR>")
-- <leader><space> to clear highlighing after search
nnoremap("<Leader><space>", ":noh<CR>")
-- I always seem to delete stuff at the bottom of the file with d k so remove
nnoremap("dk", "<Nop>")
-- Keep it centered
nnoremap("n", "nzzzv")
-- Undo these breakpoints when in insert mode
inoremap(",", ",<c-g>u")
inoremap(".", ".<c-g>u")
inoremap("(", "(<c-g>u")
-- Add new line without entering insert mode
nnoremap("<leader>o", ':<C-u>call append(line("."), repeat([""], v:count1))<CR>')
-- Only window and reset bufferline to 0 offset
vim.api.nvim_set_keymap("n", "mo", "", {
    callback = function()
        vim.cmd(":wincmd o")
        require("funcs").reset_bufferline()
    end,
    noremap = true,
    silent = true,
})
-- Quit with q: instead of bringing up cmd mode
nnoremap("q:", ":q<CR>")
-- Start/end of line with ctrl-b ctrl-e in insert mode
inoremap("<c-b>", "<c-o>^")
inoremap("<c-e>", "<c-o>$")
-- nnoremap("<c-a>", "<Nop>")  -- ctrl a is tmux leader
nnoremap("<c-q>", "<c-a>") -- ctrl q to increment
local o = vim.opt

o.number = true
o.clipboard = "unnamedplus"
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣", }
o.cursorline = true
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.showmode = false
o.swapfile = false
o.undofile = true
o.breakindent = true
o.ignorecase = true
o.smartcase = true
o.signcolumn = "auto"
o.scrolloff = 10
o.winborder = "rounded"
o.splitright = true
o.splitbelow = true

-- neovide
if vim.g.neovide then
    vim.o.guifont = 'JetBrainsMono Nerd Font:h14'
    vim.g.neovide_scale_factor = 0.8
    vim.g.neovide_hide_mouse_when_typing = true
end

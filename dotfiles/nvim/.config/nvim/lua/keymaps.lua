local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")

map("n", "<leader>tu", "<cmd>update<CR><cmd>source<CR>", { desc = "source file" })

-- terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>")
map("n", "<leader>tt", "<cmd>ter<CR>", { desc = "terminal" })
map("n", "<leader>tl", "<cmd>ter lazygit<CR>an<CR>", { desc = "lazygit" })

-- save & close buffer
map("n", "<C-s>", "<cmd>w!<CR>")
map("n", "<leader>q", "<cmd>bd!<CR>", { desc = "close buffer" })

-- switch focus
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

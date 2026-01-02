vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
}, { confirm = false })

require("gitsigns").setup()

local gitsigns = require("gitsigns")
local map = vim.keymap.set

map("n", "]c", function()
    gitsigns.nav_hunk "next"
end, { desc = "next git hunk" })
map("n", "[c", function()
    gitsigns.nav_hunk "prev"
end, { desc = "prev git hunk" })

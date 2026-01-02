vim.pack.add({
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
}, { confirm = false })

require("telescope").setup({
    defaults = {
        path_display = { "smart" },
        layout_config = {
            horizontal = {
                prompt_position = "top"
            },
            vertical = {
                prompt_position = "top"
            }
        },
        sorting_strategy = "ascending"
    },
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
        },
    }
})

pcall(require('telescope').load_extension, 'ui-select')

local pickers = require("telescope.builtin")
local map = vim.keymap.set

map("n", "<leader>ss", pickers.builtin, { desc = "telescope" })
map("n", "<leader>sf", pickers.find_files, { desc = "files" })
map("n", "<leader>sg", pickers.live_grep, { desc = "grep" })
map("n", "<leader>sn", function()
    pickers.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = "config" })
map("n", "<leader><leader>", pickers.buffers, { desc = "buffers" })

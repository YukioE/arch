vim.pack.add({
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
}, { confirm = false })

require("lualine").setup({
    options = {
        theme = "pywal-nvim"
    }
})

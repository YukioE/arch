vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
}, { confirm = false })

require("nvim-treesitter.install").update("all")

require("nvim-treesitter.configs").setup({
    sync_install = true,
    auto_install = true,
    highlight = {
        enable = true,
    }
})

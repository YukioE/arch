vim.pack.add({
    { src = "https://github.com/saghen/blink.cmp" },
}, { confirm = false })

require("blink.cmp").setup({
    completion = {
        documentation = {
            auto_show = true,
        },
    },
    fuzzy = {
        implementation = "lua",
    },
    signature = { enabled = true },
})

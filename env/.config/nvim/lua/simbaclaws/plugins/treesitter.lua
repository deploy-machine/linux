return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  -- ensure latest master branch
  branch = "master",
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({
      -- enable syntax highlighting
      highlight = { enable = true },
      -- enable indentation
      indent = { enable = true },
      -- disable sync install
      sync_install = false,
      -- ensure these language parsers are installed
      ensure_installed = {
        "bash",
        "c",
        "css",
        "go",
        "html",
        "java",
        "json",
        "kotlin",
        "markdown",
        "php",
        "python",
        "rust",
        "sql",
        "typescript",
        "vim",
      },
    })
  end,
}

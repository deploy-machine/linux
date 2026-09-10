local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

vim.opt.foldenable = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- LazyVim completes with blink.cmp now (nvim-cmp is an extra). Its "enter"
    -- preset accepts on <CR>; "default" keeps <CR> for a newline (<C-y> accepts).
    {
      "saghen/blink.cmp",
      opts = { keymap = { preset = "default" } },
    },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    {
      "nvim-lualine/lualine.nvim",
      event = "VeryLazy",
      opts = function(_, opts)
        opts.options = {
          theme = "iceberg_dark",
        }

        opts.sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = { "filename" },
          lualine_y = { "diagnostics", "diff", "branch" },
          lualine_z = { "mode" },
        }
      end,
    },
    -- Notifications come from snacks.nvim now (nvim-notify is no longer used):
    -- keep them small and short-lived instead of disabling them.
    {
      "folke/snacks.nvim",
      opts = { notifier = { style = "minimal", timeout = 2000 } },
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = {
        window = {
          position = "right",
        },
        filesystem = {
          filtered_items = {
            visible = true,
            show_hidden_count = false,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
              -- '.git',
              ".DS_Store",
            },
            never_show = {},
          },
        },
      },
    },
    -- LazyVim's dashboard is snacks.nvim's. Same logo and entries as before;
    -- the picker entries go through LazyVim.pick (LazyVim.telescope is gone).
    {
      "folke/snacks.nvim",
      opts = function(_, opts)
        -- stylua: ignore
        local logo = [[ 




        ▲ ✖︎ 👟 


        ]]
        opts.dashboard = opts.dashboard or {}
        opts.dashboard.preset = vim.tbl_deep_extend("force", opts.dashboard.preset or {}, {
          header = logo,
          -- stylua: ignore
          keys = {
            { icon = " ", key = "f", desc = "Find File",       action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File",        action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files",    action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "g", desc = "Find Text",       action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "c", desc = "Config",          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "x", desc = "Lazy Extras",     action = ":LazyExtras" },
            { icon = "󰒲 ", key = "l", desc = "Lazy",            action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit",            action = ":qa" },
          },
        })
      end,
    },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

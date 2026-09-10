-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Decrease updatetime of the swapfile to 250ms
vim.opt.updatetime = 250

-- Enable persistent undo history
vim.opt.undofile = true

-- Neovim 0.11 made %l in 'statuscolumn' follow 'number'/'relativenumber' and
-- stopped treating %r as the relative number (it is the readonly flag again).
-- The pinned LazyVim (10.x) still emits %r for every line but the cursor line,
-- so those render blank on 0.11+. Rewrite its output until LazyVim is updated.
if vim.fn.has("nvim-0.11") == 1 then
  -- Newer LazyVim (snacks statuscolumn) no longer has this module: leave it alone then.
  local ok, ui = pcall(require, "lazyvim.util.ui")
  if ok and type(ui.statuscolumn) == "function" then
    _G.dev_statuscolumn = function()
      return (ui.statuscolumn():gsub("%%r", "%%l"))
    end
    vim.opt.statuscolumn = "%!v:lua.dev_statuscolumn()"
  end
end

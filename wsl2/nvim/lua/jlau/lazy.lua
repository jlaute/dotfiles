local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local myplugindir = os.getenv("DOTFILES") .. "/wsl2/nvim/plugins"

require("lazy").setup({ { import = "jlau.plugins" }, { import = "jlau.plugins.lsp" } }, {
  install = {
    colorscheme = { "onedark" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  dev = {
    path = myplugindir,
    patterns = { 'jlaute' },
  }
})

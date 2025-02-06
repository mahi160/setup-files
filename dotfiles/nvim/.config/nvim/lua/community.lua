-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { "github/copilot.vim", event = "VeryLazy", version = "*" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { "supermaven-inc/supermaven-nvim", config = function() require("supermaven-nvim").setup {} end },
  -- import/override with your plugins folder
}

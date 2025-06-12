return {
  "jbyuki/instant.nvim",
  -- lazy = true,
  config = function(plugin, opts)
    vim.g.instant_username = "PotatoGim"

    require "instant"
  end,
}

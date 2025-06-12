-- if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Set up custom filetypes
-- vim.filetype.add {
--   extension = {
--     foo = "fooscript",
--   },
--   filename = {
--     ["Foofile"] = "fooscript",
--   },
--   pattern = {
--     ["~/%.config/foo/.*"] = "fooscript",
--   },
-- }

-- GUI font scaling
-- vim.g.gui_font_default_size = 12
-- vim.g.gui_font_size = vim.g.gui_font_default_size
-- vim.g.gui_font_face = "Fira Code Retina"
--
-- RefreshGuiFont = function()
--   vim.opt.guifont = string.format("%s:h%s", vim.g.gui_font_face, vim.g.gui_font_size)
-- end
--
-- ResizeGuiFont = function(delta)
--   vim.g.gui_font_size = vim.g.gui_font_size + delta
--   RefreshGuiFont()
-- end
--
-- ResetGuiFont = function ()
--   vim.g.gui_font_size = vim.g.gui_font_default_size
--   RefreshGuiFont()
-- end
--
-- -- Call function on startup to set default value
-- ResetGuiFont()
--
-- -- Keymaps
--
-- local opts = { noremap = true, silent = true }
--
-- vim.keymap.set({ 'n', 'i' }, "<C-+>", function() ResizeGuiFont(1)  end, opts)
-- vim.keymap.set({ 'n', 'i' }, "<C-->", function() ResizeGuiFont(-1) end, opts)
-- vim.keymap.set({ 'n', 'i' }, "<C-BS>", function() ResetGuiFont() end, opts)

if vim.g.neovide == true then
  vim.api.nvim_set_keymap(
    "n",
    "<C-=>",
    ":lua vim.g.neovide_scale_factor = math.min(vim.g.neovide_scale_factor + 0.1,  1.0)<CR>",
    { silent = true }
  )

  vim.api.nvim_set_keymap(
    "n",
    "<C-->",
    ":lua vim.g.neovide_scale_factor = math.max(vim.g.neovide_scale_factor - 0.1,  0.1)<CR>",
    { silent = true }
  )

  vim.api.nvim_set_keymap(
    "n",
    "<C-+>",
    ":lua vim.g.neovide_transparency = math.min(vim.g.neovide_transparency + 0.05, 1.0)<CR>",
    { silent = true }
  )

  vim.api.nvim_set_keymap(
    "n",
    "<C-_>",
    ":lua vim.g.neovide_transparency = math.max(vim.g.neovide_transparency - 0.05, 0.0)<CR>",
    { silent = true }
  )

  vim.api.nvim_set_keymap("n", "<C-0>", ":lua vim.g.neovide_scale_factor = 0.5<CR>", { silent = true })

  vim.api.nvim_set_keymap("n", "<C-)>", ":lua vim.g.neovide_transparency = 0.9<CR>", { silent = true })
end

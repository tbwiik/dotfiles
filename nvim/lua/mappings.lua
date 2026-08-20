require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- debug
vim.keymap.set("n", "<Right>", function()
  require("dap").continue()
end)
vim.keymap.set("n", "<Up>", function()
  require("dap").step_over()
end)
vim.keymap.set("n", "<Down>", function()
  require("dap").step_into()
end)
vim.keymap.set("n", "<Left>", function()
  require("dap").step_out()
end)
vim.keymap.set("n", "<leader>b", function()
  require("dap").toggle_breakpoint()
end)
--
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

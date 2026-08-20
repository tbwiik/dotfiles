return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "tpope/vim-fugitive",
    lazy = false,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
  --
  {
    "mfussenegger/nvim-dap",
    lazy = true,
  },
  {
    "mfussenegger/nvim-dap-python",
    lazy = true,
    config = function()
      require("dap-python").setup("uv")
    end,
    dependencies = { "mfussenegger/nvim-dap" },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { dir = vim.fn.expand(vim.fn.stdpath "state") .. "/sessions/" },
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "Select Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load { last = true }
        end,
        desc = "Restore Last Session",
      },
    },
  },
}

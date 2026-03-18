return {
  -- Surround text objects
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Docstring generation
  {
    "danymat/neogen",
    version = "*",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      enabled = true,
      languages = { python = { template = { annotation_convention = "google_docstrings" } } },
      snippet_engine = "luasnip",
    },
    cmd = "Neogen",
    keys = {
      { "<leader>nds", "<cmd>Neogen<cr>", desc = "Generate docstring" },
    },
  },

  -- Treesitter context
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = { enable = true, max_lines = -1, trim_scope = "inner", separator = "⟺", mode = "cursor" },
  },

  -- Fish syntax
  { "dag/vim-fish", ft = "fish" },
}

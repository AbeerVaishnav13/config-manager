return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "black",
        "latexindent",
        "stylua",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        tex = { "latexindent" },
      },
      format_on_save = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
    },
  },
}

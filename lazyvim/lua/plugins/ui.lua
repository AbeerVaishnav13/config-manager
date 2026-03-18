return {
  -- Disable noice cmdline popup, use classic bottom cmdline
  {
    "folke/noice.nvim",
    opts = {
      cmdline = { enabled = false },
      messages = { enabled = false },
    },
  },
}

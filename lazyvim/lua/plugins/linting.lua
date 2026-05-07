-- Configure markdownlint-cli2 to use global config for disabling MD013/MD024
local markdownlint_config = vim.fn.stdpath("config") .. "/.markdownlint.json"

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", markdownlint_config, "-" },
        },
      },
    },
  },
}

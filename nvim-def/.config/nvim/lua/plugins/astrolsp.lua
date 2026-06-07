return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    config = {
      clangd = {
        -- Аргументы из твоего Helix languages.toml
        cmd = {
          "clangd",
          "--background-index",
          "--background-index-priority=low",
          "--clang-tidy",
          "--clang-tidy-checks=*",
          "--header-insertion=iwyu",
          "--header-insertion-decorators",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=LLVM",
          "--pch-storage=memory",
          "--all-scopes-completion",
          "--suggest-missing-includes",
          "-j=4",
        },
      },
    },
    -- Настройка автоформатирования (auto-format = true из config.toml)
    formatting = {
      format_on_save = {
        enabled = true, -- Соответствует auto-format = true
        allow_filetypes = { "c", "cpp", "rust" },
      },
    },
  },
}

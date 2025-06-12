-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

local function setup_perlnavigator()
  local current_dir = vim.loop.cwd()
  local home_dir = vim.env.HOME

  local settings = {
    perlParams = {
      -- "-I./lib",
      -- "-I./blib",
      -- string.format("-I%s/lib", current_dir),
      -- string.format("-I%s/blib", current_dir),
    },
    perltidyProfile = string.format("%s/.perltidyrc", current_dir),
    perlcriticProfile = string.format("%s/.perlcriticrc", current_dir),
    perlcriticEnabled = true,
  }

  if vim.fn.isdirectory "./lib" ~= 0 then
    -- insert libgms
    table.insert(settings["perlParams"], "-I./lib")

    -- NOTE:
    -- table.insert(settings["perlParams"], string.format("-I%s/lib", current_dir))
  end

  if vim.fn.isdirectory "./blib" ~= 0 then
    -- insert arch/lib
    table.insert(settings["perlParams"], "-I./blib/arch")
    table.insert(settings["perlParams"], "-I./blib/lib")
  end

  if vim.fn.isdirectory "./t/lib" ~= 0 then
    -- insert t/lib
    table.insert(settings["perlParams"], "-I./t/lib")
  end

  if vim.fn.isdirectory "./xt/lib" ~= 0 then
    -- insert t/lib
    table.insert(settings["perlParams"], "-I./xt/lib")
  end

  if vim.fn.isdirectory "./libgms" ~= 0 then
    -- insert libgms
    table.insert(settings["perlParams"], "-I./libgms")
  end

  -- Gluesys
  if current_dir:lower():match "gluesys" then
    local ws_dir = string.format("%s/workspace/gluesys/gitlab", home_dir)

    table.insert(settings["perlParams"], string.format("-I%s/dev3/GMS/lib", ws_dir))
    table.insert(settings["perlParams"], string.format("-I%s/dev3/libgms/lib", ws_dir))
  end

  return settings
end

local function setup_ccls()
  -- We should below code to use clangd alongside
  -- require("ccls").setup {
  --   lsp = {
  --     disable_capabilities = {
  --       completionProvider = true,
  --       documentFormattingProvider = true,
  --       documentRangeFormattingProvider = true,
  --       documentHighlightProvider = true,
  --       documentSymbolProvider = true,
  --       workspaceSymbolProvider = true,
  --       renameProvider = true,
  --       hoverProvider = true,
  --       codeActionProvider = true,
  --     },
  --     disable_diagnostics = true,
  --     disable_signature = true,
  --   },
  -- }
end

-- vim.print(perlnavigator)

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = {
      -- autoformat = true, -- enable or disable auto formatting on start
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally

        allow_filetypes = { -- enable format on save for specified filetypes only
          "bash",
          "c",
          "cpp",
          "css",
          "go",
          "html",
          "javascript",
          "perl",
          "rust",
          "sass",
          "scss",
          "typescript",
        },

        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
          "markdown",
        },
      },

      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        "lua_ls",
      },

      timeout_ms = 5000, -- default format timeout

      filter = function(client) -- fully override the default formatting function
        -- only enable null-ls for javascript files
        if vim.bo.filetype == "javascript" then return client.name == "null-ls" end

        -- enable all other clients
        return true
      end,
    },

    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },

    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      clangd = {
        capabilities = {
          offsetEncoding = "utf-8",
        },
      },

      eslint = {
        capabilities = {
          offsetEncoding = "utf-8",
        },
        settings = {
          eslint = {
            codeAction = {
              disableRuleComment = {
                enable = true,
                location = "separateLine",
              },
              showDocumentation = {
                enable = true,
              },
            },
            codeActionOnSave = {
              enable = false,
              mode = "all",
            },
            experimental = {
              useFlatConfig = false,
            },
            -- format = true,
            nodePath = "",
            onIgnoredFiles = "off",
            problems = {
              shortenToSingleLine = false,
            },
            quiet = false,
            rulesCustomizations = {},
            run = "onType",
            useESLintClass = false,
            -- validate = "on",
            workingDirectory = {
              mode = "location",
            },
          },
        },
      },

      perlnavigator = {
        settings = {
          perlnavigator = setup_perlnavigator(),
        },
      },
    },

    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed

      tsserver = function(server, opts)
        -- custom setup handler
        return
      end,

      vtsls = function(server, opts)
        -- custom setup handler
        return
      end,
    },

    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_codelens_refresh = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/codeLens",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "InsertLeave", "BufEnter" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },

      -- From v4
      -- lsp_document_highlight = {
      --   -- Optional condition to create/delete auto command group
      --   -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
      --   -- condition will be resolved for each client on each execution and if it ever fails for all clients,
      --   -- the auto commands will be deleted for that buffer
      --   cond = "textDocument/documentHighlight",
      --   -- cond = function(client, bufnr) return client.name == "lua_ls" end,
      --   -- list of auto commands to set
      --   {
      --     -- events to trigger
      --     event = { "CursorHold", "CursorHoldI" },
      --     -- the rest of the autocmd options (:h nvim_create_autocmd)
      --     desc = "Document Highlighting",
      --     callback = function() vim.lsp.buf.document_highlight() end,
      --   },
      --   {
      --     event = { "CursorMoved", "CursorMovedI", "BufLeave" },
      --     desc = "Document Highlighting Clear",
      --     callback = function() vim.lsp.buf.clear_references() end,
      --   },
      -- },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        gl = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },

        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        -- gD = {
        --   function() vim.lsp.buf.declaration() end,
        --   desc = "Declaration of current symbol",
        --   cond = "textDocument/declaration",
        -- },

        -- ["<Leader>uY"] = {
        --   function() require("astrolsp.toggles").buffer_semantic_tokens() end,
        --   desc = "Toggle LSP semantic highlight (buffer)",
        --   cond = function(client)
        --     return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
        --   end,
        -- },

        -- Use default keywordprg instead of LSP hover
        -- K = false,
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil

      -- For javascript/typescript formatting with eslint
      -- if client.name == "eslint" then
      --   vim.api.nvim_create_augroup("format_on_save", { clear = true })
      --   vim.api.nvim_create_autocmd("BufWritePre", {
      --     pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
      --     command = "silent! EslintFixAll",
      --   })
      --   vim.print "eslint will not be used"
      --   return
      -- end

      -- if client.server_capabilities.document_formatting then
      --   vim.api.nvim_create_augroup("format_on_save", { clear = true })
      --   vim.api.nvim_create_autocmd(
      --     "BufWritePre",
      --     {
      --       desc = "Auto format before save",
      --       group = "format_on_save",
      --       pattern = "<buffer>",
      --       callback = function()
      --         vim.lsp.buf.formatting_sync { async = true }
      --       end,
      --     }
      --   )
      -- end
    end,
  },
}

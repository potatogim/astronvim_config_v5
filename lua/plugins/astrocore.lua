-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      -- set global limits for large files for disabling features like treesitter
      -- treesitter
      large_buf = {
        -- size = 1024 * 256,
        -- lines = 10000
        size = 1024 * 2048, -- 2MB size
        lines = 1000 * 100, -- 100K lines
      },
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },

    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },

    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false,
        number = true, -- 줄번호 표시
        spell = false, -- sets vim.opt.spell
        signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        wrap = false, -- sets vim.opt.wrap
        cursorline = true, -- 현재 라인 강조
        lazyredraw = true, -- 매크로 수행 중에는 다시 그리기 없음
        linespace = 0, -- 행간에 어떤 픽셀 라인도 삽입하지 않음
        -- GUI 환경에서 폰트에 따라 조정 필요함

        -- Indentation
        tabstop = 4, -- 탭 간격
        softtabstop = 4, -- 공백 편집 시 취급 크기
        shiftwidth = 4, -- (자동, <<, >>) 인덴트 시 공백의 크기
        shiftround = true, -- 공백을 shiftwidth의 배수에 가깝게 반올림
        joinspaces = false, -- 공백을 탭으로 변환하지 않는다.

        -- Backup
        backup = true,
        backupdir = os.getenv "HOME" .. "/.vim/backup",

        -- List characters
        --   eol      - EOL 표시
        --   tab      - TAB 표시
        --   trail    - 연속되는 공백 표시
        --   extends  - 열의 마지막 표시
        --   precedes - 열의 시작 표시
        --   conceal  - 숨겨진 텍스트 표시
        --   nbsp     - 자동개행 방지 공백 표시
        list = true,
        listchars = {
          tab = ">-",
          trail = ".",
          extends = ">",
          precedes = "<",
        },

        -- Clipboard
        clipboard = "unnamedplus",

        -- Search
        hlsearch = true,
        ignorecase = true,
        smartcase = true,
        wrapscan = false,
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file

        -- -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
        -- autoformat_enabled = true,
        -- -- enable completion at start
        -- cmp_enabled = true,
        -- -- enable autopairs at start
        -- autopairs_enabled = true,
        -- -- set the visibility of diagnostics in the UI
        -- --   0=off
        -- --   1=only show in status line
        -- --   2=virtual text off
        -- --   3=all on
        -- diagnostics_mode = 3,
        -- -- disable notifications when toggling UI elements
        -- ui_notifications_enabled = true,
        -- -- enable experimental resession.nvim session management (will be default in AstroNvim v4)
        resession_enabled = false,

        -- max_file = {
        --   lines = 1000 * 100, -- 10K lines
        --   size = 1024 * 2048, -- 2MB size
        -- },

        gui_font_default_size = 10,
        gui_font_size = 10,

        -- RPM spec changelog format
        spec_chglog_format = "%a %b %d %Y Jihyeon Gim <potatogim@potatogim.net>",
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,

        -- manpage
        ["<leader>fm"] = {
          function() require("telescope.builtin").man_pages { sections = { "ALL" } } end,
          desc = "Find man",
        },

        -- todo-comments.nvim
        ["]t"] = {
          function() require("todo-comments").jump_next() end,
          desc = "Next todo comment",
        },
        ["[t"] = {
          function() require("todo-comments").jump_prev() end,
          desc = "Previous todo comment",
        },

        -- insert current date
        ["<leader>dt"] = {
          function()
            -- local date = os.date "%Y-%m-%d"
            -- vim.api.nvim_put({ date }, "c", true, true)
          end,
          desc = "Insert current date",
        },

        -- insert current datetime
        ["<leader>tt"] = {
          function()
            -- local datetime = os.date "%Y-%m-%d %T %Z"
            -- vim.api.nvim_put({ datetime }, "c", true, true)
          end,
          -- vim.keymap.set("n", "<leader>tt", ':r! date "+\\%H:\\%M:\\%S" <CR>', {noremap = true, vim.keymap.set})
          desc = "Insert current datetime",
        },
      },

      v = {
        -- dummy
      },

      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
      },
    },

    autocmds = {
      potatogim = {
        {
          event = "BufWritePre",
          desc = "PotatoGim | Define backup file extension",
          pattern = "*",
          callback = function(args)
            -- postfix
            vim.opt.backupext = "_" .. os.date "%y%m%d_%H:%M" .. "~"
          end,
        },
        {
          event = "FileType",
          desc = "Potatogim | For C/C++/Rust/Perl",
          pattern = { "c", "cpp", "rust", "perl" },
          callback = function(args)
            vim.opt_local.expandtab = true
            vim.opt_local.tabstop = 4
            vim.opt_local.softtabstop = 4
            vim.opt_local.shiftwidth = 4
          end,
        },
        {
          event = "FileType",
          desc = "Potatogim | For Golang",
          pattern = { "go" },
          callback = function(args)
            vim.opt_local.expandtab = false
            vim.opt_local.tabstop = 4
            vim.opt_local.softtabstop = 4
            vim.opt_local.shiftwidth = 4
          end,
        },
        {
          event = "FileType",
          desc = "Potatogim | For JavaScript/TypeScript",
          pattern = { "javascript", "typescript" },
          callback = function(args)
            vim.opt_local.expandtab = false
            vim.opt_local.tabstop = 4
            vim.opt_local.softtabstop = 4
            vim.opt_local.shiftwidth = 4
          end,
        },
      },
    },
  },
}

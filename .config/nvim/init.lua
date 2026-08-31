-- =============================================================================
-- Neovim IDE Configuration: TypeScript, Rust, LSP, Treesitter, Autocomplete
-- =============================================================================

-- Leader key (Space)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- -----------------------------------------------------------------------------
-- Basic Options
-- -----------------------------------------------------------------------------
vim.opt.termguicolors = true      -- True color support
vim.opt.number = true             -- Line numbers
vim.opt.relativenumber = true     -- Relative line numbers
vim.opt.tabstop = 4               -- Tab width
vim.opt.shiftwidth = 4            -- Indent width
vim.opt.expandtab = true          -- Spaces instead of tabs
vim.opt.mouse = 'a'               -- Mouse support
vim.opt.clipboard = 'unnamedplus' -- System clipboard
vim.opt.ignorecase = true         -- Case-insensitive search
vim.opt.smartcase = true          -- Case-sensitive if uppercase letter
vim.opt.signcolumn = "yes"        -- Always show sign column
vim.opt.completeopt = "menu,menuone,noselect" -- Better completion UX
vim.opt.updatetime = 250          -- Faster diagnostics & completion

-- Use real tabs for JS, TS, JSX, TSX, JSON, HTML, CSS, SCSS
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "jsonc", "html", "css", "scss", "yaml", "markdown" },
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
    end,
})

-- -----------------------------------------------------------------------------
-- Bootstrap lazy.nvim
-- -----------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- -----------------------------------------------------------------------------
-- Setup Plugins with lazy.nvim
-- -----------------------------------------------------------------------------
require("lazy").setup({
    -- Multi-cursor (VS Code style Ctrl+D)
    {
        "mg979/vim-visual-multi",
        branch = "master",
        init = function()
            vim.g.VM_default_mappings = 0
            vim.g.VM_maps = {
                ["Find Under"] = "<C-d>",
                ["Find Subword Under"] = "<C-d>",
                ["Select All"] = "<C-M-d>",
                ["Skip Region"] = "<C-x>",
                ["Remove Region"] = "<C-p>",
            }
        end,
    },

    -- Fast Commenting (Space + / and Ctrl + /)
    {
        "echasnovski/mini.comment",
        version = false,
        opts = {
            mappings = {
                comment = "",
                comment_line = "",
                comment_visual = "",
                textobject = "",
            },
        },
    },

    -- Auto-formatter (Prettier, Rustfmt, Stylua, Black, etc. + Format on Save)
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                rust = { "rustfmt", lsp_format = "fallback" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                jsonc = { "prettier" },
                yaml = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                markdown = { "prettier" },
                python = { "isort", "black" },
                sh = { "shfmt" },
            },
            formatters = {
                prettier = {
                    prepend_args = { "--use-tabs", "--tab-width", "4" },
                },
            },
            default_format_opts = {
                lsp_format = "fallback",
                timeout_ms = 2000,
            },
            format_on_save = {
                timeout_ms = 2000,
                lsp_format = "fallback",
            },
            notify_on_error = false,
        },
        config = function(_, opts)
            local conform = require("conform")
            conform.setup(opts)

            -- Format document keymap: Space + f (or Alt + Shift + F like VS Code)
            vim.keymap.set({ "n", "v" }, "<leader>f", function()
                conform.format({
                    lsp_format = "fallback",
                    async = false,
                    timeout_ms = 2000,
                })
            end, { desc = "Format document (Space+f)" })

            vim.keymap.set({ "n", "v" }, "<M-F>", function()
                conform.format({
                    lsp_format = "fallback",
                    async = false,
                    timeout_ms = 2000,
                })
            end, { desc = "Format document (Alt+Shift+F)" })
        end,
    },

    -- Project-wide Find & Replace (Spectre)
    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local spectre = require("spectre")
            spectre.setup({
                color_devicons = true,
                open_cmd = "vnew",
                live_update = true,
            })

            -- Keymaps for Spectre
            vim.keymap.set("n", "<leader>S", spectre.toggle, { desc = "Toggle Spectre Find/Replace (Space+S)" })
            vim.keymap.set("n", "<C-H>", spectre.toggle, { desc = "Toggle Spectre (Ctrl+H)" })
            vim.keymap.set("n", "<leader>sw", function()
                spectre.open_visual({ select_word = true })
            end, { desc = "Spectre: Find current word (Space+sw)" })
            vim.keymap.set("v", "<leader>sw", function()
                spectre.open_visual()
            end, { desc = "Spectre: Find visual selection (Space+sw)" })
            vim.keymap.set("n", "<leader>sf", function()
                spectre.open_file_search({ select_word = true })
            end, { desc = "Spectre: Search current file (Space+sf)" })
        end,
    },

    -- Git Diff Indicators in Sign Column (gitsigns)
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add          = { text = "│" }, -- Green
                change       = { text = "│" }, -- Blue
                delete       = { text = "_" }, -- Red
                topdelete    = { text = "‾" },
                changedelete = { text = "│" },
                untracked    = { text = "┆" },
            },
            signcolumn = true,
            numhl = false,
            linehl = false,
            word_diff = false,
            watch_gitdir = { interval = 1000, follow_files = true },
            current_line_blame = false,
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation between changes: ]c and [c
                map("n", "]c", function()
                    if vim.wo.diff then return "]c" end
                    vim.schedule(function() gs.next_hunk() end)
                    return "<Ignore>"
                end, { expr = true, desc = "Next Git hunk (]c)" })

                map("n", "[c", function()
                    if vim.wo.diff then return "[c" end
                    vim.schedule(function() gs.prev_hunk() end)
                    return "<Ignore>"
                end, { expr = true, desc = "Previous Git hunk ([c)" })

                -- Actions
                map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Git hunk change (Space+hp)" })
                map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset/Revert Git hunk (Space+hr)" })
                map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Git blame line (Space+hb)" })
                map("n", "<leader>hd", gs.diffthis, { desc = "Git diff current file (Space+hd)" })
            end,
        },
    },

    -- Catppuccin Theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "mocha",
            transparent_background = true,
            integrations = {
                telescope = { enabled = true },
                neotree = true,
                treesitter = true,
                cmp = true,
                mason = true,
                lualine = true,
                gitsigns = true,
                neogit = true,
                diffview = true,
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    -- Diffview (Full project diff & side-by-side comparison)
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        config = function()
            local diffview = require("diffview")
            diffview.setup({
                enhanced_diff_hl = true,
                view = {
                    default = {
                        layout = "diff2_horizontal",
                    },
                },
            })

            vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Git Diffview open (Space+gd)" })
            vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "Git Diffview close (Space+gD)" })
            vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Git File History (Space+gh)" })
        end,
    },

    -- Neogit (Interactive Git UI like Magit / VS Code Source Control)
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            local neogit = require("neogit")
            neogit.setup({
                kind = "floating",
                signs = {
                    section = { "", "" },
                    item = { "", "" },
                    hunk = { "", "" },
                },
                integrations = {
                    diffview = true,
                    telescope = true,
                },
            })

            -- Keymaps for Neogit
            vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit Git UI (Space+gg)" })
            vim.keymap.set("n", "<leader>gs", "<cmd>Neogit<cr>", { desc = "Git status UI (Space+gs)" })
            vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<cr>", { desc = "Git commit UI (Space+gc)" })
            vim.keymap.set("n", "<leader>gp", "<cmd>Neogit pull<cr>", { desc = "Git pull (Space+gp)" })
            vim.keymap.set("n", "<leader>gP", "<cmd>Neogit push<cr>", { desc = "Git push (Space+gP)" })
        end,
    },

    -- Treesitter (Advanced Syntax Highlighting)
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        opts = {
            ensure_installed = {
                "lua",
                "rust",
                "typescript",
                "javascript",
                "tsx",
                "json",
                "html",
                "css",
                "bash",
                "toml",
                "yaml",
                "markdown",
            },
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
        },
        config = function(_, opts)
            require("nvim-treesitter.install").prefer_git = true
            -- In nvim-treesitter on modern nvim versions
            local ok, configs = pcall(require, "nvim-treesitter.configs")
            if ok then
                configs.setup(opts)
            end
        end,
    },

    -- Telescope & Dependencies
    {
        "nvim-telescope/telescope.nvim",
        branch = "master",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")

            telescope.setup({
                defaults = {
                    prompt_prefix = "   ",
                    selection_caret = " ❯ ",
                    path_display = { "truncate" },
                    sorting_strategy = "ascending",
                    file_ignore_patterns = {
                        "node_modules/",
                        "%.git/",
                        "target/",
                        "dist/",
                        "build/",
                        "%.lock",
                    },
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.55,
                        },
                    },
                },
            })

            -- Telescope Keybindings
            vim.keymap.set("n", "<leader>p", builtin.find_files, { desc = "Find files (Space+p)" })
            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files (Space+ff)" })
            vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files (Ctrl+P)" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep text" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find open buffers" })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
            vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Recent files" })
        end,
    },

    -- Neo-tree File Explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,
                popup_border_style = "rounded",
                filesystem = {
                    follow_current_file = { enabled = true },
                    use_libuv_file_watcher = true,
                    filtered_items = {
                        visible = true,
                        hide_dotfiles = false,
                        hide_gitignored = false,
                    },
                },
                window = {
                    width = 30,
                    mappings = {
                        ["<space>"] = "none",
                    },
                },
            })

            -- Keymaps for Neo-tree
            vim.keymap.set("n", "<leader>t", "<cmd>Neotree toggle<cr>", { desc = "Toggle Explorer (Space+t)" })
            vim.keymap.set("n", "<C-t>", "<cmd>Neotree toggle<cr>", { desc = "Toggle Explorer (Ctrl+t)" })
            vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle Explorer (Space+e)" })
            vim.keymap.set("n", "<C-b>", "<cmd>Neotree toggle<cr>", { desc = "Toggle Explorer (Ctrl+b)" })
            vim.keymap.set("n", "<leader>o", "<cmd>Neotree focus<cr>", { desc = "Focus Explorer" })
        end,
    },

    -- Auto-close brackets & quotes
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true,
            enable_check_bracket_line = true,
        },
    },

    -- Statusline (lualine.nvim)
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "catppuccin",
                    component_separators = { left = "│", right = "│" },
                    section_separators = { left = "", right = "" },
                    globalstatus = true,
                    disabled_filetypes = { statusline = { "neo-tree" } },
                },
                sections = {
                    lualine_a = { { "mode", icon = "" } },
                    lualine_b = {
                        { "branch", icon = "" },
                        {
                            "diff",
                            symbols = { added = " ", modified = " ", removed = " " },
                        },
                    },
                    lualine_c = {
                        {
                            "filename",
                            path = 1, -- Relative path
                            symbols = { modified = " 󰏫", readonly = " ", unnamed = "[No Name]" },
                        },
                    },
                    lualine_x = {
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },
                            symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
                        },
                        { "filetype", icon_only = false },
                    },
                    lualine_y = { "progress" },
                    lualine_z = { { "location", icon = "" } },
                },
            })
        end,
    },

    -- Beautiful UI for Code Actions & Inputs (dressing.nvim)
    {
        "stevearc/dressing.nvim",
        lazy = false,
        opts = {
            input = {
                border = "rounded",
                win_options = { winblend = 0 },
            },
            select = {
                backend = { "builtin", "telescope" },
                builtin = {
                    border = "rounded",
                    win_options = { winblend = 0 },
                },
            },
        },
    },

    -- LSP, Mason & Language Tools
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Function to trigger Code Actions (filtering out disabled junk)
            local function trigger_code_action()
                vim.lsp.buf.code_action({
                    filter = function(action)
                        return not action.disabled
                    end,
                    apply = true,
                })
            end

            -- Common on_attach function for LSP keybindings
            local on_attach = function(_, bufnr)
                local opts = { buffer = bufnr, silent = true }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
                vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
                vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
                vim.keymap.set("n", "gI", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
                vim.keymap.set({ "n", "v" }, "<leader>ca", trigger_code_action, vim.tbl_extend("force", opts, { desc = "Code actions (Space+ca)" }))
                vim.keymap.set({ "n", "v" }, "<leader>.", trigger_code_action, vim.tbl_extend("force", opts, { desc = "Code actions (Space+.)" }))
                vim.keymap.set({ "n", "v", "i" }, "<C-.>", trigger_code_action, vim.tbl_extend("force", opts, { desc = "Code actions (Ctrl+.)" }))
                vim.keymap.set({ "n", "v" }, "<A-CR>", trigger_code_action, vim.tbl_extend("force", opts, { desc = "Code actions (Alt+Enter)" }))
                vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show line diagnostic" }))
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
                vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend("force", opts, { desc = "Format code" }))
            end

            -- Setup Mason-LSPConfig with auto-installed servers
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "rust_analyzer", -- Rust LSP
                    "ts_ls",         -- TypeScript / JavaScript LSP
                    "lua_ls",        -- Lua LSP (for Neovim config)
                    "html",          -- HTML LSP
                    "cssls",         -- CSS LSP
                    "jsonls",        -- JSON LSP
                },
                handlers = {
                    -- Default handler for installed servers
                    function(server_name)
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,

                    -- Rust Analyzer specific settings
                    ["rust_analyzer"] = function()
                        lspconfig.rust_analyzer.setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            settings = {
                                ["rust-analyzer"] = {
                                    cargo = { allFeatures = true },
                                    checkOnSave = { command = "clippy" },
                                    inlayHints = {
                                        bindingModeHints = { enable = false },
                                        chainingHints = { enable = true },
                                        closingBraceHints = { enable = true },
                                        typeHints = { enable = true },
                                        parameterHints = { enable = true },
                                    },
                                },
                            },
                        })
                    end,

                    -- TypeScript (ts_ls) specific settings
                    ["ts_ls"] = function()
                        lspconfig.ts_ls.setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            init_options = {
                                maxTsServerMemory = 4096,
                                preferences = {
                                    disableSuggestions = false,
                                },
                            },
                            settings = {
                                typescript = {
                                    inlayHints = {
                                        includeInlayParameterNameHints = "all",
                                        includeInlayFunctionParameterTypeHints = true,
                                        includeInlayVariableTypeHints = true,
                                    },
                                },
                                javascript = {
                                    inlayHints = {
                                        includeInlayParameterNameHints = "all",
                                        includeInlayFunctionParameterTypeHints = true,
                                        includeInlayVariableTypeHints = true,
                                    },
                                },
                            },
                        })
                    end,

                    -- Lua LS settings (ignore vim global warning)
                    ["lua_ls"] = function()
                        lspconfig.lua_ls.setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            settings = {
                                Lua = {
                                    diagnostics = { globals = { "vim" } },
                                    workspace = { checkThirdParty = false },
                                },
                            },
                        })
                    end,
                },
            })

            -- Configure Diagnostic display icons
            local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            vim.diagnostic.config({
                virtual_text = { prefix = "●" },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = { border = "rounded" },
            })
        end,
    },

    -- Autocompletion Engine (nvim-cmp)
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            "windwp/nvim-autopairs",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()

            -- Integration between autopairs and cmp
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered({ border = "rounded" }),
                    documentation = cmp.config.window.bordered({ border = "rounded" }),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 1000 },
                    { name = "luasnip", priority = 750 },
                    { name = "path", priority = 500 },
                    { name = "buffer", priority = 250, keyword_length = 3 },
                }),
            })
        end,
    },
})

-- -----------------------------------------------------------------------------
-- Global LSP Keybindings (Fallback)
-- -----------------------------------------------------------------------------
vim.keymap.set({ "n", "v" }, "<leader>.", vim.lsp.buf.code_action, { desc = "Code actions (Space+.)" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions (Space+ca)" })
vim.keymap.set({ "n", "v" }, "<A-CR>", vim.lsp.buf.code_action, { desc = "Code actions (Alt+Enter)" })
vim.keymap.set({ "n", "v", "i" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Code actions (Ctrl+.)" })

-- -----------------------------------------------------------------------------
-- Transparent Background Enforcement
-- -----------------------------------------------------------------------------
local function set_transparent_background()
    local highlight_groups = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "FloatBorder",
        "LineNr",
        "CursorLineNr",
        "SignColumn",
        "FoldColumn",
        "VertSplit",
        "WinSeparator",
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",
        "TabLineSel",
        "Pmenu",
        "PmenuSel",
        "PmenuSbar",
        "PmenuThumb",
        "EndOfBuffer",
        "NonText",
        "TelescopeNormal",
        "TelescopeBorder",
        "TelescopePromptNormal",
        "TelescopePromptBorder",
        "TelescopeResultsNormal",
        "TelescopeResultsBorder",
        "TelescopePreviewNormal",
        "TelescopePreviewBorder",
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "NeoTreeEndOfBuffer",
        "NeoTreeWinSeparator",
        "NeoTreeFloatBorder",
        "NeoTreeFloatTitle",
    }

    for _, group in ipairs(highlight_groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
    end
end

-- Hook transparent background on startup and colorscheme changes
set_transparent_background()
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    group = vim.api.nvim_create_augroup("TransparentBackground", { clear = true }),
    callback = set_transparent_background,
})

-- -----------------------------------------------------------------------------
-- Fast Comment Keybindings (Space + / and Ctrl + /)
-- -----------------------------------------------------------------------------
-- Normal mode: toggle line comment
vim.keymap.set("n", "<leader>/", function()
    require("mini.comment").toggle_lines(vim.fn.line("."), vim.fn.line("."))
end, { desc = "Toggle line comment (Space+/)" })
vim.keymap.set("n", "<C-_>", function()
    require("mini.comment").toggle_lines(vim.fn.line("."), vim.fn.line("."))
end, { desc = "Toggle line comment (Ctrl+/)" })
vim.keymap.set("n", "<C-/>", function()
    require("mini.comment").toggle_lines(vim.fn.line("."), vim.fn.line("."))
end, { desc = "Toggle line comment (Ctrl+/)" })

-- Visual mode: toggle selection comment
vim.keymap.set("x", "<leader>/", function()
    local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
    vim.api.nvim_feedkeys(esc, "nx", false)
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    require("mini.comment").toggle_lines(start_line, end_line)
end, { desc = "Toggle selection comment (Space+/)" })
vim.keymap.set("x", "<C-_>", function()
    local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
    vim.api.nvim_feedkeys(esc, "nx", false)
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    require("mini.comment").toggle_lines(start_line, end_line)
end, { desc = "Toggle selection comment (Ctrl+/)" })
vim.keymap.set("x", "<C-/>", function()
    local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
    vim.api.nvim_feedkeys(esc, "nx", false)
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    require("mini.comment").toggle_lines(start_line, end_line)
end, { desc = "Toggle selection comment (Ctrl+/)" })

-- -----------------------------------------------------------------------------
-- Buffer Navigation Keybindings
-- -----------------------------------------------------------------------------
-- Space + n: Next buffer
vim.keymap.set("n", "<leader>n", "<cmd>bnext<cr>", { desc = "Next buffer (Space+n)" })

-- Space + Shift + n: Previous buffer
vim.keymap.set("n", "<leader>N", "<cmd>bprevious<cr>", { desc = "Previous buffer (Space+Shift+N)" })

-- Close current buffer (Space + bd / Space + c)
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer (Space+bd)" })

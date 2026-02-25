-- ── Options ──────────────────────────────────────────────────────────────────
local opt          = vim.opt

opt.undofile       = true -- stored automatically in ~/.local/state/nvim/undo/

opt.clipboard      = "unnamedplus"
opt.completeopt    = { "menuone", "noinsert", "noselect" }
opt.ignorecase     = true
opt.smartcase      = true
opt.number         = true
opt.relativenumber = true
opt.scrolloff      = 5
opt.wildoptions    = "pum"
opt.splitright     = true
opt.breakindent    = true
opt.signcolumn     = "yes"
opt.termguicolors  = true
opt.autoread       = true
opt.mouse          = "a"

opt.path:append("**")
opt.wildignore:append({
	"**/node_modules/**", "**/.git/**", "**/build/**",
	"**/target/**", "**/__pycache__/**", "*.o", "*.pyc",
})

opt.grepprg    = "rg --vimgrep --smart-case"
opt.grepformat = "%f:%l:%c:%m"

vim.cmd("filetype plugin indent on")

-- ── Keymaps ──────────────────────────────────────────────────────────────────
local map = function(mode, lhs, rhs, opts)
	vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { silent = true }, opts or {}))
end

map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("v", "<", "<gv")
map("v", ">", ">gv")
map("i", "<C-Space>", "<C-x><C-o>", { desc = "LSP completion" })

-- ── Terminal ─────────────────────────────────────────────────────────────────
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal → left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal → lower window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal → upper window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal → right window" })

-- Open terminals in a split
map("n", "<leader>th", "<Cmd>split | term<CR>", { desc = "Terminal horizontal split" })
map("n", "<leader>tv", "<Cmd>vsplit | term<CR>", { desc = "Terminal vertical split" })

-- Auto-enter insert mode when switching to a terminal buffer
vim.api.nvim_create_autocmd("BufEnter", {
	pattern  = "term://*",
	callback = function() vim.cmd("startinsert") end,
})

-- ── lazy.nvim bootstrap ───────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ──────────────────────────────────────────────────────────────────
require("lazy").setup({

	{
		"rose-pine/neovim",
		name     = "rose-pine",
		priority = 1000, -- load before other plugins
		config   = function()
			require("rose-pine").setup({
				variant = "moon", -- "main" | "moon" | "dawn"
				-- styles  = {
				--   -- italic = true,
				--   bold = true,
				-- },
			})
			vim.cmd("colorscheme rose-pine")
		end,
	},

	{ "williamboman/mason.nvim",          build = ":MasonUpdate" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{
		"folke/zen-mode.nvim",
		keys = { { "<leader>z", "<Cmd>ZenMode<CR>", desc = "Zen Mode" } },
		opts = {
			window = {
				width = 0.60, -- fraction of screen width
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")
			local builtin   = require("telescope.builtin")
			telescope.setup({
				defaults = {
					layout_strategy = "horizontal",
					sorting_strategy = "ascending",
					layout_config = { prompt_position = "top" },
				},
			})
			telescope.load_extension("fzf")

			local m = function(lhs, fn, desc)
				vim.keymap.set("n", lhs, fn, { silent = true, desc = desc })
			end
			m("<leader>ff", builtin.find_files, "Find files")
			m("<leader>fg", builtin.live_grep, "Live grep")
			m("<leader>fb", builtin.buffers, "Buffers")
			m("<leader>fh", builtin.help_tags, "Help tags")
			m("<leader>fd", builtin.diagnostics, "Diagnostics")
			m("<leader>fs", builtin.lsp_document_symbols, "LSP symbols")
			m("<leader>fr", builtin.lsp_references, "LSP references")
		end,
	},

	{
		"mbbill/undotree",
		keys = { { "<leader>u", "<Cmd>UndotreeToggle<CR>", desc = "Toggle Undotree" } },
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					c      = { "clang_format" },
					cpp    = { "clang_format" },
					cuda   = { "clang_format" }, -- clang-format handles .cu fine
					python = { "black" },
					lua    = { "stylua" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true, -- falls back to vim.lsp.buf.format if no formatter found
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "cpp", "lua", "python", "bash", "markdown" },
				sync_install     = false,
				auto_install     = true,
				highlight        = {
					enable = true,
					disable = function(_, buf)
						local max_filesize = 100 * 1024
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						return ok and stats and stats.size > max_filesize
					end,
				},
				indent           = { enable = true },
			})
		end,
	},

})

-- ── Mason / LSP setup ────────────────────────────────────────────────────────
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "clangd", "pyright", "lua_ls" },
})

-- clangd needs a custom cmd for the RISC-V query-driver flag
vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--query-driver=/home/ritwik/osi/xpack-riscv-none-elf-gcc-14.2.0-3/**/riscv*",
	},
})

-- ── Diagnostics ──────────────────────────────────────────────────────────────
vim.diagnostic.config({
	virtual_text     = true,
	signs            = true,
	underline        = true,
	update_in_insert = false,
	severity_sort    = true,
})

-- ── LSP keymaps (fires for every attached server) ────────────────────────────
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local buf     = ev.buf
		local bufopts = { buffer = buf }
		map("n", "gd", vim.lsp.buf.definition, bufopts)
		map("n", "gr", vim.lsp.buf.references, bufopts)
		map("n", "gD", vim.lsp.buf.declaration, bufopts)
		map("n", "gi", vim.lsp.buf.implementation, bufopts)
		map("n", "K", vim.lsp.buf.hover, bufopts)
		map("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
		map("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
		map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, bufopts)
		map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, bufopts)
		map("n", "<leader>dl", vim.diagnostic.open_float, bufopts)
		map("n", "<leader>f", vim.lsp.buf.format, bufopts)

		-- Built-in LSP completion (nvim 0.11+)
		vim.lsp.completion.enable(true, ev.data.client_id, buf, { autotrigger = false })
	end,
})

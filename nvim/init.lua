vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.cmd([[set ignorecase]])
vim.cmd([[set smartcase]])

local map = vim.keymap.set
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.pack.add({
  { src = "https://github.com/vague2k/vague.nvim" },
  { src = "https://github.com/tssm/fairyfloss.vim" },
  { src = "https://github.com/Kaikacy/Lemons.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/R-nvim/R.nvim" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/saghen/blink.cmp" },
  { src = "https://github.com/jake-stewart/multicursor.nvim" }
})

vim.cmd("colorscheme lemons")

local mc = require "multicursor-nvim"
mc.setup({})
map({"n", "x"}, "<up>", function() mc.lineAddCursor(-1) end)
map({"n", "x"}, "<down>", function() mc.lineAddCursor(1) end)
map({"n", "x"}, "<leader><up>", function() mc.lineSkipCursor(-1) end)
map({"n", "x"}, "<leader><down>", function() mc.lineSkipCursor(1) end)
map({"n", "x"}, "<leader>n", function() mc.matchAddCursor(1) end)
map({"n", "x"}, "<leader>s", function() mc.matchSkipCursor(1) end)
map({"n", "x"}, "<leader>N", function() mc.matchAddCursor(-1) end)
map({"n", "x"}, "<leader>S", function() mc.matchSkipCursor(-1) end)
mc.addKeymapLayer(function(layerSet)
    -- Select a different cursor as the main one.
    layerSet({"n", "x"}, "<left>", mc.prevCursor)
    layerSet({"n", "x"}, "<right>", mc.nextCursor)

    -- Delete the main cursor.
    layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)

    -- Enable and clear cursors using escape.
    layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
            mc.enableCursors()
        else
            mc.clearCursors()
        end
    end)
end)
require "nvim-ts-autotag".setup({})
require "mason".setup()
require "oil".setup({
  view_options = {
    show_hidden = true
  }
})
require("blink.cmp").setup({
	cmdline = {
		enabled = false,
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 0,
			treesitter_highlighting = true,
		},
		keyword = {
			range = "prefix",
		},
		list = {
			max_items = 9,
			selection = {
				preselect = true,
				auto_insert = false,
			},
		},
		accept = {
			dot_repeat = false,
			create_undo_point = true,
			auto_brackets = {
				enabled = false,
			},
		},
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	sources = {
		default = { "lsp", "path", "buffer", "snippets" },
		providers = {
			buffer = {
				enabled = true,
			},
			snippets = {
				enabled = true,
			},
		},
	},
	-- snippets = {
	-- 	preset = "mini_snippets",
	-- },
	fuzzy = {
		implementation = "lua",
		frecency = {
			enabled = true,
		},
		use_proximity = true,
		prebuilt_binaries = {
			download = true
		},
	},
})

map('n', '<C-e>', ":Oil<CR>")

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
				-- vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
				local opts = { buffer = args.buf }
				map('n', 'gd', vim.lsp.buf.definition, opts)
				map('n', 'gr', vim.lsp.buf.references, opts)
				map('n', 'gi', vim.lsp.buf.implementation, opts)
				map('n', 'gh', vim.lsp.buf.hover, opts)
				map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
				map('n', '<leader>rn', vim.lsp.buf.rename, opts)
				map('n', ']d', vim.diagnostic.goto_next, opts)
				map('n', '[d', vim.diagnostic.goto_prev, opts)
			end
		end
})
vim.opt.completeopt = "menuone,noselect,fuzzy,nosort"

vim.lsp.config.lua = {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = {
		'.luarc.json',
		'.luarc.jsonc',
		'.luacheckrc',
		'.stylua.toml',
		'stylua.toml',
		'selene.toml',
		'selene.yml',
		'.git',
	}
}

vim.lsp.config.rlang = {
	cmd = { 'r-languageserver' },
	filetypes = { 'r' },
}

vim.lsp.config.svelte = {
	cmd = { "svelteserver", "--stdio" },
	filetypes = { 'svelte' },
}

vim.lsp.config.html = {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "templ" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true
		},
		provideFormatter = true
	}
}

vim.lsp.config.python = {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python", "py" },
	settings = {
		basedpyright = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true
			}
		}
	}
}

vim.lsp.config.tailwind = {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = {
    "html",
    "css",
    "scss",
		"svelte",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_markers = {
    "tailwind.config.js",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
    "tailwind.config.ts",
    "postcss.config.js",
    "postcss.config.cjs",
    "postcss.config.mjs",
    "postcss.config.ts",
    "package.json",
    "node_modules",
  },
  settings = {
    tailwindCSS = {
      classAttributes = { "class", "className", "class:list", "classList" },
      includeLanguages = {
        templ = "html",
      },
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidConfigPath = "error",
        invalidScreen = "error",
        invalidTailwindDirective = "error",
        invalidVariant = "error",
        recommendedVariantOrder = "warning",
      },
      validate = true,
    },
  },
}

vim.lsp.enable({ 'lua', 'rlang', 'html', 'python', 'svelte', 'tailwind' })
map('n', '<leader>fm', vim.lsp.buf.format)

map("n", "]b", ":bnext<CR>")
map("n", "[b", ":bprevious<CR>")
map("n", "]t", ":tabnext<CR>")
map("n", "[t", ":tabprevious<CR>")
map("v", "<", "<gv")
map("v", ">", ">gv")
map('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })
map("n", "<C-k>", ":resize -2<CR>", { silent = true })
map("n", "<C-j>", ":resize +2<CR>", { silent = true })
map("n", "<C-h>", ":vertical resize -2<CR>", { silent = true })
map("n", "<C-l>", ":vertical resize +2<CR>", { silent = true })
map("n", "<leader>rc", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })

local augroup = vim.api.nvim_create_augroup("UserConfig", {})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.highlight.on_yank({ timeout = 450 })
	end,
})

vim.api.nvim_create_autocmd("FileType", { -- enable treesitter highlighting and indents
	group = augroup,
	callback = function(ev)
		local filetype = ev.match
		local lang = vim.treesitter.language.get_lang(filetype)
		if vim.treesitter.language.add(lang) then
			if vim.treesitter.query.get(filetype, "folds") then
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			end
			vim.treesitter.start()
		end
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    pattern = 'term://*',
    callback = function()
        vim.schedule(function()
            vim.cmd(':startinsert')
        end)
    end,
})

local ensureInstalled = { "markdown", "markdown_inline", "r", "rnoweb", "yaml", "latex", "csv", "typescript", "python", "css", "html", "ocaml" }
local alreadyInstalled = require("nvim-treesitter.config").get_installed()
local parsersToInstall = vim.iter(ensureInstalled)
		:filter(function(parser) return not vim.tbl_contains(alreadyInstalled, parser) end)
		:totable()
require("nvim-treesitter").install(parsersToInstall)

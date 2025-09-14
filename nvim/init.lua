vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.opt.winborder = "rounded"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitright = true

local map = vim.keymap.set
vim.g.mapleader = " "

vim.pack.add({
	{ src = "https://github.com/tssm/fairyfloss.vim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" }
})

require "mason".setup()
require "oil".setup()
require "lualine".setup()
map('n', '<leader>e', ":Oil<CR>")
map('i', '<c-e>', function() vim.lsp.completion.get() end)

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

			local opts = {buffer = args.buf}
			map('n', 'gd', vim.lsp.buf.definition, opts)
			map('n', 'gr', vim.lsp.buf.references, opts)
			map('n', 'gi', vim.lsp.buf.implementation, opts)
			map('n', 'gh', vim.lsp.buf.hover, opts)
			map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
			map('n', '<leader>rn', vim.lsp.buf.rename, opts)
			map('n', ']d', vim.diagnostic.goto_next, opts)
			map('n', '[d', vim.diagnostic.goto_prev, opts)
		end
	end,
})

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
	}}

vim.lsp.enable({'lua'})

map('n', '<leader>lf', vim.lsp.buf.format)
vim.cmd [[set completeopt+=menuone,noselect,popup]]
vim.cmd("colorscheme fairyfloss")

map("n", "]b", ":bnext<CR>")
map("n", "[b", ":bprevious<CR>")
map("v", "<", "<gv")
map("v", ">", ">gv")

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("UserConfig", {}),
  callback = function()
    vim.highlight.on_yank({ timeout = 450 })
  end,
})


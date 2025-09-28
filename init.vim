"================ Vim Plug =====================
"Auto install Vim Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstal.l:project_pathl | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" Essential
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/fern.vim'

" "--------- Language syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Color schema
Plug 'EdenEast/nightfox.nvim' " Vim-Plug
" Theme + Style
"Plug 'norcalli/nvim-colorizer.lua'
Plug 'ryanoasis/vim-devicons'
Plug 'lambdalisue/fern-renderer-devicons.vim'
" Show indent line
Plug 'lukas-reineke/indent-blankline.nvim'
" Register list
Plug 'junegunn/vim-peekaboo'

" Support to jump to text
Plug 'smoka7/hop.nvim'
Plug 'ntpeters/vim-better-whitespace'
"{
let g:better_whitespace_filetypes_blacklist=['log', 'fugitive', 'quickfix', 'git']
"}
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'mg979/vim-visual-multi'
" Extend matching for html tag
Plug 'dhruvasagar/vim-table-mode'

" Note taking
"  Git
Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'
"{
let g:fugitive_gitlab_domains = ['https://git.code4you.com']
"}
Plug 'junkblocker/git-time-lapse'
" --- Integrate github to git
Plug 'tpope/vim-rhubarb'
" Align text
Plug 'junegunn/vim-easy-align'
" Auto add pairing
Plug 'windwp/nvim-autopairs'
" Better end in ruby,lua
Plug 'RRethy/nvim-treesitter-endwise'

" More shortcut/keybinding
Plug 'tpope/vim-unimpaired'
" Split/Join code
Plug 'AndrewRadev/splitjoin.vim'
" Send command to tmux
Plug 'christoomey/vim-tmux-runner'

" Navigate between tmux and vim
Plug 'christoomey/vim-tmux-navigator'

" Snippet
Plug 'honza/vim-snippets'
Plug 'mlaursen/vim-react-snippets'

" Indent object, fit for yml,python file
Plug 'michaeljsmith/vim-indent-object'
" CamelCaseMotion
Plug 'bkad/CamelCaseMotion'
"---{
let g:camelcasemotion_key = ','
"---}
" NarrowText in temp buffer
Plug 'chrisbra/NrrwRgn'

" Support raw search for ag and rg from fzf
Plug 'jesseleite/vim-agriculture'

" Markdown and folding
Plug 'plasticboy/vim-markdown'

" Asynchonous call
Plug 'tpope/vim-dispatch'
" manage projection and alternate file
Plug 'tpope/vim-projectionist'

" Completion plugins
Plug 'hrsh7th/nvim-cmp'           " Autocompletion plugin
Plug 'hrsh7th/cmp-nvim-lsp'       " LSP source for nvim-cmp
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
" Completion list for yank
Plug 'gbprod/yanky.nvim'
Plug 'chrisgrieser/cmp_yanky'
"
" LSP Config for Neovim
Plug 'neovim/nvim-lspconfig'

" Mason for managing LSP servers, linters, formatters
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
" Formatter
Plug 'stevearc/conform.nvim'

" Snippet engine (required for nvim-cmp)
Plug 'L3MON4D3/LuaSnip'           " Snippet engine
Plug 'saadparwaiz1/cmp_luasnip'   " Snippet completions

" Statusline with LSP progress
Plug 'nvim-lualine/lualine.nvim'
" Icons for better UI (optional but recommended)
Plug 'kyazdani42/nvim-web-devicons'

" LSP status indicator
Plug 'j-hui/fidget.nvim'

" Symbol postion
Plug 'SmiteshP/nvim-navic'

" Bookmark with note
Plug 'MattesGroeger/vim-bookmarks'
" Json path
Plug 'mogelbrod/vim-jsonpath'
"---{
let g:jsonpath_register = '*'
"---}
call plug#end()

"{
lua << LUA
local function paste(e)
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end
-- local status, osc52 = pcall(require, "vim.ui.clipboard.osc52")
-- vim.g.clipboard = {
--   name = "OSC 52",
--   copy = {
--     ["+"] = osc52.copy("+"),
--     ["*"] = osc52.copy("*"),
--   },
--   paste = {
--     ["+"] = osc52.paste("+"),
--     ["*"] = osc52.paste("*"),
--   },
-- }

function EnabledOsc52()
  local status, osc52 = pcall(require, "vim.ui.clipboard.osc52")
  if not status then
    print("Error: OSC 52 module not found!")
    return
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = paste("+"),
      ["*"] = paste("*"),
    },
  }

  print("OSC 52 clipboard enabled!")
end

-- Make the function available in Vim command mode
vim.api.nvim_create_user_command("EnableOsc52", EnabledOsc52, {})
require("hop").setup()
require("ibl").setup()

vim.api.nvim_set_keymap('', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap('', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
vim.api.nvim_set_keymap('', 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })<cr>", {})
vim.api.nvim_set_keymap('', 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })<cr>", {})

require("nvim-autopairs").setup {}
-- Load custom treesitter grammar for org filetype
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "haskell", "phpdoc" },
  endwise = {
    enable = true,
  },
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = function(lang, bufnr)
      local max_line_length = 1000 -- Set the max line length
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      for _, line in ipairs(lines) do
          if #line > max_line_length then
              return true -- Disable highlighting for this buffer
          end
      end
      return false -- Keep highlighting enabled
    end,
  },
  incremental_selection = {
    enable = false,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

require("yanky").setup({
  highlight = {
    on_put = false,
    on_yank = false,
  },
})

-- Initialize Mason
require('mason').setup()

-- Ensure that Mason installs the LSPs we need
require('mason-lspconfig').setup({
  ensure_installed = { 'pyright', 'lua_ls' },  -- Add your desired language servers here
  automatic_installation = true,
})

-- Setup LSP configurations
local lspconfig = require('lspconfig')
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
    if result.diagnostics then
        -- Filter out the specific error code
        result.diagnostics = vim.tbl_filter(function(diagnostic)
            return diagnostic.code ~= "-32603"
        end, result.diagnostics)
    end
    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
end

-- Add command for format disable and enable
vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })
vim.keymap.set("", "<Space>cf", function()
    -- Get the selected range in visual mode
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")

    -- Call the Format command with the selected range
    vim.cmd(string.format(":%d,%dFormat", start_line, end_line))
end, { desc = "Format selected code in visual mode" })

local function is_disabled_format_repo()
    -- Run a shell command to get the Git remote origin URL
    local handle = io.popen("git config --get remote.origin.url 2>/dev/null")
    if not handle then
        return false -- Return false if the command fails
    end

    local result = handle:read("*a")
    handle:close()

    -- Trim whitespace from the result
    result = result:gsub("%s+", "")

    -- Check if the remote origin contains 'jenny'
    return result:find("jenhacool") ~= nil
end

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    ruby = {"standardrb" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    javascriptreact = { "prettierd", lsp_format = "fallback" },
    json = { "fixjson"}
  },
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    -- Disable autoformat for files in a certain path
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname:match("/node_modules/") or is_disabled_format_repo() then
      return
    end

    return { timeout_ms = 2000, lsp_format = "fallback" }
  end,
})

local navic = require('nvim-navic')
navic.setup({
  depth_limit = 2,
})

-- Function to attach keybindings and format on save
local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'x', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'E', '<cmd>lua vim.diagnostic.open_float({ focusable = true })<CR>', opts)

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      signs = {
        min = "Error",
      },
      virtual_text = {
        min = "Error",
      },
    }
  )
  -- Check if the LSP supports document symbols, then attach nvim-navic
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end


require('lspconfig').eslint.setup{
  settings = {
    format = { enable = false },
  }
}

-- Setup LSP for servers managed by Mason
require('mason-lspconfig').setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = on_attach,
    })
  end
})

-- Setup for LSP autocompletion using nvim-cmp
local cmp = require 'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users
    end,
  },
  mapping = {
    ['<C-N>'] = cmp.mapping.select_next_item(),
    ['<C-P>'] = cmp.mapping.select_prev_item(),
    ['<C-X>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },   -- For vsnip users.
    { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end
      }
    },
    { name = 'path' },
    {
      name = "cmp_yanky",
      option = {
        -- only suggest items which match the current filetype
        onlyCurrentFiletype = false,
        -- only suggest items with a minimum length
        minLength = 3,
      },
    }
  })
})

-- Setup LSP completion capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Attach capabilities to LSP configurations
require('mason-lspconfig').setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
})

-- Lualine setup with LSP status
require('lualine').setup{
  options = {
    theme = 'auto',
    icons_enabled = true,
  },
  sections = {
    lualine_b = {},
    lualine_c = {
      function()
        local mode = vim.api.nvim_get_mode().mode
        if mode == "t" then
          return ""
        end

        local filepath = vim.fn.fnamemodify(vim.fn.expand('%:p'), ':~:.')
        return vim.fn.pathshorten(filepath)   -- Shorten it using pathshorten
      end,
      {'lsp_progress'},  -- LSP status
    },
    lualine_y = {},
    lualine_x = {
      -- Treesitter context (current symbol)
      {
          function()
            return navic.get_location() -- Get current symbol location
          end,
          cond = function()
            return navic.is_available() -- Only show if navic data is available
          end,
      }
    },
  },
}

-- Fidget setup for LSP progress
require('fidget').setup{}
LUA
"}

set laststatus=2
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s '
  let initial_command = printf(command_fmt, a:query)
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Ignore that because it leads to start in replace mode
nnoremap <Esc><Esc> :noh<CR><Esc>

" Select inside the tick
function! Ticks(inner)
    normal! gv
    call searchpos('`', 'bW')
    if a:inner | exe "normal! 1\<space>" | endif
    normal! o
    call searchpos('`', 'W')
    if a:inner | exe "normal! \<bs>" | endif
endfunction

vnoremap <silent> a` :<c-u>call Ticks(0)<cr>
vnoremap <silent> i` :<c-u>call Ticks(1)<cr>

onoremap <silent> a` :<c-u>normal va`<cr>
onoremap <silent> i` :<c-u>normal vi`<cr>

" Map Emacs like movement in Insert mode
inoremap <C-n> <Down>
inoremap <C-p> <Up>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>^

cnoremap <C-A>		<Home>
cnoremap <C-B>		<Left>
cnoremap <C-D>		<Del>
cnoremap <C-E>		<End>
cnoremap <C-F>		<Right>
cnoremap <C-N>		<Down>
cnoremap <C-P>		<Up>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

" These mappings will make it so that going to the next one in a search will
" center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" https://vim.fandom.com/wiki/Selecting_your_pasted_text
nnoremap gp `[v`]
" "========================================================
" " leader config
" "========================================================
let mapleader=" "

noremap  <silent> <leader>m :Fern . -drawer -toggle<CR>
noremap  <silent> <leader>r :execute GoToProjDir() <bar> Fern . -reveal=% -drawer<CR>

" TmuxRunner
"{
let g:vtr_filetype_runner_overrides = {
        \ 'ruby': 'ruby -w {file}',
        \ 'javascript': 'node {file}',
        \ 'sql': 'usql postgres://postgres@localhost:5432/flexlane?sslmode=disable -G -f {file}',
        \ 'haskell': 'runhaskell {file}'
        \ }
nnoremap <leader>v- :VtrOpenRunner { "orientation": "v", "percentage": 30 }<cr>
nnoremap <leader>v\ :VtrOpenRunner { "orientation": "h", "percentage": 30 }<cr>
nnoremap <leader>vk :VtrKillRunner<cr>
nnoremap <leader>vd :VtrSendCtrlD<cr>
nnoremap <leader>vc :VtrSendCtrlC<cr>
nnoremap <leader>vp :VtrSendKeysRaw Up Enter<cr>
nnoremap <leader>va :VtrAttachToPane<cr>
nnoremap <leader>vq :VtrSendKeysRaw q<cr>
nnoremap <leader>vz :VtrFocusRunner<cr>
nnoremap <leader>v0 :VtrAttachToPane 0<cr>:call system("tmux clock-mode -t 0 && sleep 0.1 && tmux send-keys -t 0 q")<cr>
nnoremap <leader>v1 :VtrAttachToPane 1<cr>:call system("tmux clock-mode -t 1 && sleep 0.1 && tmux send-keys -t 1 q")<cr>
nnoremap <leader>v2 :VtrAttachToPane 2<cr>:call system("tmux clock-mode -t 2 && sleep 0.1 && tmux send-keys -t 2 q")<cr>
nnoremap <leader>v3 :VtrAttachToPane 3<cr>:call system("tmux clock-mode -t 3 && sleep 0.1 && tmux send-keys -t 3 q")<cr>
nnoremap <leader>v4 :VtrAttachToPane 4<cr>:call system("tmux clock-mode -t 4 && sleep 0.1 && tmux send-keys -t 4 q")<cr>
nnoremap <leader>v5 :VtrAttachToPane 5<cr>:call system("tmux clock-mode -t 5 && sleep 0.1 && tmux send-keys -t 5 q")<cr>
nnoremap <leader>vf :VtrSendFile<cr>
nnoremap <C-c><C-c> :VtrSendLinesToRunner<cr>
" Work in ruby with escape chracter. Will list down other cases
vnoremap <C-c><C-c> y:VtrSendCommandToRunner <C-R>" <cr>

function! GoToProjDir()
  let path = expand('%:p')
  let path_parts = split(path, '/')
  let project_part_idx = 0
  for part in path_parts
    if part == "projects"
      if stridx(path, "hashback") >=0
        let project_part_idx += 1
      endif

      break
    endif

    let project_part_idx += 1

  endfor

  let project_path = "/".join(path_parts[0:project_part_idx + 1], "/")
  execute 'cd '.l:project_path
endfunction
" Mapping tmux-navigator control
let g:fern#mapping#mappings= ['drawer', 'filter', 'mark', 'node', 'open', 'wait', 'yank']
autocmd FileType fern nnoremap <buffer> <c-l> :wincmd l<cr>
autocmd FileType fern nmap <buffer><nowait> z <Plug>(fern-action-zoom:half)
autocmd FileType fern nnoremap <buffer> <c-j> :TmuxNavigateDown<cr>
autocmd FileType fern hi CursorLine ctermbg=20 guibg=#2c323c gui=bold

"Trigger and copy path in json file
au FileType json nnoremap <buffer> <silent> K :JsonPath<CR>
" Searching
noremap  <leader>f :FZF<CR>
vnoremap <leader>f y:call fzf#vim#files('.', {'options': ['--query', '<C-R>=@"<CR>']})<CR>
noremap  <leader>b :Buffers<CR>
noremap  <silent> <leader>h :call fzf#vim#history({ 'options': ['--header-lines', 0, '--header', getcwd()]})<CR>
noremap  <leader>d :Cd <CR>
" Search for the word under cursor
nnoremap <silent> <leader>rg :call  histadd("cmd", 'Rg <C-R><C-W>')   <bar> Rg <C-R><C-W><CR>
vnoremap <silent> <leader>rg y:call histadd("cmd", 'Rg <C-R>=@"<CR>') <bar> Rg <C-R>=@"<CR><CR>
" Add handle in fern, move to new active buffer
function! SearchFern(input, function_name)
  wincmd l
  let l:ascii_name = substitute(split(a:input)[1], "\\..*$", "", 'g')
  let l:ascii_name = substitute(l:ascii_name, "/", "", 'g')
  call histadd('cmd', a:function_name.' '.l:ascii_name)
  execute a:function_name.' '.l:ascii_name
endfunction
autocmd FileType fern nmap <silent> <buffer> <leader>rg :call SearchFern('<C-R><C-L>', 'Rg')<CR>

nnoremap <silent> <leader>/ :BLines<CR>

" Search for the visually selected text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Open sh in current folder
noremap  <leader>z :split <bar> term<cr>
tnoremap <leader>z <c-\><c-n><c-o><esc><esc>
tnoremap <leader>q <c-\><c-n>
" Quick saving / edit
noremap <leader>w :w<cr>
noremap <leader>e :e!<cr>
noremap <leader>q :q<cr>
" only tab
noremap <leader>to :tabonly<cr>
" Split screen
noremap <leader>s :vsplit<cr>
" Change to avoid conflict with vimtmux
noremap <leader>vv :split<cr>

" Copy and Comment Lines
nmap gy yygccp

" Copy current file / folder path
nnoremap <silent> cP :let @+ = expand("%")   <bar> echo @+<CR>
nnoremap <silent> cp :let @+ = expand("%:p") <bar> echo @+<CR>
nnoremap <silent> cl :let @+ = expand("%").":".line(".") <bar> echo @+<CR>
nnoremap <silent> cL :let @+ = expand("%:p").":".line(".") <bar> echo @+<CR>

" Git
noremap  <leader>gl :execute 'Git pull origin '.FugitiveHead()<cr>
noremap  <leader>gL :Git stash <bar> execute 'Git pull origin '.FugitiveHead() <bar> Git stash apply <bar> echo "Pull success"<cr>
noremap  <leader>gp :Git push origin HEAD <bar>echo "Pushed success" <cr>
noremap  <leader>gP :Git push origin HEAD --force <bar>echo "Pushed success" <cr>
noremap  <leader>gb :Git blame<cr>
noremap  <leader>gc :BranchList<cr>
noremap  <leader>gC :BranchList!<cr>
noremap  <leader>gm :echo 'Merging origin/'.GetMergeBranchByProj() <bar> execute 'Git fetch origin '.GetMergeBranchByProj() <bar> execute 'Git merge origin/'.GetMergeBranchByProj() <cr>
noremap  <leader>gd :execute 'Git diff '.GInitCommitWhenBranching().'..HEAD'<cr>
noremap  <leader>gD :execute 'Git diff --name-status '.GInitCommitWhenBranching().'..HEAD'<cr>
noremap  <leader>g1 :Git cherry-pick HEAD@{1}<cr>
noremap  <leader>g0 :Git cherry-pick HEAD@{2}<Left>

" reload current file in source code
noremap  <leader>gr :execute 'edit +'.line('.').' '.substitute(expand('%'), 'fugitive://\\|.git//\x*/', '', 'g')<cr>

function! GInitCommitWhenBranching()
  let merge_branch = GetMergeBranchByProj()
  let commit = system('git merge-base '.FugitiveHead().' origin/'.l:merge_branch)
  return commit[:-2]
endfunction

function! GNewBranch()
  let branch_name = input('Enter your branch ('.pathshorten(getcwd()).'):')
  if len(l:branch_name) == 0
    return
  endif

  let merge_branch = GetMergeBranchByProj()

  execute '!git fetch origin '.l:merge_branch
  execute '!git checkout -b '.l:branch_name.' origin/'.l:merge_branch
endfunction

function! HasGitMainBranch()
    " Run the Git command to check if 'main' exists as a local branch
    let l:has_main = system('git branch --list main')

    " Trim whitespace and check the result
    return !empty(l:has_main) ? 1 : 0
endfunction

function! GetMergeBranchByProj()
  let merge_branch = HasGitMainBranch() ? 'main' : 'master'
  if stridx(getcwd(), "employment-hero") >=0
        \ || stridx(getcwd(), "smartmatch-hub") >= 0
        \ || stridx(getcwd(), "eh-mobile-pro") >= 0
    let merge_branch = "development"
  elseif stridx(getcwd(), "time-tracking") >=0
        \ || stridx(getcwd(), "sales-boost") >= 0
        \ || stridx(getcwd(), "bbc") >= 0
    let merge_branch = "dev"
  elseif stridx(getcwd(), "frontend-script") >= 0
        \ || stridx(getcwd(), "shabu-town") >= 0
        \ || stridx(getcwd(), "react-native-mixpanel") >= 0
        \ || stridx(getcwd(), "ebf-swag-personal") >= 0
    let merge_branch = "main"
  endif
  return merge_branch
endfunction
noremap <silent> <leader>gn :call GNewBranch()<CR>

" Git status in new tab
noremap  <leader>gs :Gtabedit :<cr>
noremap  <leader>gS :Git<cr>
nnoremap <leader>gh :GBrowse!<cr>
vnoremap <leader>gh :GBrowse!<cr>
nnoremap <leader>gH :GBrowse<cr>
vnoremap <leader>gH :GBrowse<cr>

function! OpenFilePath(fugitive_path)
  let file_path_with_hash = split(split(a:fugitive_path, '//')[-1])[-1]
  let file_path_index = 0
  if stridx(file_path_with_hash, "a/") >= 0 || stridx(file_path_with_hash, "b/") >= 0
    let file_path_index = 1
  endif
  let file_path = join(split(file_path_with_hash, '/')[file_path_index:], '/')
  execute 'edit '.file_path
endfunction

augroup fugitive_ext
  autocmd!
  " Browse to the commit under my cursor
  autocmd FileType fugitiveblame,git,qf nnoremap <buffer> <leader>gh :execute ":GBrowse " . expand("<cword>")<cr>
  autocmd FileType fugitive nnoremap <buffer> <leader>gb :GBrowse head<cr>
  autocmd FileType fugitive nnoremap <buffer> <leader>gB :GBrowse! head<cr>
  autocmd FileType fugitive nnoremap <buffer> D :!rm -rf <c-r><c-f><cr>
  "autocmd FileType fugitive setlocal synmaxcol=500
  " Unmap q so that we can use macro to multiple remove
  " autocmd FileType fugitive nunmap <buffer> q
  autocmd FileType git nnoremap <buffer> q q
  autocmd FileType fugitive,help DisableWhitespace
  autocmd FileType git nnoremap <buffer> go Vy:call OpenFilePath('<C-R>=@"<CR>')<CR>
augroup END

" Github PR
function! s:pr_cmd_by_proj()
  if stridx(getcwd(), "Thinkei") >= 0
    execute "Git hub-pr -d"
  else
    execute "Git hub-pr"
  endif
endfunction
nnoremap <leader>pr :call <SID>pr_cmd_by_proj()<cr>

" Github PR list
function! s:pr_checkout(selected)
  let l:pr_number = split(a:selected[1])[0]
  if a:selected[0] == 'ctrl-o'
    execute '!hub pr show '.l:pr_number
  else
    execute '!hub pr checkout '.l:pr_number
  endif
endfunction

command! -nargs=* -complete=dir -bang PrList call
      \ fzf#run(fzf#wrap(
      \ {
      \ 'source': "hub pr list -f '%I %t-%au %cr %n'".(<bang>0 == 0 ? '' : ' -s all -L 200'),
      \ 'sink*': function('s:pr_checkout'),
      \ 'options': [
      \   '--tiebreak', 'index',
      \   '--prompt', "Pull request>",
      \   '--expect=ctrl-o'
      \ ]
      \ } , 0))
nnoremap <leader>pl :PrList<cr>
nnoremap <leader>pL :PrList!<cr>

" Open github PR at current branch
function! Open_Pr_In_Branch()
  if has('mac')
    execute "!open $(hub pr list --format='\\%H \\%U \\%n' | grep $(git rev-parse --abbrev-ref HEAD) | awk '{print $2}')"
  elseif has("unix")
    execute "!xdg-open $(hub pr list --format='\\%H \\%U \\%n' | grep $(git rev-parse --abbrev-ref HEAD) | awk '{print $2}')"
  endif
endfunction
nnoremap <silent> <leader>po :call Open_Pr_In_Branch()<cr><cr>

" Checkout list branch
function! s:git_checkout(selected)
  let l:branch = split(a:selected[1])[0]
  if a:selected[0] == 'ctrl-d'
    for delete_selected in a:selected[1:]
      let l:delete_branch = split(delete_selected)[0]
      execute '!git branch -D '.l:delete_branch
    endfor
    echo 'Deleted branch successfully'
  else
    execute 'Git checkout '.l:branch
  endif
 endfunction
command! -nargs=* -complete=dir -bang BranchList call
      \ fzf#run(fzf#wrap(
      \ {
      \ 'source': "git for-each-ref --sort=-committerdate refs/heads/ --format=".shellescape(
      \ '%(HEAD)  %(refname:short)  - %(contents:subject) - %(authorname) (%(committerdate:relative))'
      \ )
      \ .(<bang>0 == 0 ? '' : ' --all'),
      \ 'sink*': function('s:git_checkout'),
      \ 'options': [
      \   '--tiebreak', 'index',
      \   '--multi' ,
      \   '--prompt', "Branches>",
      \   '--expect=ctrl-d'
      \ ]
      \ },0))

" Choose window config
nmap     <leader>-  <Plug>(choosewin)
" Equal window width
function! EqualWindow()
  let window_counter = 0
  windo let window_counter = window_counter + 1
  let size = &columns/l:window_counter
  execute 'windo vertical resize '.l:size
endfunction
nmap     <leader>=  :call EqualWindow()<cr>

" Easy jump
map  <leader>jk :HopChar1<CR>
map  <leader>jw :HopChar1MW<CR>
xmap <leader>jk <cmd>lua require'hop'.hint_char1()<CR>

let g:fern#renderer = "devicons"
let g:fern_renderer_devicons_disable_warning = 1
if !exists('g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols')
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
endif

" yank/copy-paste policy
set clipboard=unnamed,unnamedplus

set autoindent " Copy indent from current line when starting a new line
set smarttab
set tabstop=2 " Number of space og a <Tab> character
set softtabstop=2
set shiftwidth=2 " Number of spaces use by autoindent
" set lazyredraw
set synmaxcol=120  " avoid slow rendering for long lines
" set redrawtime=5000
set regexpengine=1
set expandtab
set noshowmode
set conceallevel=2
set fileencodings=utf-8
"  Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
if has('nvim')
  set inccommand=split          " enables interactive search and replace
endif

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldnestmax=10
set nofoldenable
set foldlevel=2

set nobackup
set nowritebackup
set noswapfile
set nonumber
set nornu

set showcmd

" enable splitright
set splitright

setlocal nobackup
setlocal nowritebackup

set nowritebackup
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes

" Quick escape
inoremap jk <ESC>
inoremap jj <ESC>

" Custom FZF for default search file
let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs --hidden'.
      \' --glob !.git'.
      \' --glob !node_modules'.
      \' --glob !dist'.
      \' --glob !target'.
      \' --glob !bin'.
      \' --glob !build'.
      \' --glob "!*.cm*"'.
      \' --glob "!*.reast"'.
      \' --glob "!*.d"'.
      \' --glob "!.cache"'.
      \' --glob "!*.snap"'.
      \' --glob "!*.class"'.
      \' --glob "!*.bs.js"'.
      \' --glob "!*.ast"'.
      \' '

" If using macos please check with shortcut key. By default, ctr-space is
" switch between input source in mac
let $FZF_DEFAULT_OPTS='--bind '.
      \ 'ctrl-space:toggle-out,'.
      \ 'shift-tab:toggle-in,'.
      \ 'ctrl-alt-j:preview-down,'.
      \ 'ctrl-alt-k:preview-up,'.
      \ 'alt-a:select-all,'.
      \ 'alt-d:deselect-all'

let g:fzf_preview_window = &columns > 120 ? 'right:40%:wrap' : ''
autocmd VimResized * let g:fzf_preview_window = &columns > 120 ? 'right:40%:wrap' : ''
" Border style (rounded / sharp / horizontal)
let g:fzf_layout = { 'down': '40%' }

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-h': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit',
      \ }

" Custom matching tag
let g:mta_use_matchparen_group = 1

"----- Add redirect output of command
" Ref: https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! Redir(cmd, rng, start, end)
  for win in range(1, winnr('$'))
    if getwinvar(win, 'scratch')
      execute win . 'windo close'
    endif
  endfor
  if a:cmd =~ '^!'
    let cmd = a:cmd =~' %'
      \ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
      \ : matchstr(a:cmd, '^!\zs.*')
    if a:rng == 0
      let output = systemlist(cmd)
    else
      let joined_lines = join(getline(a:start, a:end), '\n')
      let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
      let output = systemlist(cmd . " <<< $" . cleaned_lines)
    endif
  else
    redir => output
    execute a:cmd
    redir END
    let output = split(output, "\n")
  endif
  vnew
  let w:scratch = 1
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  call setline(1, output)
endfunction
command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)
"End custom redirect output

au FileType gitcommit set  textwidth=0
au FileType markdown  setl conceallevel=0
" Set background and colorscheme
set termguicolors
" Show menu and force user to select
set completeopt=menu,menuone,noselect
" set concellevel to make json looking right. Ref: https://www.reddit.com/r/neovim/comments/12l1zs0/why_are_quotes_only_showing_up_on_current_line_in/
set conceallevel=0
" choose color which from nvcode-color-schemes
colorscheme nightfox

hi Visual guibg=#445c80
" Fern color
hi link FernRootSymbol Title
hi link FernRootText   Title
" Required for operations modifying multiple buffers like rename.
set hidden
" Save file as root
command! -nargs=0 Sw w !sudo tee % > /dev/null
" Multiple path for example: find ~/projects ~/Downloads -maxdepth 1 -type d
" Detect hightlight at cursor http://www.drchip.org/astronaut/vim/index.html#Maps
" customize function put to the end of the file to make sure treesitter work
let g:workspace = get(g:, 'workspace', '')
command! -nargs=* -complete=dir -bang Cd call
      \ fzf#run(fzf#wrap(
      \ {
      \ 'source': join(['find ~/projects ~/projects/gabo'.g:workspace, '-maxdepth 1 ',"-type d | awk '!x[$0]++'"], ' '),
      \ 'sink': 'cd',
      \ 'options': [
      \ '-q', len(<q-args>) > 0 ?(<q-args>): '',
      \ '-1',
      \ '--prompt', getcwd().">"]
      \ } , <bang>0))
command! -nargs=* -complete=dir -bang TmuxLogs call
      \ fzf#run(fzf#wrap(
      \ {
        \ 'source': join(['find ~', '-maxdepth 1','-name tmux\*', '| sort -r'], ' '),
        \ 'sink': 'edit',
        \ 'options': [
          \ '-q', len(<q-args>) > 0 ?(<q-args>): '',
          \ '--prompt', "TmuxLogs"]
          \ } , <bang>0))

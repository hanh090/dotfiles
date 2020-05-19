call plug#begin('~/.vim/plugged')
" Essential
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/fern.vim'
Plug 'carlitux/deoplete-ternjs'

"--------- Language syntax
" JS
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'
" Ruby
Plug 'vim-ruby/vim-ruby'
" ---------END Language syntax
" Theme + Style
Plug 'roosta/vim-srcery'
Plug 'ap/vim-css-color'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'ryanoasis/vim-devicons'
Plug 'lambdalisue/fern-renderer-devicons.vim'
" Register list
Plug 'junegunn/vim-peekaboo'

" Cursor for linux
if has('unix')
  Plug 'wincent/terminus'
endif

" Choose window
Plug 't9md/vim-choosewin'

" Support
Plug 'matze/vim-move'
Plug 'easymotion/vim-easymotion'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'
Plug 'alvan/vim-closetag'
Plug 'jremmen/vim-ripgrep'
" Extend matching for html tag
Plug 'tmhedberg/matchit'
" Enhance matching tag for xml, html document
Plug 'Valloric/MatchTagAlways'

"  Git
Plug 'tpope/vim-fugitive'
" Align text
Plug 'junegunn/vim-easy-align'

" Coding style
" Plug 'prettier/vim-prettier', {
"   \ 'do': 'yarn install',
"   \ 'for': ['javascript', 'css', 'json', 'scss'] }
Plug 'jiangmiao/auto-pairs'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Code completion, LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Airline for status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Github line
Plug 'ruanyl/vim-gh-line'

call plug#end()

set laststatus=2

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
" Ignore that because it leads to start in replace mode
nnoremap <Esc><Esc> :noh<CR><Esc>
"
" "========================================================
" " leader config
" "========================================================
let mapleader=" "

noremap  <silent><leader>m :Fern . -drawer -toggle<CR>
map      <leader>r :Fern . -reveal=% -drawer<CR>
" Searching
noremap  <leader>f :FZF<CR>
noremap  <leader>a :Ag <CR>
noremap  <leader>o :Buffers <CR>
noremap  <leader>h :History <CR>
nnoremap <silent> <leader>ag :Ag <C-R><C-W><CR>
nnoremap <C-g> :Rg<Cr>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Quick saving / edit
noremap <leader>w :w<cr>
noremap <leader>e :e<cr>
noremap <leader>q :q<cr>

" Split screen
noremap <leader>s :vsplit<cr>
noremap <leader>v :split<cr>

" Copy current file / folder path
nnoremap cp :let @+ = expand("%")<CR>
nnoremap cP :let @+ = expand("%:p")<CR>

" Git
noremap <leader>gu :Gpull<cr>
noremap <leader>gp :Gpush<cr>
noremap <leader>gb :Gblame<cr>

" Choose window config
nmap  <leader>-  <Plug>(choosewin)

" Easy jump
map  <leader>j <Plug>(easymotion-bd-w)
nmap <leader>j <Plug>(easymotion-overwin-w)

let g:fern#renderer = "devicons"

" Custom airline
let g:airline_theme='onedark'
let g:webdevicons_enable_airline_statusline = 1
" Custom closetag
let g:closetag_filenames = '*.js,*.jsx,*.html, *.xml'
" Custom vim-move to use control to move line up/down
let g:move_key_modifier = 'C'

filetype plugin indent on

set clipboard=unnamedplus
set autoindent " Copy indent from current line when starting a new line
set smarttab
set tabstop=2 " Number of space og a <Tab> character
set softtabstop=2
set shiftwidth=2 " Number of spaces use by autoindent
set lazyredraw
set redrawtime=10000
set regexpengine=1
set expandtab
"
" "" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2

set nobackup
set noswapfile
set number
set rnu

set showcmd

let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" ==== START COC config
" List coc plugin
let g:coc_global_extensions = ['coc-tsserver', 'coc-prettier', 'coc-json',  'coc-highlight',  'coc-eslint',  'coc-xml',  'coc-java',  'coc-html']


set nowritebackup
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> qf <Plug>(coc-codeaction)
nmap <silent> fm <Plug>(coc-format)
nmap <silent> rn <Plug>(coc-rename)
nmap rl :echo CocAction('reloadExtension', 'coc-eslint')<CR>
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
" Symbol renaming.
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" === END COC config

" Auto format
" autocmd BufWritePre * StripWhitespaceOnChangedLines
" autocmd BufWritePre *.js,*.jsx,*.css,*.scss,*.less,*.json Prettier
autocmd BufWritePre *.js,*.jsx,*.css,*.scss,*.less,*.json CocCommand prettier.formatFile
autocmd BufNewFile,BufRead *.tsx set filetype=typescript


" Quick escape
inoremap jk <ESC>
inoremap jj <ESC>
" Copy matches only
function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

" Custom FZF
let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs --hidden --glob !.git --glob !node_modules --glob !target'
let g:fzf_preview_window = 'right:40%'

" Custom matching tag
let g:mta_use_matchparen_group = 0

" Set background and colorscheme
colorscheme solarized8_high
set background=dark
hi CocErrorSign cterm=bold,reverse ctermfg=160 ctermbg=230 guifg=White guibg=Red
hi CocUnderlineError cterm=underline ctermfg=61 gui=undercurl guisp=Red
hi link CocErrorHighlight CocUnderlineError
hi MatchTag term=reverse cterm=reverse ctermfg=136 ctermbg=236 guibg=Yellow

" Required for operations modifying multiple buffers like rename.
set hidden
" Save file as root
command! -nargs=0 Sw w !sudo tee % > /dev/null

call plug#begin('~/.vim/plugged')
" Essential
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/fern.vim'

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
" Show indent line
Plug 'Yggdroot/indentLine'
" Better display for json
Plug 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0
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
" Extend matching for html tag
Plug 'tmhedberg/matchit'
" Enhance matching tag for xml, html document
Plug 'Valloric/MatchTagAlways'

"  Git
Plug 'tpope/vim-fugitive'
" --- Integrate github to git
Plug 'tpope/vim-rhubarb'
Plug 'stsewd/fzf-checkout.vim'
" Align text
Plug 'junegunn/vim-easy-align'
" Auto add pairing
Plug 'jiangmiao/auto-pairs'

" Code completion, LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Airline for status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" More shortcut/keybinding
Plug 'tpope/vim-unimpaired'

" Vim wiki
" Plug 'vimwiki/vimwiki'

" ReasonML
Plug 'reasonml-editor/vim-reason-plus'

call plug#end()

set laststatus=2

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s '
  let initial_command = printf(command_fmt, a:query)
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

"Multiple path for example: find ~/projects ~/Downloads -maxdepth 1 -type d
command! -nargs=* -complete=dir -bang Cd call fzf#run(fzf#wrap( { 'source': join(['find ~/projects', '-maxdepth 1 ','-type d'], ' '), 'sink': 'cd', 'options': len(<q-args>) > 0 ?'-q '.(<q-args>): '' } , <bang>0))
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
noremap  <leader>d :Cd <CR>
" Search for the word under cursor
nnoremap <silent> <leader>ag :Ag <C-R><C-W><CR>
" Search for the visually selected text
nnoremap <silent> <leader>rg :Rg <C-R><C-W><Cr>
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Open sh in current folder
if !has('nvim')
 noremap <leader>z :sh<cr>
endif
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
noremap <leader>gp :Git push origin HEAD<cr>
noremap <leader>gb :Gblame<cr>
noremap <leader>gc :GCheckout<cr>
" Git status in new tab
noremap <leader>gs :Gtabedit :<cr>
nnoremap <leader>gh :Gbrowse <cr>
augroup fugitive_ext
  autocmd!
  " Browse to the commit under my cursor
  autocmd FileType fugitiveblame nnoremap <buffer> <leader>gh :execute ":Gbrowse " . expand("<cword>")<cr>
  autocmd FileType reason let b:AutoPairs = AutoPairsDefine({'(':')', '[':']', '{':'}'})
augroup END

" Choose window config
nmap  <leader>-  <Plug>(choosewin)

" Easy jump
map  <leader>jk <Plug>(easymotion-bd-w)
nmap <leader>jw <Plug>(easymotion-overwin-w)
nmap <leader>jl <Plug>(easymotion-overwin-line)

let g:fern#renderer = "devicons"
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['re'] = 'λ'

" Custom airline
let g:airline_theme='onedark'
let g:airline#extensions#default#layout = [
      \ [ 'a', 'b', 'c' ],
      \ [ 'error', 'warning' ]
      \ ]
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
let g:coc_global_extensions = ['coc-tsserver', 'coc-prettier', 'coc-json',  'coc-highlight',  'coc-eslint',  'coc-xml',  'coc-java',  'coc-html', 'coc-solargraph', 'coc-reason']


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
" Symbol renaming.
nmap <silent> cn <Plug>(coc-rename)
nmap <silent> cl :echo CocAction('reloadExtension', 'coc-eslint')<CR>
nmap <silent> co :CocList outline<CR>
nmap <silent> cu :CocList output<CR>
nmap <silent> cd :CocList diagnostics<CR>
nmap <silent> cD :CocList --normal diagnostics<CR>
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" === END COC config

" Auto format
autocmd BufWritePre *.js,*.jsx,*.css,*.scss,*.less,*.json,*.html CocCommand prettier.formatFile
autocmd BufWritePre *.re call CocAction('format')
autocmd BufNewFile,BufRead *.tsx set filetype=typescript


" Quick escape
inoremap jk <ESC>
inoremap jj <ESC>

" Custom FZF for default search file
let $FZF_DEFAULT_COMMAND = 'rg --files  --no-ignore-vcs --hidden --glob !.git --glob !node_modules --glob !target --glob !bin --glob "!*.cm*" --glob "!*.reast" --glob "!*.d"'
let g:fzf_preview_window = 'right:40%'

" Custom git checkout
let g:fzf_checkout_git_options = '--sort=committerdate'
let g:fzf_checkout_execute = 'system'

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-h': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

" Custom matching tag
let g:mta_use_matchparen_group = 0

" Custom autopair for reason
autocmd FileType reason let b:AutoPairs = AutoPairsDefine({'(':')', '[':']', '{':'}'})

" Set background and colorscheme
colorscheme solarized8_high
set background=dark
hi CocErrorSign cterm=bold,reverse ctermfg=160 ctermbg=230 guifg=White guibg=Red
hi CocUnderlineError cterm=underline ctermfg=61 gui=undercurl guisp=Red
hi link CocErrorHighlight CocUnderlineError
hi MatchTag term=reverse cterm=reverse ctermfg=136 ctermbg=236 guibg=Yellow
hi MatchParen ctermfg=yellow

" Required for operations modifying multiple buffers like rename.
set hidden
" Save file as root
command! -nargs=0 Sw w !sudo tee % > /dev/null

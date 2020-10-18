"================ Vim Plug =====================
"Auto install Vim Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" Essential
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/fern.vim'

"--------- Language syntax
" JS
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
" " Ruby
Plug 'vim-ruby/vim-ruby'
" ---------END Language syntax
" Theme + Style
Plug 'norcalli/nvim-colorizer.lua'
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

" Support
Plug 'matze/vim-move'
Plug 'easymotion/vim-easymotion'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'mg979/vim-visual-multi'
Plug 'alvan/vim-closetag'
" Extend matching for html tag
Plug 'andymass/vim-matchup'
" Enhance matching tag for xml, html document
Plug 'Valloric/MatchTagAlways'

"  Git
Plug 'tpope/vim-fugitive'
" --- Integrate github to git
Plug 'tpope/vim-rhubarb'
" Align text
Plug 'junegunn/vim-easy-align'
" Auto add pairing
Plug 'hanh090/auto-pairs'

" Code completion, LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Airline for status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" More shortcut/keybinding
Plug 'tpope/vim-unimpaired'

" Split/Join code
Plug 'AndrewRadev/splitjoin.vim'

" ReasonML
Plug 'hanh090/vim-reason-plus'
" Send command to tmux
Plug 'jgdavey/tslime.vim'
"{
let g:tslime_always_current_session = 1
let g:tslime_always_current_window = 1
vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
nmap <C-c>r <Plug>SetTmuxVars
"}

" Navigate between tmux and vim
Plug 'christoomey/vim-tmux-navigator'

" Choose win
Plug 't9md/vim-choosewin'

" Snippet
Plug 'honza/vim-snippets'

if has("nvim")
  " Fix cursor hold in nvim
  Plug 'antoinemadec/FixCursorHold.nvim'
  " Fix sudo problem
  Plug 'lambdalisue/suda.vim'
endif

" Support raw search for ag and rg from fzf
Plug 'jesseleite/vim-agriculture'

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

" Multiple path for example: find ~/projects ~/Downloads -maxdepth 1 -type d
" Detect hightlight at cursor http://www.drchip.org/astronaut/vim/index.html#Maps
command! -nargs=* -complete=dir -bang Cd call
      \ fzf#run(fzf#wrap(
      \ {
      \ 'source': join(['find ~/projects', '-maxdepth 1 ','-type d'], ' '),
      \ 'sink': 'cd',
      \ 'options': [
      \ '-q', len(<q-args>) > 0 ?(<q-args>): '',
      \ '--prompt', getcwd().">"]
      \ } , <bang>0))
" Ignore that because it leads to start in replace mode
nnoremap <Esc><Esc> :noh<CR><Esc>
" Move to bottom after select paragraph
vnoremap y y']

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

noremap  <silent> <leader>m :Fern . -drawer -toggle<CR>
noremap  <silent> <leader>r :Fern . -reveal=% -drawer<CR>
" Mapping tmux-navigator control
autocmd FileType fern nnoremap <buffer> <c-l> :TmuxNavigateRight<cr>
autocmd FileType fern nnoremap <buffer> <c-j> :TmuxNavigateDown<cr>
" Searching
noremap  <leader>f :FZF<CR>
noremap <silent> <leader>h :call fzf#vim#history({ 'options': ['--header-lines', 0, '--header', getcwd()]})<CR>
noremap  <leader>d :Cd <CR>
" Search for the word under cursor
nnoremap <silent> <leader>ag :Ag <C-R><C-W><CR>
vnoremap <silent> <leader>ag y:Ag <C-R>=@"<CR><CR>
nnoremap <silent> <leader>rg :Rg <C-R><C-W><Cr>
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

" Split screen
noremap <leader>s :vsplit<cr>
noremap <leader>v :split<cr>

" Copy current file / folder path
nnoremap cp :let @+ = expand("%")   <bar> echo @+<CR>
nnoremap cP :let @+ = expand("%:p") <bar> echo @+<CR>

" Git
noremap  <leader>gl :execute 'Git pull origin '.FugitiveHead()<cr>
noremap  <leader>gp :Git push origin HEAD <bar>echo "Pushed success" <cr>
noremap  <leader>gb :Gblame<cr>
noremap  <leader>gc :BranchList<cr>
noremap  <leader>gC :BranchList!<cr>

function! GNewBranch()
  let branch_name = input('Enter your branch ('.pathshorten(getcwd()).'):')
  if len(l:branch_name) == 0
    return
  endif
  let merge_branch = 'master'
  if stridx(getcwd(), "employment-hero") >=0
    let merge_branch = "development"
  endif
  execute '!git fetch origin '.l:merge_branch
  execute '!git checkout -b '.l:branch_name.' origin/'.l:merge_branch
endfunction
noremap <leader>gn :call GNewBranch()<cr>
" Git status in new tab
noremap  <leader>gs :Gtabedit :<cr>
noremap  <leader>gS :Gstatus<cr>
nnoremap <leader>gh :Gbrowse<cr>
vnoremap <leader>gh :Gbrowse<cr>
augroup fugitive_ext
  autocmd!
  " Browse to the commit under my cursor
  autocmd FileType fugitiveblame nnoremap <buffer> <leader>gh :execute ":Gbrowse " . expand("<cword>")<cr>
  autocmd FileType fugitive nnoremap <buffer> D :!rm <c-r><c-f><cr>
augroup END

" Github PR
nnoremap <leader>pr :Git pull-request -d<cr>

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
      execute 'Git branch -D '.l:delete_branch
      echom 'Deleted branch '.l:delete_branch
    endfor
  else
    execute 'Git checkout '.l:branch
  endif
 endfunction
command! -nargs=* -complete=dir -bang BranchList call
      \ fzf#run(fzf#wrap(
      \ {
      \ 'source': "git for-each-ref --sort=-committerdate refs/heads/ --format=".shellescape('%(HEAD)  %(refname:short)  - %(contents:subject) - %(authorname) (%(committerdate:relative))').(<bang>0 == 0 ? '' : ' --all'),
      \ 'sink*': function('s:git_checkout'),
      \ 'options': [
      \   '--tiebreak', 'index',
      \   '--multi' ,
      \   '--prompt', "Branches>",
      \   '--expect=ctrl-d'
      \ ]
      \ } , 0))

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
map  <leader>jk <Plug>(easymotion-bd-w)
nmap <leader>jw <Plug>(easymotion-overwin-w)
nmap <leader>jl <Plug>(easymotion-overwin-line)
nmap <leader>jf <Plug>(easymotion-overwin-f2)

let g:fern#renderer = "devicons"
let g:fern_renderer_devicons_disable_warning = 1
if !exists('g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols')
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
endif
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['re'] = 'λ'
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['mjml'] = ''

" Custom airline
let g:airline_theme='bubblegum'

let g:airline_section_c=airline#section#create(["%{pathshorten(fnamemodify(expand('%'), ':~:.'))}"])
let g:airline_section_b=airline#section#create(["%{FugitiveHead()[:20]}"])
let g:airline#extensions#default#layout = [
      \ [ 'a', 'b', 'c' ],
      \ [ 'error', 'warning' ]
      \ ]


" Custom closetag
let g:closetag_filenames = '*.js,*.jsx,*.html, *.xml'
" Custom vim-move to use control to move line up/down
" let g:move_key_modifier = 'C-S'

" Keep folder vim and terminal same
function! s:CtrlZ()
  call writefile([getcwd(),''], '/tmp/cd_vim', 'b')
  return "\<C-z>"
endfunction
nnoremap <expr> <C-z> <SID>CtrlZ()

filetype plugin indent on

if has('win32') || has('win64') || has('mac')
  set clipboard=unnamed
else
  set clipboard=unnamed,unnamedplus
endif

set autoindent " Copy indent from current line when starting a new line
set smarttab
set tabstop=2 " Number of space og a <Tab> character
set softtabstop=2
set shiftwidth=2 " Number of spaces use by autoindent
set lazyredraw
set synmaxcol=128  " avoid slow rendering for long lines
set redrawtime=10000
set regexpengine=1
set expandtab
set noshowmode
"
"  Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
if has('nvim')
  set inccommand=split          " enables interactive search and replace
endif

set foldmethod=manual
set foldnestmax=10
set nofoldenable
set foldlevel=2

set nobackup
set nowritebackup
set noswapfile
set nonumber
set nornu

set showcmd

setlocal nobackup
setlocal nowritebackup
" ==== START COC config
" List coc plugin
let g:coc_global_extensions =
      \ [
      \ 'coc-eslint',
      \ 'coc-highlight',
      \ 'coc-html',
      \ 'coc-java',
      \ 'coc-json',
      \ 'coc-prettier',
      \ 'coc-reason',
      \ 'coc-snippets',
      \ 'coc-solargraph',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ 'coc-xml',
      \ 'coc-yank',
      \ ]


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
nmap <silent> <space>co :CocList outline<CR>
nmap <silent> <space>cu :CocList output<CR>
nmap <silent> <space>cd :CocList diagnostics<CR>
nmap <silent> <space>cD :CocList --normal diagnostics<CR>
" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
" Show full message.ce mean coc-expand
nmap <silent> <space>ce :call CocAction("diagnosticInfo")<cr>
" List of yank
nmap <silent> <space>cy  :<C-u>CocList -N yank<cr>
nmap <silent> <space>cY  :<C-u>CocList --normal yank<cr>:set filetype=vim<cr>
" quick fix
nmap <silent> <space>cq <Plug>(coc-codeaction)
nmap <silent> <space>cf <Plug>(coc-format)
vmap <silent> <space>cf <Plug>(coc-format-selected)
" Symbol renaming.
nmap <silent> <space>cn <Plug>(coc-rename)
function! s:reload_coc_extension()
  if(&filetype == 'javascript')
    let l:result = CocAction('reloadExtension', 'coc-eslint')
    echo 'Reload coc-eslint with result='.l:result
  elseif(&filetype == 'typescript' || &filetype == 'typescriptreact')
    let l:result = CocAction('reloadExtension', 'coc-typescript')
    echo 'Reload coc-typescript with result='.l:result
  elseif(&filetype == 'reason')
    let l:result = CocAction('reloadExtension', 'coc-reason')
    echo 'Reload coc-reason with result='.l:result
  elseif(&filetype == 'ruby')
    let l:result = CocAction('reloadExtension', 'coc-solargraph')
    echo 'Reload coc-solargraph with result='.l:result
  elseif(&filetype == 'java')
    let l:result = CocAction('reloadExtension', 'coc-java')
    echo 'Reload coc-java with result='.l:result
  else
    CocRestart
  endif
endfunction
nmap <silent> <space>cl :call <SID>reload_coc_extension()<CR>
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" === END COC config

" Auto format
autocmd BufWritePre *.js,*.jsx,*.css,*.scss,*.less,*.json,*.html,*.ts,*.tsx CocCommand prettier.formatFile
autocmd BufWritePre *.re call CocAction('format')


" Quick escape
inoremap jk <ESC>
inoremap jj <ESC>

" Custom FZF for default search file
let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs --hidden'.
      \' --glob !.git'.
      \' --glob !node_modules'.
      \' --glob !target'.
      \' --glob !bin'.
      \' --glob "!*.cm*"'.
      \' --glob "!*.reast"'.
      \' --glob "!*.d"'.
      \' --glob "!.cache"'.
      \' --glob "!*.class"'.
      \' '

let $FZF_DEFAULT_OPTS='--bind '.
      \ 'ctrl-space:toggle-out,'.
      \ 'shift-tab:toggle-in,'.
      \ 'ctrl-alt-j:preview-down,'.
      \ 'ctrl-alt-k:preview-up,'.
      \ 'alt-a:select-all,'.
      \ 'alt-d:deselect-all'

let g:fzf_preview_window = 'right:40%:wrap'

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
let g:mta_use_matchparen_group = 0

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

" Custom autopair for filetype.First parameter is adding, second parameter is
" removing
au FileType reason let b:AutoPairs = AutoPairsDefine({'/**':'**/'}, ["`", "'"])
au FileType html let b:AutoPairs = AutoPairsDefine({'<!--' : '-->'})
au FileType gitcommit set textwidth=0
" Set background and colorscheme
set termguicolors
colorscheme one
set background=dark

hi CocErrorSign cterm=bold,reverse ctermfg=160 ctermbg=230 guifg=White guibg=Red
hi CocUnderlineError cterm=underline ctermfg=61 gui=undercurl guisp=Red
hi link CocErrorHighlight CocUnderlineError
hi MatchTag term=reverse cterm=reverse ctermfg=136 ctermbg=236 guibg=Yellow
hi MatchParen ctermfg=yellow
hi Visual cterm=reverse ctermbg=242 guibg=#303030cterm=reverse ctermbg=242 gui=reverse guifg=#586e75 guibg=#002b36
" Required for operations modifying multiple buffers like rename.
set hidden
" Save file as root
command! -nargs=0 Sw w !sudo tee % > /dev/null

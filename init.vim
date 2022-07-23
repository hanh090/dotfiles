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
Plug 'nvim-treesitter/playground'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'christianchiarulli/nvcode-color-schemes.vim'
" " Theme + Style
Plug 'norcalli/nvim-colorizer.lua'
" Plug 'rafi/awesome-vim-colorschemes'
Plug 'ryanoasis/vim-devicons'
Plug 'lambdalisue/fern-renderer-devicons.vim'
" Show indent line
Plug 'lukas-reineke/indent-blankline.nvim'
"----{
"}
Plug 'elzr/vim-json'
" Register list
Plug 'junegunn/vim-peekaboo'

" Cursor for linux
if has('unix')
  Plug 'wincent/terminus'
endif

" Support
Plug 'easymotion/vim-easymotion'
Plug 'ntpeters/vim-better-whitespace'
"{
let g:better_whitespace_filetypes_blacklist=['log', 'fugitive', 'quickfix', 'git']
"}
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
Plug 'tpope/vim-fugitive', { 'tag': 'v3.5' }
Plug 'junkblocker/git-time-lapse'
" --- Integrate github to git
Plug 'tpope/vim-rhubarb'
" -- Integrate gitlab to git fugitive
Plug 'shumphrey/fugitive-gitlab.vim'
"----{
let g:gitlab_api_keys = {'gitlab.com': 'glpat-yksby3x_HHJRc8ziuQet'}
"}
" Fugitive Bitbucket
Plug 'tommcdo/vim-fubitive'
" Align text
Plug 'junegunn/vim-easy-align'
" Auto add pairing
Plug 'hanh090/auto-pairs'

" Code completion, LSP
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" Airline for status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'


" More shortcut/keybinding
Plug 'tpope/vim-unimpaired'
" Split/Join code
Plug 'AndrewRadev/splitjoin.vim'
" Fix json for human
Plug 'rhysd/vim-fixjson'
" Send command to tmux
Plug 'christoomey/vim-tmux-runner'

" Navigate between tmux and vim
Plug 'christoomey/vim-tmux-navigator'

" Choose win
Plug 't9md/vim-choosewin'

" Snippet
Plug 'honza/vim-snippets'
" Autoformat
Plug 'Chiel92/vim-autoformat'

" Indent object, fit for yml,python file
Plug 'michaeljsmith/vim-indent-object'
" CamelCaseMotion
Plug 'bkad/CamelCaseMotion'
"---{
let g:camelcasemotion_key = ','
"---}
" NarrowText in temp buffer
Plug 'chrisbra/NrrwRgn'

if has("nvim")
  " Fix cursor hold in nvim
  Plug 'antoinemadec/FixCursorHold.nvim'
  " Fix sudo problem
  Plug 'lambdalisue/suda.vim'
endif

" Support raw search for ag and rg from fzf
Plug 'jesseleite/vim-agriculture'

" Add log hightlight
Plug 'MTDL9/vim-log-highlighting'

" Markdown and folding
Plug 'plasticboy/vim-markdown'

" Asynchonous call
Plug 'tpope/vim-dispatch'
" manage projection and alternate file
Plug 'tpope/vim-projectionist'
" for ghost text
Plug 'raghur/vim-ghost'

"Interactive buffer
" Plug 'metakirby5/codi.vim'
" Rainbow parenless
" Plug 'luochen1990/rainbow'
" let g:rainbow_active = 0
call plug#end()

"{
lua << LUA
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "haskell", "phpdoc", "ruby" },
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
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

" Multiple path for example: find ~/projects ~/Downloads -maxdepth 1 -type d
" Detect hightlight at cursor http://www.drchip.org/astronaut/vim/index.html#Maps
command! -nargs=* -complete=dir -bang Cd call
      \ fzf#run(fzf#wrap(
      \ {
      \ 'source': join(['find ~/projects', '-maxdepth 1 ','-type d'], ' '),
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
" Ignore that because it leads to start in replace mode
nnoremap <Esc><Esc> :noh<CR><Esc>
" Move to bottom after select paragraph
vnoremap y y']

nmap gx :silent execute "!open " . shellescape("<cWORD>")<CR><CR>

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
nnoremap <leader>v- :VtrOpenRunner { "orientation": "v", "percentage": 30 }<cr>
nnoremap <leader>v\ :VtrOpenRunner { "orientation": "h", "percentage": 30 }<cr>
nnoremap <leader>vk :VtrKillRunner<cr>
nnoremap <leader>vd :VtrSendCtrlD<cr>
nnoremap <leader>va :VtrAttachToPane<cr>
nnoremap <leader>vq :VtrSendKeyRaw q<cr>
nnoremap <leader>v0 :VtrAttachToPane 0<cr>:call system("tmux clock-mode -t 0 && sleep 0.1 && tmux send-keys -t 0 q")<cr>
nnoremap <leader>v1 :VtrAttachToPane 1<cr>:call system("tmux clock-mode -t 1 && sleep 0.1 && tmux send-keys -t 1 q")<cr>
nnoremap <leader>v2 :VtrAttachToPane 2<cr>:call system("tmux clock-mode -t 2 && sleep 0.1 && tmux send-keys -t 2 q")<cr>
nnoremap <leader>v3 :VtrAttachToPane 3<cr>:call system("tmux clock-mode -t 3 && sleep 0.1 && tmux send-keys -t 3 q")<cr>
nnoremap <leader>v4 :VtrAttachToPane 4<cr>:call system("tmux clock-mode -t 4 && sleep 0.1 && tmux send-keys -t 4 q")<cr>
nnoremap <leader>v5 :VtrAttachToPane 5<cr>:call system("tmux clock-mode -t 5 && sleep 0.1 && tmux send-keys -t 5 q")<cr>
nnoremap <leader>vf :VtrFocusRunner<cr>
noremap <C-c><C-c> :VtrSendLinesToRunner<cr>
"}

function! GoToProjDir()
  let path_parts = split(expand('%:p'), '/')
  let project_part_idx = 0
  for part in path_parts
    if part == "projects"
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
" Searching
noremap  <leader>f :FZF<CR>
vnoremap <leader>f y:call fzf#vim#files('.', {'options': ['--query', '<C-R>=@"<CR>']})<CR>
noremap  <leader>b :Buffers<CR>
noremap  <silent> <leader>h :call fzf#vim#history({ 'options': ['--header-lines', 0, '--header', getcwd()]})<CR>
noremap  <leader>d :Cd <CR>
" Search for the word under cursor
nnoremap <silent> <leader>ag :call  histadd("cmd", 'Ag <C-R><C-W>')   <bar> Ag <C-R><C-W><CR>
vnoremap <silent> <leader>ag y:call histadd("cmd", 'Ag <C-R>=@"<CR>') <bar> Ag <C-R>=@"<CR><CR>
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
autocmd FileType fern nmap <silent> <buffer> <leader>ag :call SearchFern('<C-R><C-L>', 'Ag')<CR>
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
nnoremap <silent> cp :let @+ = expand("%")   <bar> echo @+<CR>
nnoremap <silent> cP :let @+ = expand("%:p") <bar> echo @+<CR>
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
noremap  <leader>g0 :Git cherry-pick<space>
noremap  <leader>gr :!gmr<space>

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

function! GetMergeBranchByProj()
  let merge_branch = 'master'
  if stridx(getcwd(), "employment-hero") >=0
    let merge_branch = "development"
  elseif stridx(getcwd(), "plan-manager") >= 0
    let merge_branch = "dev"
  elseif stridx(getcwd(), "frontend-script") >= 0
        \ || stridx(getcwd(), "shabu-town") >= 0
    let merge_branch = "main"
  elseif stridx(getcwd(), "genvita-mobile") >= 0
    let merge_branch = "release/uat"
  elseif stridx(getcwd(), "genvita") >= 0
    let merge_branch = "develop"
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
  autocmd FileType * set synmaxcol=200
  autocmd FileType fugitive set synmaxcol=500
  " Unmap q so that we can use macro to multiple remove
  autocmd FileType fugitive nunmap <buffer> q
  autocmd FileType git nnoremap <buffer> q q
  autocmd FileType fugitive,help DisableWhitespace
  autocmd FileType git nnoremap <buffer> go Vy:call OpenFilePath('<C-R>=@"<CR>')<CR>
augroup END

" Github PR
function! s:pr_cmd_by_proj()
  if stridx(getcwd(), "shabu-town") >= 0 ||
        \ stridx(getcwd(), "coop-game") >= 0
    execute "Git hub-pr"
  else
    execute "Git hub-pr -d"
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

command! -nargs=* -complete=dir -bang FindReference call
      \ fzf#run(fzf#wrap(
      \ {
      \ 'source': "cat ~/projects/frontend-core/.dependencyGraph.json | jq 'to_entries[] | select(.value | .[] | index(\"".expand("%")."\") > 0) | select (. | length > 0) | .key' | sed 's/\"//g'",
      \ 'options': [
      \   '--tiebreak', 'index',
      \   '--prompt', "Find ref>",
      \ ]
      \ }, 0))

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
let g:EasyMotion_smartcase = 1
map  <leader>jk <Plug>(easymotion-s)
map  <leader>ja <Plug>(easymotion-lineanywhere)
map  <leader>jA <Plug>(easymotion-jumptoanywhere)
map  <leader>jf <Plug>(easymotion-overwin-f2)
nmap <leader>jw <Plug>(easymotion-overwin-w)
nmap <leader>jl <Plug>(easymotion-overwin-line)
" Remove annoyed Coc in jump mode
autocmd User EasyMotionPromptBegin silent! CocDisable
autocmd User EasyMotionPromptEnd   silent! CocEnable

" autocmd User EasyMotionPromptBegin silent! TSBufDisable
" autocmd User EasyMotionPromptEnd   silent! TSBufEnable

let g:fern#renderer = "devicons"
let g:fern_renderer_devicons_disable_warning = 1
if !exists('g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols')
  let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}
endif
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['re']   = 'λ'
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['res']   = 'λ'
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['mjml'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['xml']  = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['properties']  = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['snap']  = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['apib']  = ''

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

" yank/copy-paste policy
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
" ==== START COC config
" List coc plugin
let g:coc_global_extensions =
      \ [
      \ 'coc-angular',
      \ 'coc-eslint',
      \ 'coc-highlight',
      \ 'coc-html',
      \ 'coc-java',
      \ 'coc-json',
      \ 'coc-prettier',
      \ 'coc-python',
      \ 'coc-snippets',
      \ 'coc-solargraph',
      \ 'coc-sql',
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
nmap <silent> gs :call CocAction('jumpDefinition', 'vne')<CR>
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
vmap <silent> <space>cq <Plug>(coc-codeaction-selected)
nmap <silent> <space>cf <Plug>(coc-format)
vmap <silent> <space>cf <Plug>(coc-format-selected)
" Add text object
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
"format json need jq command in system
autocmd FileType json nnoremap <buffer> <leader>cf :%!jq '.'<cr>
" Symbol renaming.
nmap <silent> <space>cn <Plug>(coc-rename)
function! s:reload_coc_extension()
  if(&filetype == 'javascript')
    let l:result = CocAction('reloadExtension', 'coc-eslint')
    echo 'Reload coc-eslint with result='.l:result
  elseif(&filetype == 'typescript' || &filetype == 'typescriptreact')
    let l:result = CocAction('reloadExtension', 'coc-tsserver')
    echo 'Reload coc-typescript with result='.l:result
  elseif(&filetype == 'reason')
    let l:result = CocAction('reloadExtension', 'coc-reason')
    echo 'Reload coc-reason with result='.l:result
  elseif(&filetype == 'ruby')
    let l:result = CocAction('reloadExtension', 'coc-solargraph')
    echo 'Reload coc-solargraph with result='.l:result
  elseif(&filetype == 'java')
    call coc#rpc#notify('runCommand', ['java.clean.workspace'])
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

  " Use <C-l> for trigger snippet expand.
  imap <C-l> <Plug>(coc-snippets-expand)
  " Use <C-j> for select text for visual placeholder of snippet.
  vmap <C-j> <Plug>(coc-snippets-select)
  " Use <C-j> for jump to next placeholder, it's default of coc.nvim
  let g:coc_snippet_next = '<c-j>'
  " Use <C-k> for jump to previous placeholder, it's default of coc.nvim
  let g:coc_snippet_prev = '<c-k>'
  " Use <C-j> for both expand and jump (make expand higher priority.)
  imap <C-j> <Plug>(coc-snippets-expand-jump)

" === END COC config

" Auto format
autocmd BufWritePre *.js,*.jsx,*.css,*.scss,*.less,*.ts,*.tsx if stridx(expand("%:p"), "node_modules") < 0 | call CocAction('format') | endif
autocmd BufWritePre *.re,*.res call CocAction('format')
" Temporary fix for ruby syntax.Ref: https://github.com/nvim-treesitter/nvim-treesitter/issues/584#issuecomment-708607922
autocmd BufNewFile,BufRead *.rb set ft=ruby


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

" Custom autopair for filetype.First parameter is adding, second parameter is
" removing
au FileType reason   let b:AutoPairs = AutoPairsDefine({'/**':'**/'},       ["`",     "'"])
au FileType rescript let b:AutoPairs = AutoPairsDefine({'/**':'**/'},       ["`",     "'"])
au FileType html     let b:AutoPairs = AutoPairsDefine({'<!--':'-->'})
au FileType markdown let b:AutoPairs = AutoPairsDefine({},                  ["["])
au FileType ruby     let b:AutoPairs = AutoPairsDefine({'\v(^|\s)\zsbegin': 'end//n', '\v(^|\s)\zsdo': 'end//n', '|':'|'})

au FileType gitcommit set  textwidth=0
au FileType markdown  setl conceallevel=0
" Set background and colorscheme
set termguicolors
" configure nvcode-color-schemes
let g:nvcode_termcolors=256
colorscheme nvcode

hi CocErrorSign cterm=bold,reverse ctermfg=160 ctermbg=230 guifg=White guibg=Red
hi CocUnderlineError cterm=underline ctermfg=61 gui=undercurl guisp=Red
hi link CocErrorHighlight CocUnderlineError
hi MatchTag term=reverse cterm=reverse ctermfg=136 ctermbg=236 guibg=Yellow
hi MatchParen ctermfg=yellow
hi Search  ctermfg=234 ctermbg=180 guifg=#1e1e1e guibg=#e5c07b
hi Cursor  ctermfg=234 ctermbg=white guifg=#1e1e1e guibg=#e5c07b

" hi Visual cterm=reverse ctermbg=242 guibg=#303030 cterm=reverse ctermbg=242 gui=reverse guifg=#586e75 guibg=#002b36
" Required for operations modifying multiple buffers like rename.
set hidden
" Save file as root
command! -nargs=0 Sw w !sudo tee % > /dev/null
" execute alias in vim
autocmd vimenter * let &shell='/bin/zsh -i'

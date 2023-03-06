" vim:set et sw=2 ts=2 tw=79 fdm=marker:

" {{{ Basic Settings:  can be copyied around

" leader is space
let mapleader=" "
nnoremap <SPACE> <Nop>

" use true color
if (has("termguicolors"))
  set termguicolors
endif

scriptencoding utf-8

set timeout " don't wait for too long for key combinations
set timeoutlen=1000
set tabstop=4
set shiftwidth=4
set nu rnu
set virtualedit=block
set nostartofline
set directory=~/tmp
set foldmethod=manual
set foldlevelstart=99
set mouse=nvirh
set ignorecase
set smartcase
set autoindent
set smartindent
set nobackup " No tmp or swp files
set nowritebackup
set noswapfile
set cursorline
set colorcolumn=80
set noshowmode "  hide -- INSERT --
set clipboard+=unnamedplus " System clipboard
set hidden " allow unsaved buffers to be hidden
set nomore
set cmdheight=2
set laststatus=3
set splitbelow
set splitright
set pastetoggle=<F6>
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
"set shortmess+=cW
set shortmess=a
" always show sign column
set signcolumn=yes
set scrolloff=3 " keep more lines above and below cursor

syntax sync fromstart " more reliable syntax highlight

" map common mistakes
cmap Q q!
cmap Wq wq
imap jk <esc>
" tmap jk <c-\><c-n>
imap jj <esc>
imap kk <esc>

" quick insert commands
inoremap II <Esc>I
inoremap AA <Esc>A
inoremap OO <Esc>O
inoremap UU <Esc>u
inoremap Pp <Esc>P
inoremap PP <Esc>pa
inoremap CC <Esc>cc

map <M-a> ggVG

let g:netrw_fastbrowse = 0 " remove netrw after opening file

" ctrl-s to save and to normal mode
noremap  <silent> <C-S> <esc>:update<CR>:nohl<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>:nohl<CR>
inoremap <silent> <C-S> <esc>:update<CR>:nohl<CR>
snoremap <silent> <C-S> <esc>:update<CR>:nohl<CR>

" disable highlight various keys
nnoremap <silent> <C-c> <C-c>:nohl<CR>
inoremap <silent> <C-c> <Esc>:nohl<CR>
vnoremap <silent> <C-c> <Esc>:nohl<CR>
nnoremap <silent> <esc> <Esc>:nohl<CR>
inoremap <silent> <esc> <Esc>:nohl<CR>
vnoremap <silent> <esc> <Esc>:nohl<CR>
snoremap <silent> <esc> <Esc>:nohl<CR>

" leader-tab to previous buffer
nnoremap <leader><tab> <C-^>
inoremap <C-^> <esc><C-^>
nnoremap <S-Tab> <C-^>
inoremap <S-Tab> <esc><C-^>
nnoremap <A-Tab> <C-^>
inoremap <A-Tab> <esc><C-^>

nnoremap c* :let @/ = expand("<cword>")<CR>cgn
nnoremap c# :let @/ = expand("<cword>")<CR>cgN

" visual mode put selected to search
vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>N
vnoremap $ g_

" last-position-jump when re-opening a file
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" copy matches command
" :CopyMatches or :CopyMatches x where x is a register
" use g/ to search by regex and then call CopyMatches
function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

" fast resize window
map <expr> - winnr('$') > 1 ? '2<C-w>-' : ''
map <expr> + winnr('$') > 1 ? '2<C-w>+' : ''
map <expr> <leader>= winnr('$') > 1 ? '6<C-W>+' : ''
map <expr> <leader>- winnr('$') > 1 ? '6<C-W>-' : ''
map <expr> <leader>. winnr('$') > 1 ? '6<C-W>>' : ''
map <expr> <leader>, winnr('$') > 1 ? '6<C-W><' : ''

" [c]lear [w]hitespace
function! ClearWhitespace()
  let winview = winsaveview()
  let _s=@/
  execute 'keepjumps %s/\s\+$//e'
  let @/=_s
  nohl
  " update
  call winrestview(winview)
endfunctio
nnoremap <leader>cw :call ClearWhitespace()<CR>
nnoremap <leader>kx :call ClearWhitespace()<CR>

" Copy current buffer path to system clipboard
" I picked 5 because it's also the '%' key.
nnoremap <silent> <Leader><Leader>5 :let @+ = expand("%:p")<CR>:echom "copied: " . expand("%:p")<CR>

" Y to yank to end of line
nnoremap Y y$

" keep cursor when searching
" nnoremap n nzzzv
" nnoremap N Nzzzv
" nnoremap J mzJ`z

" break undo on common editing chars
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" populate jump list when moving with count
" nnoremap <silent> <expr> j (v:count > 1 ? "m'" . v:count : "") . 'gj'
" nnoremap <silent> <expr> k (v:count > 1 ? "m'" . v:count : "") . 'gk'

nmap <leader><leader>x :so % <bar> silent Sleuth<CR>

function! MoveByWord(flag, visual)
  " regex explained:
  " \v very magical
  " ((\a|_)+\A*){count} match full word + non word as group count times
  " \zs match the pattern before and move cursor to next element
  " ((\a|_)+) match a full word (cursor at beginning)
  " call search('\v((\a|_)+\A*){'.(v:count).'}\zs((\a|_)+)', a:flag, line('.'))
  if a:visual | execute "norm! gv" | endif
  for n in range(v:count1)
    call search('\v(\w|_)+', a:flag, line('.'))
  endfor
endfunction

" L/H to move to the next/previous capital letter
" <C-u> to break the count, if <expr> use <esc> to break out the count
map <silent> H :<C-u>call MoveByWord('b', 0)<CR>
map <silent> L :<C-u>call MoveByWord('', 0)<CR>
vmap <silent> H :<C-u>call MoveByWord('b', 1)<CR>
vmap <silent> L :<C-u>call MoveByWord('', 1)<CR>

" replace without yanking
" vnoremap p "_dp
" vnoremap P "_dP

" set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
" set listchars=tab:..,trail:_,extends:>,precedes:<,nbsp:~
set listchars=tab:-->,space:·,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨

" Toggle Movements {{{
" Helper function to use an alternate movement if the first
" movement doesn't move the cursor.
function! ToggleMovement(firstOp, thenOp, visual)
  if a:visual | execute "norm! gv" | endif
  let pos = getpos('.')
  let c = v:count > 0 ? v:count : ''
  execute "normal! " . c . a:firstOp
  if pos == getpos('.')
    execute "normal! " . c . a:thenOp
  endif
endfunction

" Warning: 0 uses ^ first, then 0
nnoremap <silent> 0 :call ToggleMovement('^', '0', 0)<CR>
vnoremap <silent> 0 :call ToggleMovement('^', '0', 1)<CR>
nnoremap <silent> ^ :call ToggleMovement('0', '^', 0)<CR>
" nnoremap <silent> $ :call ToggleMovement('$', '^', 0)<CR>
" }}}

" jump to next / prev function block from :h section
" map [[ ?{<CR>w99[{
" map ][ /}<CR>b99]}
" map ]] j0[[%/{<CR>
" map [] k$][%?}<CR>
" improved from https://vim.fandom.com/wiki/Jumping_to_the_start_and_end_of_a_code_block
map <silent> [[ :eval search('{', 'b')<CR>w99[{
map <silent> ][ :eval search('}')<CR>b99]}
map <silent> ]] j0[[%:silent! eval search('{')<CR>
map <silent> [] k$][%:silent! eval search('}', 'b')<CR>

" nnoremap <silent> <leader><leader>o :only<CR> " ===> USE <C-w>o builtin
nnoremap <silent> <leader><leader>r :registers<CR>
map <leader>bd :bd<CR>
" nmap <F4> :bd<CR>
" imap <F4> <esc>:bd<CR>
map <leader>bD :bw!<CR>
map <leader>bw :bw<CR>
map <leader>bW :bw!<CR>
map <leader>kn :enew<CR>

map <leader>tw :tabclose!<CR>
map <leader>tc :tabclose<CR>
map <leader>tq :tabclose<CR>

" comment
augroup comment
  autocmd!
  autocmd FileType json setlocal commentstring=//\ %s
  autocmd FileType typescriptreact setlocal commentstring=//\ %s
  autocmd FileType sql setlocal commentstring=--\ %s
  autocmd FileType proto setlocal commentstring=//\ %s
augroup end

" cnoremap <C-a> <Home>
" cnoremap <C-e> <End>
" cnoremap <C-p> <Up>
" cnoremap <C-n> <Down>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

" let g:markTimer = 0
" function s:markCursor(timer)
"   if g:markTimer != 0
"     call timer_stop(g:markTimer)
"   endif
"   let g:markTimer = a:timer
"   if mode() ==# 'n'
"     execute "normal! m'"
"   endif
" endfunction
" autocmd CursorHold * call timer_start(5000, funcref('s:markCursor'))
command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
" }}}

" plugins {{{
call plug#begin('~/.config/nvim/plugged')
" Make sure you use single quotes
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
" MixedCase (crm), camelCase (crc), snake_case (crs), UPPER_CASE (cru),
" dash-case (cr-), dot.case (cr.), space case (cr<space>), and Title Case (crt)
Plug 'tpope/vim-abolish'
" Plug 'tpope/vim-commentary'
Plug 'numToStr/Comment.nvim'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-dotenv'

" keep this on the top so that other plugins can use it
Plug 'kyazdani42/nvim-web-devicons' " for file icons

" Plug 'vim-scripts/argtextobj.vim' " `aa` for an argument, `ia` for inside argument
Plug 'tommcdo/vim-exchange'      " cx{motion} to swap word, cxc to clear
" Plug 'kana/vim-textobj-user' " user defined text object
" Plug 'fvictorio/vim-textobj-backticks'
" Plug 'glts/vim-textobj-comment' " ic for inside comment
Plug 'will133/vim-dirdiff' " diff directories

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align' " gaip align paragraph
" Plug 'junegunn/vim-peekaboo' " enhanced register & micro
" Plug 'fatih/vim-go' ", { 'tag': 'v1.19' }   { 'tag': 'v1.20' }
Plug 'jackielii/vim-gomod' " gomod only
" Plug 'chriskempson/base16-vim' " use base16_??? to switch theme
Plug 'RRethy/nvim-base16' " same as above, but better with treesitter

" word motion: camelCase, snake_case etc. This should be after vim-sneak
" because we're mapping , as leader for word motion
Plug 'chaoren/vim-wordmotion'
Plug 'christoomey/vim-tmux-navigator'

Plug 'itchyny/lightline.vim'
Plug 'jackielii/nvim-base16-lightline'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'josa42/vim-lightline-coc'
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-scripts/BufOnly.vim'
"Plug 'terryma/vim-multiple-cursors'
"" ysiw to insert cs"' to change
Plug 'tpope/vim-surround'
" Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
" Plug 'airblade/vim-rooter'
Plug 'tpope/vim-sleuth' " auto detect indent
" Plug 'triglav/vim-visual-increment' " increment a block
" Plug 'roxma/vim-tmux-clipboard'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb' " Gbrowse for github
Plug 'shumphrey/fugitive-gitlab.vim' " Gbrowse for gitlab
Plug 'Shougo/echodoc.vim'
" Plug 'majutsushi/tagbar'
" Plug 'bkad/CamelCaseMotion'
" Plug 'scrooloose/nerdtree'
" Plug 'scrooloose/nerdcommenter'
"Plug 'jiangmiao/auto-pairs'

" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'neoclide/coc.nvim', {'tag': 'v0.0.77'}
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
" Plug '~/personal/coc.nvim'

"Plug 'w0rp/ale'
"Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"Plug 'blueyed/vim-diminactive'
Plug 'szw/vim-maximizer'
Plug 'HerringtonDarkholme/yats.vim' " typescript language support
"Plug 'Shougo/denite.nvim', {'tag': '*'}
"Plug 'Shougo/neomru.vim'
"Plug 'raghur/fruzzy', {'do': { -> fruzzy#install()}}
Plug 'godlygeek/tabular' " from vimcast: http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
Plug 'preservim/vim-markdown'
Plug 'mg979/vim-visual-multi'
"Plug 'sebdah/vim-delve'
" Plug 'wellle/tmux-complete.vim' " add tmux buffer to completioin list
Plug 'mbbill/undotree'
Plug 'udalov/kotlin-vim'
"Plug '~/nvim/proto'
" Plug 'uber/prototool', { 'rtp':'vim/prototool' }
" Plug 'mattn/webapi-vim'
" Plug 'mattn/vim-gist'
" Plug 'vimwiki/vimwiki'
Plug 'mattn/emmet-vim'
Plug 'lervag/wiki.vim'
" Plug 'lervag/wiki-ft.vim' " wiki file type
Plug 'lervag/lists.vim' " for toggle todo list item

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
Plug 'cespare/vim-toml'

" Intellij completion
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'beeender/Comrade'
Plug 'tyru/open-browser.vim'
Plug 'dart-lang/dart-vim-plugin'

" tasks
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim' " dependency for asynctasks

" Plug 'kyazdani42/nvim-tree.lua'

" treesitter related
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'

" many text objects
Plug 'wellle/targets.vim'
Plug 'mhinz/vim-startify'
Plug 'cespare/vim-toml'
Plug 'github/copilot.vim'
Plug 'lukas-reineke/indent-blankline.nvim'

" octo.nvim
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
"" Plug 'kyazdani42/nvim-web-devicons' " already included above
"Plug 'pwntester/octo.nvim'
Plug 'nvim-telescope/telescope-dap.nvim'

Plug 'voldikss/vim-floaterm' " floating terminal within neovim
Plug 'sindrets/diffview.nvim' " quite nice diffview, :DiffViewFileHistory

Plug 'mfussenegger/nvim-dap' " debug framework
" Plug 'leoluz/nvim-dap-go' " Dap UI for Go
Plug 'rcarriga/nvim-dap-ui' " Dap widgets
" Plug 'theHamsta/nvim-dap-virtual-text'

Plug 'neoclide/jsonc.vim' " jsonc for config file types

Plug 'lbrayner/vim-rzip' " view zip file content
Plug 'jjo/vim-cue' " cue syntax
Plug 'ntpeters/vim-better-whitespace' " highlight trailing whitespace

Plug '~/personal/coc-java' " coc-java dev
Plug '~/personal/coc-java-ext' " coc-java dev
" Plug 'jackielii/coc-lists', {'do': 'yarn'}
" Plug '~/personal/coc-lists' " coc-java dev
call plug#end()
" }}}

" {{{ color scheme and highlight

" transparent background
" au ColorScheme * hi Normal ctermbg=none guibg=none
" more recognisable matching brackets
au ColorScheme * hi MatchParen gui=italic guibg=black guifg=NONE
au ColorScheme * hi WinSeparator guibg=none
au ColorScheme * hi Comment gui=italic

set pumblend=15 " transparency for popup

function! SynStack ()
    for i1 in synstack(line("."), col("."))
        let i2 = synIDtrans(i1)
        let n1 = synIDattr(i1, "name")
        let n2 = synIDattr(i2, "name")
        echo n1 "->" n2
    endfor
endfunction
map <leader>kss :call SynStack()<CR>

" highlight trailing spaces -- using vim-better-whitespace stead
" autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
" match ExtraWhitespace /\s\+$/
" autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
" autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
" autocmd InsertLeave * match ExtraWhitespace /\s\+$/
" autocmd BufWinLeave * call clearmatches()

" more familiar highlights in treesitter {{{
nnoremap <F10> :TSHighlightCapturesUnderCursor<CR>
autocmd ColorScheme * highlight! link TSNamespace Normal
autocmd ColorScheme * highlight! link TSVariable Normal
autocmd ColorScheme * highlight! link TSParameterReference Identifier
"}}}

" ~/.vimrc_background will be updated by base16-shell profile helper:
" https://github.com/chriskempson/base16-shell/blob/master/README.md#base16-vim-users
if exists('$BASE16_THEME')
      \ && (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
    let base16colorspace=256
    colorscheme base16-$BASE16_THEME
endif

au ColorScheme * call UpdateLightlineBase16()
" Sync color wihout restarting vim
function! Base16Sync()
  " theme would be symlinked to ~/.base16_theme
  let l:theme_path = trim(system('readlink -f ~/.base16_theme'))
  let l:theme = fnamemodify(l:theme_path, ":t:r")[7:]
  if len(l:theme) == 0 | return | endif
  let l:fzf = trim(system('source ~/.config/base16-fzf/bash/base16-'..l:theme..'.config && echo $FZF_DEFAULT_OPTS'))
  let $FZF_DEFAULT_OPTS = l:fzf
  exec 'colorscheme base16-' .. l:theme
endfunction

" }}}

" python{{{
let g:python3_host_prog = $HOME .. '/.pyenv/versions/3.11.2/bin/python3'
set pyxversion=3
"}}}

" undotree {{{
set shada='1000 " 1000 files in history
nnoremap <silent> <F12> <esc>:UndotreeToggle <bar> :UndotreeFocus<CR>
inoremap <silent> <F12> <esc>:UndotreeToggle <bar> :UndotreeFocus<CR>
if has("persistent_undo")
    set undodir=$HOME/.undodir
    set undofile
endif

set directory=/tmp
" }}}

" sleuth {{{
" let g:sleuth_heuristics = 0
let g:sleuth_editorconfig_overrides = {
    \ expand('$HOMEBREW_PREFIX/.editorconfig'): '',
    \ }
" }}}

" vim-markdown{{{
" let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_folding_disabled = 1
"}}}

" open-browser {{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
function! s:open_browser(mode) abort
    call assert_true(a:mode ==# 'char')
    execute 'normal! `[v`]"xy'
    let new_value = getreg('x')
    call openbrowser#smart_search(new_value)
endfunction
nnoremap <silent> gX :<C-U>set opfunc=<SID>open_browser<CR>g@
" }}}

" bufOnly{{{
map <leader>bo :BufOnly<CR>
nnoremap <silent> <leader><leader>o :BufOnly<CR>
"}}}

" fugitive git related {{{
nmap <leader>g :Git<space>
nmap <leader>g<CR> :tab Git<CR>
nmap <leader>ge :Gedit<CR>
nmap <leader>gb :Git blame<CR>
nmap <leader>gc :Git commit<CR>
nmap <leader>gds :tab Git diff --staged<CR>
nmap <leader>gda :tab Git diff<CR>
nmap <leader>gdd :tab Git diff %<CR>
nmap <leader>gp :Git pull<CR>
nmap <leader>gP :Git push<CR>
nmap <leader>gll :tabnew % <bar> 0Gclog<CR>
vmap <leader>gll :tabnew % <bar> Gclog<CR>
nmap <leader>gla :tabnew % <bar> Git log<CR>
nmap <leader>ga :Git add --all<CR>
" }}}

" Rooter: auto root vim rooter{{{
" let g:rooter_patterns = ['prototool.yaml', 'Rakefile', '.git/']
" let g:rooter_manual_only = 1
"}}}

" vim easy align{{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
nmap <bar><bar> :TableFormat<CR>
" auto indent for tables
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
"}}}

" {{{ fzf
let g:fzf_buffers_jump = 1
map <silent> <leader>zf :execute 'Files '.expand('%:p:h')<CR>
" https://github.com/junegunn/fzf.vim/issues/226#issuecomment-1116143932
" command! -bang -nargs=? -complete=dir HFiles
"   \ call fzf#vim#files(<q-args>, {'source': 'find . \( -not -path "./.git/*" ' .
"     \   '-and \( -path "./.*" -or -path "./.*/**" \) ' .
"     \   '-and \( -type f -or -type l \) ' .
"     \ '\) -print | sed "s:^..::"'}, <bang>0)
command! -bang -nargs=? -complete=dir HFiles
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'fd -t f -uu -L -E .git -E node_modules'}), <bang>0)
command! -bang -nargs=? -complete=dir AFiles
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'fd -t f -uu -L -E .git'}), <bang>0)
map <leader>zh :HFiles<CR>
map <leader>za :AFiles<CR>

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-s': 'split' }
let g:fzf_preview_window = ['right:50%:hidden', 'ctrl-/']

" let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
" let g:fzf_layout = { 'window': 'enew' }
" let g:fzf_layout = { 'window': '-tabnew' }
" let g:fzf_layout = { 'window': '10new' }

" nnoremap <silent> <C-p> :call fzf#vim#files('.', {'options': '--prompt ""'})<CR>
function s:isCocList()
  " echomsg 'buflisted ' . &buflisted
  " echomsg 'filetype ' . &filetype
  " echomsg 'buftype ' . &buftype
  return !&buflisted && (&filetype == 'list' || &filetype == 'coctree')
endfunction

nnoremap <silent><expr> <C-p> <SID>isCocList() ? "\<C-p>" : ':Files<CR>'

let $FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
let $FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS.' --layout=reverse'
" let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" let g:fzf_layout = { 'window': 'call FloatingFZF()' }
" select filetype
nmap <leader>km :Filetypes<CR>
nmap <leader>kl :Lines<CR>
nmap <leader>kh :Helptags<CR>
nmap <leader>k' :Marks<CR>
nmap <leader>k<space> :Maps<CR>
nmap <leader>k: :History:<CR>
nmap <leader>k/ :History/<CR>

" <leader>o to open recent files
nmap <silent><leader>o :History<CR>
nmap <silent> <leader>e :Buffers<CR>
" map <M-o> :History<CR>
" map <leader>bl :Buffers<CR>
" map <leader><leader>l :Buffers<CR>
" map <leader>l :Buffers<CR>
" map <leader>ll :Buffers<CR>
" noremap <M-l> :Buffers<CR>

" }}}

" {{{ go related binding
" au FileType go nmap <buffer> <leader>gb <Plug>(go-build)
" "au FileType go nmap <buffer> <leader>ds :GoDecls<CR>
" "au FileType go nmap <buffer> <leader>r :GoDecls<CR>
" au FileType go nmap <buffer> <leader>dl :GoDeclsDir<CR>
" au FileType go nmap <buffer> gh :GoDoc<CR>
" "au FileType go nmap <buffer> <silent> <leader>gg :GoInfo<CR>
" au FileType go nmap <buffer> <leader>dl :GoDeclsDir<CR>
" let g:go_highlight_types = 1
augroup GoRelated
  autocmd!
  autocmd FileType go let b:coc_pairs_disabled = ['<']
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
  " autocmd BufNewFile,BufRead go.mod set filetype=gomod
  " autocmd FileType go let b:coc_root_patterns = ['.git', 'go.mod']
  " autocmd BufNewFile,BufRead go.mod set syntax=gomod
  autocmd BufReadPost,BufWritePre *.go call <SID>SetMark("import (\\_.\\{-})", "i") "http://vimregex.com/#Non-Greedy
  " autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
augroup END
nmap <leader>kgr :CocCommand go.gopls.tidy<CR>
nmap <leader>kgt :CocCommand go.gopls.runTests<CR>
nmap <leader>kgl :CocCommand go.gopls.listKnownPackages<CR>

let g:go_highlight_build_constraints = 1
" let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
" let g:go_highlight_function_parameters = 1
" let g:go_highlight_fields = 1
" let g:go_highlight_types = 1

" let g:go_def_mode = 'godef'
let g:go_gopls_enabled = 0
let g:go_code_completion_enabled = 0
let g:go_auto_sameids = 0
let g:go_fmt_autosave = 0
let g:go_def_mapping_enabled = 0
let g:go_diagnostics_enabled = 0
" let g:go_fmt_command = 'gofmt'
" let g:go_test_timeout = '30s'
" let g:go_fmt_fail_silently = 1
let g:go_echo_go_info = 0
let g:go_metalinter_enabled = 0
" au FileType go let b:ale_enabled = 0
"au FileType go map <F9> :DlvToggleBreakpoint<CR>
"au FileType go nmap <buffer> <leader>gi :GoImports<CR>
" auto format on save
" autocmd BufWritePre *.go :call CocAction('runCommand', 'editor.action.format')
" }}}

" proto format{{{
" au FileType proto nnoremap <buffer> <leader>gfa :execute '!prototool format -w %' <bar> edit<CR>
function s:delayedRefresh() abort
  call timer_start(500, { tid -> execute("edit")})
endfunction
au! FileType proto nnoremap <buffer> <leader>gff :execute 'AsyncTask buf-format' <bar> call<SID>delayedRefresh()<CR>
au! FileType proto nnoremap <buffer> <leader>kf :execute 'AsyncTask buf-format' <bar> call<SID>delayedRefresh()<CR>
" au FileType proto nnoremap <buffer> <leader>gff :call PrototoolFormatFix()<CR>
"}}}

" sneak{{{
let g:sneak#use_ic_scs = 1
let g:sneak#label = 1
let g:sneak#s_next = 1
nmap S <Plug>Sneak_S
"}}}

" echodoc{{{
let g:echodoc_enable_at_startup = 1
let g:echodoc#type = 'signature'
" let g:echodoc#type = 'virtual'
" let g:echodoc#highlight_identifier = 1
"}}}

" vim-maximizer{{{
nnoremap <silent><C-w>z :MaximizerToggle<CR>
vnoremap <silent><C-w>z :MaximizerToggle<CR>gv
let g:maximizer_restore_on_winleave = 1
let g:maximizer_set_default_mapping = 0
"inoremap <silent><C-w>z <C-o>:MaximizerToggle<CR>
"}}}

" vim-visual-multi {{{
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<A-n>'
let g:VM_maps['Find Subword Under'] = '<A-n>'
" let g:VM_maps['I CtrlD'] = ''
" <CR> to accept completion item
" autocmd User visual_multi_mappings  imap <buffer><expr> <CR> pumvisible() ? "\<C-Y>" : "\<Plug>(VM-I-Return)"
let g:VM_theme = 'ocean'

function! MyVmStart()
endfunction
function! MyVmExit()
endfunction
autocmd User visual_multi_start   call MyVmStart()
autocmd User visual_multi_exit    call MyVmExit()
" }}}

" vim.wiki {{{
" let g:vimwiki_list = [{'path': '~/notes/', 'syntax': 'markdown', 'ext': '.md'}]

" wiki.vim: https://github.com/lervag/wiki.vim
let g:wiki_map_text_to_link = 'WikiNewLinkFileName'
function WikiNewLinkFileName(text) abort
  return [substitute(tolower(a:text), '\s\+', '-', 'g'), a:text]
endfunction
let g:wiki_root = '~/personal/notes'
let g:wiki_mappings_use_defaults = 'none'
let g:wiki_filetypes = ['md']
let g:wiki_link_target_type = 'md'
let g:wiki_link_extension = '.md'
nmap <leader>kp :WikiFzfPages<CR>
let g:wiki_mappings_local = {
      \ '<plug>(wiki-link-next)' : ']w',
      \ '<plug>(wiki-link-prev)' : '[w',
      \ '<plug>(wiki-link-follow)' : '<C-]>',
      \ '<plug>(wiki-link-toggle-operator)' : 'gl',
      \ 'x_<plug>(wiki-link-toggle-visual)' : '<cr>'
      \}

function s:ToggleList() abort
  if !exists(g:loaded_lists)
    execute 'ListsEnable'
  endif
  execute 'ListsToggle'
endfunction

augroup MarkdownRelated
  au!
  au FileType markdown nnoremap <C-t> :call <SID>ToggleList()<CR>
  au FileType markdown set tw=79
augroup END

" }}}

" spec file related{{{
augroup spec
  au!
  autocmd BufNewFile,BufRead *.ttrigger set syntax=sql
  autocmd BufNewFile,BufRead *.tview set syntax=sql
augroup END
"}}}

" set Mark{{{
function! s:SetMark(pattern, m)
  " echom a:pattern a:m
  " execute '$?'.a:pattern.'?mark '.a:m
  let save_pos = getpos(".")
  call setpos('.', [0, 0, 0, 0]) " always starts from the beginning of the file
  let ln = search(a:pattern, 'benw') " search last import statement
  " echom 'found import '.ln
  call setpos("'".a:m, [0, ln, 0, 0]) " set 'i to the line of import stmt
  call setpos(".", save_pos) " restore position
endfunction

augroup typescript
  au!
  autocmd BufReadPost,BufWritePost *.js,*.jsx,*.ts,*.tsx call <SID>SetMark("^import ", "i")
augroup END
"}}}

" chaoren/vim-wordmotion{{{
let g:wordmotion_prefix = ','
nnoremap ,, ,
nnoremap , <Nop>
"}}}

" asynctask{{{
let g:asynctasks_config_name = '.vim/tasks.ini'
let g:asyncrun_open = 6
"}}}

" nvim-tree.lua {{{ using coc-explorer now
au! VimEnter * let g:project_path = getcwd(-1,-1)
" see luainit.lua:96
" let g:coc_explorer_cmd = 'CocCommand explorer --quit-on-open --sources file+'
let g:coc_explorer_cmd = 'CocCommand explorer'
" nmap <silent> <leader>kb :lua NvimTreeOpenProject()<CR>
nmap <silent> <leader>F :execute g:coc_explorer_cmd.' '.g:project_path<CR>
" nmap <silent> <leader>f :NvimTreeFindFile<CR>
" nmap <silent> <leader>f :lua NvimTreeFindFileAnywhere()<CR>
nmap <silent> <leader>f :execute g:coc_explorer_cmd<CR>

" git deleted highlight override
hi! link CocExplorerGitDeleted CocExplorerGitContentChange
" }}}

" dap config{{{
" F1 > cd g:project_path S-F1: cd buff_path
" F2 > lazygit S-F2: floatterm
" F3 > cd $(buffer path)
" F4 > CloseNonProjectBuffers
" F5 > AsyncTask run_last
" F6 > Paste mode
" F7 > Clear floats / dap.discontinue()
" F8 > dap run configurations
" F9 > dap run_last
" F10 > debug step over
" F11 > debug step into
" F12 > debug step out
nmap <F1> :execute 'lcd '.g:project_path <bar> echo g:project_path<CR>
" on mac, <C-v>F1 produces <F13>, on Linux it produces <S-F1>
map <S-F1> <F13>
map <S-F11> <F35> " step out
nmap <F13> :execute 'lcd '.expand('%:p:h') <bar> echo expand('%:p:h')<CR>
nmap <F2> :Files<CR>
nmap <F3> :execute 'lcd '.expand('%:p:h') <bar> echo expand('%:p:h')<CR>
nmap <F8> :Telescope dap configurations<CR>

nnoremap <leader>bb :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <leader>bB :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <leader>bp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
" nnoremap <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <F9> :lua require'dap'.run_last()<CR>
nnoremap <leader>dd :lua require'dapui'.toggle({ reset = true })<CR>
" }}}

"}}}

" targets.vim{{{
" to have argument object work in {} & []
autocmd User targets#mappings#user call targets#mappings#extend({
      \ 'a': {'argument': [{'o': '[{([]', 'c': '[])}]', 's': ','}]},
      \ })
" control where to seek, see https://github.com/wellle/targets.vim/blob/master/cheatsheet.md
" Only consider targets fully visible on screen:
" let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr rr ll lb ar ab lB Ar aB Ab AB rb rB al Al'

" Only consider targets around cursor:
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'
"}}}

" startify {{{
let g:startify_files_number = 5
let g:startify_lists = [
      \ { 'type': 'dir',       'header': ['   This MRU '. getcwd()] },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ ]
      " \ { 'type': 'sessions',  'header': ['   Sessions']       },
      " \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      " \ { 'type': 'commands',  'header': ['   Commands']       },
let g:startify_session_autoload = 1
" }}}

" float terminal {{{
nnoremap <silent>   <F14>    :FloatermToggle --width=0.9 --height=0.9<CR>
tnoremap <silent>   <F14>    <C-\><C-n>:FloatermToggle<CR>
inoremap <silent>   <F14>    <esc><C-\><C-n>:FloatermToggle<CR>
nmap     <F2> :FloatermNew --width=0.9 --height=0.9 --title=lazygit lazygit<CR>
imap     <F2> <esc>:FloatermNew --width=0.9 --height=0.9 --title=lazygit lazygit<CR>
let g:floaterm_width=0.8
let g:floaterm_height=0.9
let g:floaterm_title='Terminal'
" }}}

" close all non project buffers {{{
command! -nargs=? -complete=dir -bang CloseNonProjectBuffers
    \ :call CloseNonProjectBuffers('<args>', '<bang>')
function! CloseNonProjectBuffers(dir, bang)
  if a:dir == ''
    if g:project_path != ''
      let dir = g:project_path
    else
      let dir = getcwd(-1,-1)
    endif
  else
    let dir = a:dir
  endif
  let last_buffer = bufnr('$')
  let n = 1
  while n <= last_buffer
    if buflisted(n)
      let p = expand('#' .. n .. ':p:h')
      let in_proj = p[0:len(dir)-1] ==# dir
            \ && stridx(p, "/node_modules/") < 0 " exclude node_modules as well
      " echo n .. '; ' .. p .. '; ' .. in_proj
      if !in_proj
        if a:bang == '' && getbufvar(n, '&modified')
          echohl ErrorMsg
          echomsg 'No write since last change for buffer'
                \ n '(add ! to override)'
          echohl None
        else
          silent exe 'bwipeout' . ' ' . n
        endif
      endif
    endif
    let n = n+1
  endwhile
endfunction

map <F4> :CloseNonProjectBuffers<CR>
map <leader><leader>p :CloseNonProjectBuffers<CR>
" }}}

" coc.nvim {{{
let g:coc_node_path = $HOMEBREW_PREFIX .. '/bin/node'
let g:coc_node_args = ['--max-old-space-size=8192']

let g:coc_global_extensions = [
  \ "coc-css",
  \ "coc-diagnostic",
  \ "coc-dictionary",
  \ "coc-docker",
  \ "coc-eslint",
  \ "coc-explorer",
  \ "coc-floaterm",
  \ "coc-flutter",
  \ "coc-git",
  \ "coc-go",
  \ "coc-highlight",
  \ "coc-html",
  \ "coc-json",
  \ "coc-marketplace",
  \ "coc-pairs",
  \ "coc-prettier",
  \ "coc-pyright",
  \ "coc-react-refactor",
  \ "coc-rust-analyzer",
  \ "coc-snippets",
  \ "coc-spell-checker",
  \ "coc-sql",
  \ "coc-sumneko-lua",
  \ "coc-svelte",
  \ "coc-syntax",
  \ "coc-tag",
  \ "coc-tasks",
  \ "coc-tsserver",
  \ "coc-vimlsp",
  \ "coc-webpack",
  \ "coc-word",
  \ "coc-yaml",
  \ "coc-yank",
  \ "coc-prisma",
  \ "coc-deno",
  \ "coc-xml",
  \ "coc-emmet",
  \ "coc-lists",
  \ "coc-flow",
  \ ]


" """"https://github.com/neoclide/coc.nvim/wiki/Debug-coc.nvim
" " let g:node_client_debug = 1
" let g:coc_node_args = ['--nolazy', '--inspect=6045', '-r', expand('~/.config/yarn/global/node_modules/source-map-support/register')]
" """"

" enable semantic highlight
" g:coc_default_semantic_highlight_groups = 1

" autocmd FileType json syntax match Comment +\/\/.\+$+

" always show signcolumns
"set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" inoremap <silent><expr> <TAB>
"       \ coc#pum#visible() ? coc#pum#next(1) :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" jsonc files
" autocmd BufNewFile,BufRead .prettierrc.json setlocal filetype=jsonc
autocmd BufNewFile,BufRead .eslintrc.json setlocal filetype=jsonc

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" makes <CR> only break line, use <C-y> to confirm
" CocConfig: suggest.noselect: false
" inoremap <silent><expr> <cr> "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

vmap <C-l> <Plug>(coc-snippets-select)
imap <C-l> <Plug>(coc-snippets-expand)

" Use `[d` and `]d` for navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

nmap <leader>kk :call CocAction('diagnosticPreview')<CR>

" next or previous git chunk
nmap <silent> [c <Plug>(coc-git-prevchunk)
nmap <silent> ]c <Plug>(coc-git-nextchunk)

" create text object for git chunks
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')
" highlight CocHighlightText guifg=#edffe4 guibg=#0e2d2e

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>gf  <Plug>(coc-format-selected)
nmap <leader>gf  <Plug>(coc-format-selected)
nmap <leader>gff  :call CocAction('format')<CR>
nmap <leader>kf  :call CocAction('format')<CR>

augroup CocRelated
  autocmd!
  " Setup formatexpr specified filetype(s).
  " autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" imap <silent> <C-K> <C-\><C-O>:call CocActionAsync('showSignatureHelp')<CR>
inoremap <silent> <M-i> <C-\><C-O>:call CocActionAsync('showSignatureHelp')<CR>

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction-line)
nmap <leader>ag  <Plug>(coc-codeaction-source)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

nmap <C-w>f :call coc#float#jump()<CR>

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_float() ? coc#float#scroll(1,1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_float() ? coc#float#scroll(0,1) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_float() ? "\<c-r>=coc#float#scroll(1,1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_float() ? "\<c-r>=coc#float#scroll(0,1)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_float() ? coc#float#scroll(1,1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_float() ? coc#float#scroll(0,1) : "\<C-b>"
endif

" " Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" nmap <silent> <C-d> <Plug>(coc-range-select)
" xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

command! -nargs=+ -complete=custom,s:GrepArgs CocGrep exe 'CocList grep '.<q-args>
function! s:GrepArgs(...)
  let list = ['-S', '-smartcase', '-i', '-ignorecase', '-w', '-word',
        \ '-e', '-regex', '-u', '-skip-vcs-ignores', '-t', '-extension']
  return join(list, "\n")
endfunction

function! s:GrepLiteral(folder)
  let text = input(empty(a:folder) ? 'search: ' : 'search '.a:folder.': ')
  let text = escape(text, ' ')
  if empty(text) | return | endif
  execute 'CocList --auto-preview grep -S '.text.(empty(a:folder) ? '' : ' -- '.a:folder)
endfunction
nmap <leader>/ :<C-u>call <SID>GrepLiteral("")<CR>
nmap <leader>? :<C-u>call <SID>GrepLiteral(expand("%:h"))<CR>
nmap <leader>cs :CocSearch<space>
nmap <leader>ci :CocList grep<CR>
nmap <leader>cg :CocGrep<space>

" Using CocList
" Show all diagnostics
nnoremap <silent> <leader>ds :<C-u>CocList outline<CR>
nnoremap <silent> <leader>da :<C-u>CocList diagnostics<cr>
nnoremap <silent> <leader>dl :<C-u>CocList symbols<CR>
" nnoremap <silent> <leader>dr :<C-u>CocListResume<CR>

" Manage extensions
nnoremap <silent> <leader>ce  :<C-u>CocList extensions<cr>
nnoremap <silent> <leader>cm  :<C-u>CocList marketplace<cr>
" Show commands
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
nnoremap <silent> <leader>cl  :<C-u>CocList<cr>
nnoremap <silent> <leader>co  :CocCommand workspace.showOutput<cr>
" Do default action for next item.
" nnoremap <silent> <leader>gj  :<C-u>CocNext<CR>
nnoremap <silent> ]g  :<C-u>CocNext<CR>
" Do default action for previous item.
" nnoremap <silent> <leader>gk  :<C-u>CocPrev<CR>
nnoremap <silent> [g  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <leader>cr  :<C-u>CocListResume<CR>
nnoremap <silent> <leader>p  :<C-u>CocListResume<CR>
nnoremap <silent> <leader>ct  :<C-u>CocList tasks<cr>

nnoremap <leader>gi :call CocAction('runCommand', 'editor.action.organizeImport')<CR>

"nnoremap <silent> <leader>y  :<C-u>CocList -A --normal yank<cr>

" hi CocCursorRange guibg=#b16286 guifg=#ebdbb2
" nmap <silent> <F3> <Plug>(coc-cursors-position)
" nmap <silent> <leader>\ <Plug>(coc-cursors-position)
" nmap <silent> <C-d> <Plug>(coc-cursors-word)*
" xmap <silent> <C-d> y/\V<C-r>=escape(@",'/\')<CR><CR>gN<Plug>(coc-cursors-range)gn
" use normal command like `<leader>xi(`
" nmap <leader>x  <Plug>(coc-cursors-operator)
nmap <leader>rf <Plug>(coc-refactor)

" Remap keys for apply refactor code actions.
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

nmap <leader>rl  <Plug>(coc-codelens-action)

" coc list grep by motion
vnoremap <leader>dg :<C-u>call <SID>GrepFromSelected(visualmode())<CR>
nnoremap <leader>dg :<C-u>set operatorfunc=<SID>GrepFromSelected<CR>g@

function! s:GrepFromSelected(type)
  let saved_unnamed_register = @@
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif
  let word = substitute(@@, '\n$', '', 'g')
  let word = escape(word, '| ')
  let @@ = saved_unnamed_register
  execute 'CocList grep '.word
endfunction

augroup COC_GO
  au!
  autocmd FileType go nmap <buffer> <C-^> :CocCommand go.test.toggle<CR>
augroup end

" nmap <leader>cfj <Plug>(coc-float-jump)
" nmap <leader>cfh <Plug>(coc-float-hide)
nmap <silent><F7> <Plug>(coc-float-hide):nohl<CR> " <bar> CocCommand git.refresh<CR>
" imap <silent><F7> <esc><Plug>(coc-float-hide):nohl<CR>a
imap <silent><F7> <C-\><C-O>:execute "normal \<Plug>(coc-float-hide)"<CR>
nmap <leader>ki :CocCommand git.chunkInfo<CR>
nmap <leader>ku :CocCommand git.chunkUndo<CR>
nmap <F5> :CocCommand tasks.runLastTask<CR>
imap <F5> <C-\><C-O>:CocCommand tasks.runLastTask<CR>

nnoremap <silent> ]n :CocCommand document.jumpToNextSymbol<CR>
nnoremap <silent> [n :CocCommand document.jumpToPrevSymbol<CR>

map <leader>ko :CocOutline<CR>
map <leader>ho :call CocAction('showOutgoingCalls')<CR>
map <leader>hi :call CocAction('showIncomingCalls')<CR>

map <leader>y :<C-u>CocList -A --normal yank<cr>
vmap <leader>y :<C-u>CocList -A --normal yank<cr>
" show outline
" autocmd VimEnter,Tabnew *
"     \ if empty(&buftype) | call CocActionAsync('showOutline', 1) | endif

imap <expr><silent> <C-e> coc#pum#cancel()
let g:coc_snippet_next = '<Plug>coc-snippet-next'
let g:coc_snippet_prev = '<Plug>coc-snippet-prev'
imap <expr><silent> <C-j> coc#pum#visible() ? coc#pum#next(0) : coc#jumpable() ? '<Plug>coc-snippet-next' : coc#refresh()
imap <expr><silent> <C-k> coc#pum#visible() ? coc#pum#prev(0) : coc#jumpable() ? '<Plug>coc-snippet-prev' : CocActionAsync('showSignatureHelp')
smap <expr><silent> <C-j> '<Plug>coc-snippet-next'
smap <expr><silent> <C-k> '<Plug>coc-snippet-prev'
cnoremap <C-j> <C-n>
cnoremap <C-k> <C-p>

" env dependent coc config
call coc#config("python.formatting.blackPath", $HOMEBREW_PREFIX . "/bin/black")

" }}}

" {{{ tmux-navigator
let g:tmux_navigator_disable_when_zoomed = 1
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent><expr> <c-j> <SID>isCocList() ? "\<C-n>" : ":TmuxNavigateDown<cr>"
nnoremap <silent><expr> <c-k> <SID>isCocList() ? "\<C-p>" : ":TmuxNavigateUp<cr>"
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
" let g:tmux_navigator_preserve_zoom = 1
" }}}

" Copilot{{{
imap <silent><script><expr> <C-e> coc#pum#visible() ? coc#pum#cancel() : copilot#Accept("\<C-e>")
" imap <silent><script><expr> <C-j> copilot#Accept("\<C-j>")
let g:copilot_no_tab_map = v:true
" let g:copilot_node_command = "$HOMEBREW_PREFIX/Cellar/node@16/16.16.0/bin/node"
"}}}

" Special keycodes see also kitty.conf {{{
" nmap <C-M-k> :call CocAction('diagnosticPreview')<CR>
nmap <C-M-k> <Plug>(coc-diagnostic-info)
" }}}

runtime luainit.lua
runtime lightline.vim

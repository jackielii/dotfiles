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
set pastetoggle=<F2> " F2 toggle paste mode

syntax sync fromstart " more reliable syntax highlight

" map common mistakes
" cmap Q q
cmap Wq wq
imap jk <esc>
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


let g:netrw_fastbrowse = 0 " remove netrw after opening file
highlight WinSeparator guibg=none

" ctrl-s to save and to normal mode
noremap  <silent> <C-S> <esc>:update<CR>:nohl<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>:nohl<CR>
inoremap <silent> <C-S> <esc>:update<CR>:nohl<CR>
snoremap <silent> <C-S> <esc>:update<CR>:nohl<CR>

" disable highlight various keys
nnoremap <silent> <C-c> :nohl<CR>
inoremap <silent> <C-c> <Esc>:nohl<CR>
vnoremap <silent> <C-c> <Esc>:nohl<CR>
nnoremap <silent> <esc> :nohl<CR>
inoremap <silent> <esc> <Esc>:nohl<CR>
vnoremap <silent> <esc> <Esc>:nohl<CR>
snoremap <silent> <esc> <Esc>:nohl<CR>

" leader-tab to previous buffer
nnoremap <leader><tab> <C-^>
nnoremap <C-Q> <C-^>
inoremap <C-Q> <esc><C-^>
inoremap <C-^> <esc><C-^>

nnoremap c* :let @/ = expand("<cword>")<CR>cgn
nnoremap c# :let @/ = expand("<cword>")<CR>cgN

" visual mode put selected to search
vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>N

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
if bufwinnr(1)
  map <leader>= 6<C-W>+
  map <leader>- 6<C-W>-
  map <leader>. 6<C-W>>
  map <leader>, 6<C-W><
endif

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
nnoremap n nzzzv
nnoremap N Nzzzv
" nnoremap J mzJ`z

" break undo on common editing chars
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" populate jump list when moving too much
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : "") . 'gj'
nnoremap <expr> k (v:count > 1 ? "m'" . v:count : "") . 'gk'

" L/H to move to the next/previous capital letter
nmap <silent> L :call search('\<\u', '', line('.'))<CR>
nmap <silent> H :call search('\<\u', 'b', line('.'))<CR>
nmap <leader><leader>x :so %<CR>

" replace without yanking
" vnoremap p "_dp
" vnoremap P "_dP

"set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
"set listchars=tab:..,trail:_,extends:>,precedes:<,nbsp:~
set listchars=tab:.→,space:·,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨

" highlight trailing spaces
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Toggle Movements {{{
" Helper function to use an alternate movement if the first
" movement doesn't move the cursor.
function! ToggleMovement(firstOp, thenOp)
  let pos = getpos('.')
  let c = v:count > 0 ? v:count : ''
  execute "normal! " . c . a:firstOp
  if pos == getpos('.')
    execute "normal! " . c . a:thenOp
  endif
endfunction

" Warning: 0 uses ^ first, then 0
nnoremap <silent> 0 :call ToggleMovement('^', '0')<CR>
nnoremap <silent> ^ :call ToggleMovement('0', '^')<CR>
nnoremap <silent> $ :call ToggleMovement('$', '^')<CR>
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

nnoremap <silent> <leader><leader>o :only<CR>
nnoremap <silent> <leader><leader>r :registers<CR>
map <leader>bd :bd<CR>
" nmap <F4> :bd<CR>
" imap <F4> <esc>:bd<CR>
map <leader>bD :bw!<CR>
map <leader>bw :bw<CR>
map <leader>bW :bw!<CR>
map <leader>kn :enew<CR>

" comment
augroup comment
  autocmd!
  autocmd FileType json setlocal commentstring=//\ %s
  autocmd FileType typescriptreact setlocal commentstring=//\ %s
  autocmd FileType sql setlocal commentstring=--\ %s
  autocmd FileType proto setlocal commentstring=//\ %s
augroup end

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

" }}}

call plug#begin('~/.config/nvim/plugged')
runtime plugins.vim
call plug#end()

" {{{ color scheme and highlight
" transparent background
au ColorScheme * hi Normal ctermbg=none guibg=none
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
hi Comment gui=italic
" }}}

" python
let g:python3_host_prog = $HOMEBREW_PREFIX .. '/bin/python3'
set pyxversion=3

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

" vim-markdown
" let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_folding_disabled = 1

" open-browser {{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
function! s:open_browser(mode) abort
    call assert_true(a:mode ==# 'char')
    execute 'normal! `[v`]"xy'
    let l:new_value = getreg('x')
    call openbrowser#smart_search(l:new_value)
endfunction
nnoremap <silent> gX :<C-U>set opfunc=<SID>open_browser<CR>g@
" }}}

" buffer navigation
map <leader>bo :BufOnly<CR>
nnoremap <silent> <leader><leader>O :BufOnly<CR>

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
nmap <leader>gll :0Gclog<CR>
vmap <leader>gll :Gclog<CR>
nmap <leader>gla :Git log<CR>
nmap <leader>ga :Git add --all<CR>
" }}}

" auto root vim rooter
" let g:rooter_patterns = ['prototool.yaml', 'Rakefile', '.git/']
let g:rooter_manual_only = 1

" vim easy align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" {{{ fzf
let g:fzf_buffers_jump = 1
map <silent> <leader>p :Files<CR>
map <silent> <leader>zf :execute 'Files '.expand('%:p:h')<CR>
" https://github.com/junegunn/fzf.vim/issues/226#issuecomment-1116143932
" command! -bang -nargs=? -complete=dir HFiles
"   \ call fzf#vim#files(<q-args>, {'source': 'find . \( -not -path "./.git/*" ' .
"     \   '-and \( -path "./.*" -or -path "./.*/**" \) ' .
"     \   '-and \( -type f -or -type l \) ' .
"     \ '\) -print | sed "s:^..::"'}, <bang>0)
command! -bang -nargs=? -complete=dir HFiles
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'fd -t f -uu -L -E .git -E node_modules'}), <bang>0)
map <leader>zh :HFiles<CR>

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
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
  " autocmd BufNewFile,BufRead go.mod set filetype=gomod
  autocmd FileType go let b:coc_root_patterns = ['.git', 'go.mod']
  " autocmd BufNewFile,BufRead go.mod set syntax=gomod
  autocmd BufReadPost,BufWritePre *.go call <SID>SetMark("import (\\_.\\{-})", "i") "http://vimregex.com/#Non-Greedy
  autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
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

" prototool
" au FileType proto nnoremap <buffer> <leader>gfa :execute '!prototool format -w %' <bar> edit<CR>
function s:delayedRefresh() abort
  call timer_start(500, { tid -> execute("edit")})
endfunction
au! FileType proto nnoremap <buffer> <leader>gff :execute 'AsyncTask buf-format' <bar> call<SID>delayedRefresh()<CR>
au! FileType proto nnoremap <buffer> <leader>kf :execute 'AsyncTask buf-format' <bar> call<SID>delayedRefresh()<CR>
" au FileType proto nnoremap <buffer> <leader>gff :call PrototoolFormatFix()<CR>

" sneak
let g:sneak#use_ic_scs = 1
let g:sneak#label = 1
let g:sneak#s_next = 1
nmap S <Plug>Sneak_S

" tagbar
" let g:tagbar_show_linenumbers = 0
" let g:tagbar_autoshowtag = 1
" map <leader>t :TagbarOpenAutoClose<CR>
" let g:tagbar_sort = 0

" echodoc
let g:echodoc_enable_at_startup = 1
let g:echodoc#type = 'signature'
" let g:echodoc#type = 'virtual'
" let g:echodoc#highlight_identifier = 1

" CamelCaseMotion
" call camelcasemotion#CreateMotionMappings('<leader>')

" vim-maximizer
nnoremap <silent><C-w>z :MaximizerToggle<CR>
vnoremap <silent><C-w>z :MaximizerToggle<CR>gv
let g:maximizer_restore_on_winleave = 1
let g:maximizer_set_default_mapping = 0

"inoremap <silent><C-w>z <C-o>:MaximizerToggle<CR>

" vim-visual-multi {{{
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<A-n>'
let g:VM_maps['Find Subword Under'] = '<A-n>'
" <CR> to accept completion item
autocmd User visual_multi_mappings  imap <buffer><expr> <CR> pumvisible() ? "\<C-Y>" : "\<Plug>(VM-I-Return)"
let g:VM_theme = 'ocean'

" temporary work around for conflict with coc.nvim `:h vm-functions`
" https://github.com/mg979/vim-visual-multi/issues/75#issuecomment-1091401897
function! MyVmStart()
  execute 'CocDisable'
endfunction
function! MyVmExit()
  execute 'CocEnable'
endfunction
" autocmd User visual_multi_start   call MyVmStart()
" autocmd User visual_multi_exit    call MyVmExit()
" }}}

" vim.wiki {{{
" let g:vimwiki_list = [{'path': '~/notes/', 'syntax': 'markdown', 'ext': '.md'}]

" wiki.vim: https://github.com/lervag/wiki.vim
let g:wiki_root = '~/personal/notes'
let g:wiki_map_link_create = 'WikiNewLinkFileName'
let g:wiki_mappings_use_defaults = 'local'
function WikiNewLinkFileName(text) abort
  return substitute(tolower(a:text), '\s\+', '-', 'g')
endfunction
let g:wiki_filetypes = ['md']
let g:wiki_link_target_type = 'md'
let g:wiki_link_extension = '.md'
nmap <leader>kp :WikiFzfPages<CR>
let g:wiki_mappings_local = {
      \ '<plug>(wiki-link-next)' : ']w',
      \ '<plug>(wiki-link-prev)' : '[w',
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

" spec file related
augroup spec
  au!
  autocmd BufNewFile,BufRead *.ttrigger set syntax=sql
  autocmd BufNewFile,BufRead *.tview set syntax=sql
augroup END

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


" chaoren/vim-wordmotion
let g:wordmotion_prefix = ','
nnoremap ,, ,
nnoremap , <Nop>

" asynctask
let g:asynctasks_config_name = '.vim/tasks.ini'
let g:asyncrun_open = 6

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
" }}}

nmap <F8> :Rooter<CR>
nmap <F10> :execute 'lcd '.g:project_path <bar> echo g:project_path<CR>

" targets.vim
" to have argument object work in {} & []
autocmd User targets#mappings#user call targets#mappings#extend({
      \ 'a': {'argument': [{'o': '[{([]', 'c': '[])}]', 's': ','}]},
      \ })
" control where to seek, see https://github.com/wellle/targets.vim/blob/master/cheatsheet.md
" Only consider targets fully visible on screen:
" let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr rr ll lb ar ab lB Ar aB Ab AB rb rB al Al'

" Only consider targets around cursor:
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB'

" startify {{{
let g:startify_lists = [
      \ { 'type': 'dir',       'header': ['   This MRU '. getcwd()] },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

let g:startify_session_autoload = 1
" }}}

" indent blank lines
" let g:indent_blankline_filetype = ['vim']

" float terminal {{{
nnoremap <silent>   <F1>    :FloatermToggle --width=0.9 --height=0.9<CR>
tnoremap <silent>   <F1>    <C-\><C-n>:FloatermToggle<CR>
inoremap <silent>   <F1>    <esc><C-\><C-n>:FloatermToggle<CR>
nmap     <F9> :FloatermNew --width=0.9 --height=0.9 --title=lazygit lazygit<CR>
imap     <F9> <esc>:FloatermNew --width=0.9 --height=0.9 --title=lazygit lazygit<CR>
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
      " echo n .. '; ' .. p .. '; ' .. in_proj
      if !in_proj
        if a:bang == '' && getbufvar(n, '&modified')
          echohl ErrorMsg
          echomsg 'No write since last change for buffer'
                \ n '(add ! to override)'
          echohl None
        else
          silent exe 'bdel' . a:bang . ' ' . n
        endif
      endif
    endif
    let n = n+1
  endwhile
endfunction

map <F4> :CloseNonProjectBuffers<CR>
map <leader><leader>p :CloseNonProjectBuffers<CR>
" }}}

if has('macunix')
  " mac specific stuff
endif

" {{{ temporary dap mappings
nnoremap <leader>bb :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <leader>bB :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <leader>dp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <leader>dl :lua require'dap'.run_last()<CR>
" vnoremap <M-k> <Cmd>lua require("dapui").eval()<CR>
" nnoremap <M-k> <Cmd>lua require("dapui").eval(vim.fn.expand("<cword>"))<CR>

nnoremap <leader>dt :lua require'dap-go'.debug_test()<CR>
" }}}


runtime lightline.vim
runtime coc.vim
runtime scratch.vim
runtime luainit.lua

let g:coc_node_path = $HOMEBREW_PREFIX .. '/bin/node'
let g:coc_node_args = ['--max-old-space-size=8192']
" let g:node_client_debug = 1

" enable semantic highlight
" g:coc_default_semantic_highlight_groups = 1

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
"set shortmess+=cW
set shortmess=a

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

autocmd FileType json syntax match Comment +\/\/.\+$+

" always show signcolumns
"set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" makes <CR> only break line, use <C-y> to confirm
" CocConfig: suggest.noselect: false
" inoremap <silent><expr> <cr> "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

vmap <C-i> <Plug>(coc-snippets-select)
imap <C-l> <Plug>(coc-snippets-expand)
" imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use `[d` and `]d` for navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

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
highlight CocHighlightText guifg=#ffffff guibg=#170022

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

inoremap <silent> <C-K> <C-\><C-O>:call CocActionAsync('showSignatureHelp')<CR>

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
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

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1,1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0,1) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1,1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0,1)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1,1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0,1) : "\<C-b>"
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
function! s:GrepLiteral()
  let text = input('search: ')
  let text = escape(text, ' ')
  if empty(text)
    return
  endif
  execute 'CocList grep -S '.text
endfunction
nmap <leader>/ :<C-u>call <SID>GrepLiteral()<CR>
nmap <leader>cs :CocSearch<space>
nmap <leader>ci :CocList grep<CR>
nmap <leader>cg :CocGrep -regex<space>

" Using CocList
" Show all diagnostics
nnoremap <silent> <leader>ds :<C-u>CocList outline<CR>
nnoremap <silent> <leader>da :<C-u>CocList diagnostics<cr>
nnoremap <silent> <leader>dl :<C-u>CocList symbols<CR>
nnoremap <silent> <leader>dr :<C-u>CocListResume<CR>

" Manage extensions
nnoremap <silent> <leader>ce  :<C-u>CocList extensions<cr>
nnoremap <silent> <leader>cm  :<C-u>CocList marketplace<cr>
" Show commands
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>
nnoremap <silent> <leader>cl  :<C-u>CocList<cr>
" Do default action for next item.
" nnoremap <silent> <leader>gj  :<C-u>CocNext<CR>
nnoremap <silent> ]g  :<C-u>CocNext<CR>
" Do default action for previous item.
" nnoremap <silent> <leader>gk  :<C-u>CocPrev<CR>
nnoremap <silent> [g  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <leader>cr  :<C-u>CocListResume<CR>
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

map <leader>t :CocOutline<CR>
map <leader>ho :call CocAction('showOutgoingCalls')<CR>
map <leader>hi :call CocAction('showIncomingCalls')<CR>
" show outline
" autocmd VimEnter,Tabnew *
"     \ if empty(&buftype) | call CocActionAsync('showOutline', 1) | endif

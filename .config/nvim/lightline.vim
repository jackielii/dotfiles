let g:lightline = {}

let g:lightline.colorscheme = 'base16'

function! CocCurrentFunction()
  let l:s = get(b:, 'coc_current_function', '')
  if empty(l:s) | return '' | else | return '' .. l:s | endif
endfunction

function! CocCurrentPackage()
  let l:s = get(b:, 'coc_current_package', '')
  if empty(l:s) | return '' | else | return ' ' .. l:s | endif
endfunction

function! GitBranch()
  let l:s = FugitiveHead()
  let l:c = '' " get(b:, 'coc_git_status', '')
  if empty(l:s) | return '' | else | return ' ' .. l:s .. l:c | endif
endfunction

let g:lightline.component_function = {
\  'gitbranch': 'GitBranch',
\  'current_function': 'CocCurrentFunction',
\  'current_package': 'CocCurrentPackage'
\ }

let g:lightline.active = {
\ 'left': [
\    [ 'mode', 'paste', 'readonly' ],
\    [ 'gitbranch' ],
\    [ 'current_package', 'filename', 'current_function', 'coc_status' ]
\ ],
\ 'right': [
\    [ 'lineinfo' ],
\    [ 'percent' ],
\    [ 'filetype' ],
\    [ 'coc_info', 'coc_hints', 'coc_errors', 'coc_warnings' ],
\ ]
\}
let g:lightline.tabline = {'left': [['buffers']], 'right': [['tabs']]}
let g:lightline.component_raw = {'buffers': 1}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type = {'buffers': 'tabsel'}
let g:lightline.tab = { 'active': [ 'tabnum' ], 'inactive': [ 'tabnum' ] }

" https://github.com/josa42/vim-lightline-coc
call lightline#coc#register()


" let g:lightline = {
" \ 'active': {
" \   'left': [ [ 'mode', 'paste' ],
" \             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
" \ },
" \ 'component_function': {
" \   'cocstatus': 'coc#status',
" \   'currentfunction': 'CocCurrentFunction'
" \ },
" \ 'tabline': {'left': [['buffers']], 'right': [['close']]},
" \ 'component_expand': {'buffers': 'lightline#bufferline#buffers'},
" \ 'component_type': {'buffers': 'tabsel'},
" \ 'component_raw': {'buffers': 1}
" \ }

" lightline buffline
let g:lightline#bufferline#show_number  = 2
let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#unnamed      = '[No Name]'
let g:lightline#bufferline#clickable    = 1
let g:lightline#bufferline#enable_devicons = 0
let g:lightline#bufferline#icon_position = 'left'
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

function! s:deleteToRight(direction) abort
  let i=0
  while 1
    if i > 50 | break | endif " stop loop during hacking
    let i+=1
    let buf = bufnr('%')
    let current = lightline#bufferline#get_ordinal_number_for_buffer(buf)
    let next = current+1
    if a:direction < 0
      let next = current-1
    endif
    let bufNext = lightline#bufferline#get_buffer_for_ordinal_number(next)
    if next <= 0 || bufNext < 0
      break
    endif
    try
      call lightline#bufferline#delete(next)
    catch
      break
    endtry
  endwhile
endfunction

nmap <silent><leader>dL :call <SID>deleteToRight(1)<CR>
nmap <silent><leader>dH :call <SID>deleteToRight(-1)<CR>

" let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
set showtabline=2



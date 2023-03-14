function! GorunSave()
  let l:pos = getpos('.')
  if getline(1) != '#!/usr/bin/env gorun'
    let @z = '#!/usr/bin/env gorun'
    call append(0, @z)
  else
    norm 1G"zdd
    silent! call CocAction('runCommand', 'editor.action.format')
    silent! call CocAction('runCommand', 'editor.action.organizeImport')
    silent! write
    silent! AsyncTask go-build-file
    norm 1G"zP
  endif
  write
  call setpos('.', l:pos)
endfunction

function! GorunReset()
  let l:pos = getpos('.')
  if getline(1) == '#!/usr/bin/env gorun'
    norm 1Gdd
  endif
  write
  call setpos('.', l:pos)
endfunction

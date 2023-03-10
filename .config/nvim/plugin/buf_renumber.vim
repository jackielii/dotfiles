function! s:BufRenumber()
   " save all buffers
   norm wa
   " save current buffer
   let s:this = expand('%:p')
   " make sure arglist is empty
   argd *
   " add all buffers to arglist
   bufdo argadd %:p
   " close all buffers
   %bw
   " reopen current buffer, so it will be first buffer
   execute 'edit ' .. s:this
   " remove current buffer from arglist
   exec 'argd ' .. s:this
   " reopen all buffers
   argdo edit
   " switch to first buffer
   bfirst
endfunction

command BufRenumber call <sid>BufRenumber()

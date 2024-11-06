local map = vim.keymap.set
local del = vim.keymap.del

del("n", "<leader><space>")

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map("i", "II", "<Esc>I", { silent = true })
map("i", "Ii", "<Esc>i", { silent = true })
map("i", "AA", "<Esc>A", { silent = true })
map("i", "OO", "<Esc>O", { silent = true })
map("i", "UU", "<Esc>u", { silent = true })
map("i", "Pp", "<Esc>P", { silent = true })
map("i", "PP", "<Esc>pa", { silent = true })
map("i", "CC", "<Esc>cc", { silent = true })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>QQ", "<cmd>qa!<cr>", { desc = "Quit all" })

-- move lines up and down
map("x", "<A-j>", ":m '>+1<cr>gv", { silent = true })
map("x", "<A-k>", ":m '<-2<cr>gv", { silent = true })
map("n", "<A-j>", ":m +1<cr>", { silent = true })
map("n", "<A-k>", ":m -2<cr>", { silent = true })

-- map('n', '<M-a>', 'ggVG', { silent = true })
map("n", "<D-a>", "ggVG", { silent = true })
map("i", "<D-a>", "<esc>ggVG", { silent = true })
-- vmap P doesn't change the register :help v_P
map("x", "p", "P", { silent = true })

map({ "n", "i" }, "<Esc>", "<Esc><cmd>nohl<cr>", { silent = true, noremap = true })
for _, key in ipairs({ "<C-s>", "<M-s>", "<D-s>" }) do
  map({ "n", "v", "i", "s" }, key, "<Esc><cmd>update<cr><cmd>nohl<cr>", { silent = true, noremap = true })
end

-- for _, key in ipairs({ "n", "N", "*", "#", "g*", "g#" }) do
--   map("n", key, key .. "zz", { silent = true })
-- end

map("n", "<leader><tab>", "<C-^>", { silent = true })
map("n", "<M-tab>", "<C-^>", { silent = true })
map({ "n", "i" }, "<M-q>", "<Esc><C-^>", { silent = true })
map({ "n", "i" }, "<M-tab>", "<Esc><C-^>", { silent = true })

map("n", "c*", [[:let @/=expand("<cword>")<cr>cgn]], { silent = true, noremap = true })
map("n", "c#", [[:let @/=expand("<cword>")<cr>cgN]], { silent = true, noremap = true })
map("n", "y/", [[:let @/=expand("<cword>")<cr>]], { silent = true, noremap = true })

map("x", "//", [["vy/\V<C-r>=escape(@v,'/\')<cr><cr>N]], { silent = true, noremap = true })
map("x", "<M-/>", "<Esc>/\\%V", { silent = true, noremap = true })
map("x", "<D-/>", "<Esc>/\\%V", { silent = true, noremap = true })
map("x", "$", "g_", { silent = true, noremap = true })
map("n", "yoq", function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end)

vim.cmd([[
augroup comment
  autocmd!
  autocmd FileType jsonc setlocal commentstring=//\ %s
  autocmd FileType typescriptreact setlocal commentstring=//\ %s
  autocmd FileType sql setlocal commentstring=--\ %s
  autocmd FileType proto setlocal commentstring=//\ %s
augroup end
function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)
]])

map("n", "<M-H>", "2<C-w><", { silent = true })
map("n", "<M-J>", "2<C-w>+", { silent = true })
map("n", "<M-K>", "2<C-w>-", { silent = true })
map("n", "<M-L>", "2<C-w>>", { silent = true })

map("n", "<leader><leader>5", function()
  -- local cmd = [[:let @+=expand("%:p")<cr>:echom "copied: " . expand("%:p")<cr>]]
  local print_path = function()
    local path = vim.api.nvim_buf_get_name(0)
    vim.fn.setreg("+", path)
    print("copied: " .. path)
  end
  local ok, noice = pcall(require, "noice")
  if ok then
    noice.redirect(print_path)
  else
    print_path()
  end
end, { silent = true })

-- break undo on common chars
for _, key in ipairs({ " ", ".", ",", "!", "?", "<", "#", "/" }) do
  map("i", key, key .. "<C-g>u", { silent = true, noremap = true })
end

-- nnoremap <leader><leader>x :so % <bar> silent Sleuth<cr>
map("n", "<leader><leader>x", "<cmd>so %<cr>", { silent = true })

vim.cmd([[ function! MoveByWord(flag)
  if mode() == 'v' | execute "norm! gv" | endif
  for n in range(v:count1)
    call search('\v(\w|_|-)+', a:flag, line('.'))
  endfor
endfunction ]])

map({ "n", "v" }, "H", '<cmd>call MoveByWord("b")<cr>', { silent = true })
map({ "n", "n" }, "L", '<cmd>call MoveByWord("")<cr>', { silent = true })

vim.cmd([[ function! ToggleMovement(firstOp, thenOp)
  if mode() == 'v' | execute "norm! gv" | endif
  let pos = getpos('.')
  let c = v:count > 0 ? v:count : ''
  execute "normal! " . c . a:firstOp
  if pos == getpos('.')
    execute "normal! " . c . a:thenOp
  endif
endfunction ]])
map({ "n" }, "0", [[<cmd>call ToggleMovement("^", "0")<cr>]], { silent = true })
map({ "n" }, "^", [[<cmd>call ToggleMovement("^", "0")<cr>]], { silent = true })

-- map("n", "[[", [[<cmd>eval search('{', 'b')<cr>w99[{]], { silent = true, noremap = true })
-- map("n", "][", [[<cmd>eval search('}')<cr>b99]}]], { silent = true, noremap = true })
-- map("n", "]]", [[j0[[%:silent! eval search('{')<cr>]], { silent = true, noremap = true })
-- map("n", "[]", [[k$][%:silent! eval search('}', 'b')<cr>]], { silent = true, noremap = true })

map("n", "<leader>bd", "<cmd>bd<cr>", { silent = true })
map("n", "<leader>bD", "<cmd>bw!<cr>", { silent = true })
map("n", "<leader>bw", "<cmd>bw<cr>", { silent = true })
map("n", "<leader>bW", "<cmd>bw!<cr>", { silent = true })
map("n", "<leader>kn", "<cmd>enew<cr>", { silent = true })

map("n", "<leader>tw", "<cmd>tabclose!<cr>", { silent = true })
map("n", "<leader>tq", "<cmd>tabclose<cr>", { silent = true })

map("c", "<M-b>", [[<cmd>call feedkeys("<C-Left>")<cr>]])
map("c", "<M-f>", [[<cmd>call feedkeys("<C-Right>")<cr>]])
map("c", "<M-Left>", [[<cmd>call feedkeys("<C-Left>")<cr>]])
map("c", "<M-Right>", [[<cmd>call feedkeys("<C-Right>")<cr>]])

-- command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>
vim.api.nvim_create_user_command("R", "new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>", {
  nargs = "*",
  complete = "shellcmd",
})

vim.cmd([[
function! ClearWhitespace()
  let winview = winsaveview()
  let _s=@/
  execute 'keepjumps %s/\s\+$//e'
  let @/=_s
  nohl
  call winrestview(winview)
endfunctio
]])
map("n", "<leader>cw", "<cmd>call ClearWhitespace()<cr>", { silent = true })

vim.cmd([[
command! -nargs=? -complete=dir -bang CloseNonProjectBuffers :call CloseNonProjectBuffers('<args>', '<bang>')
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
]])

-- stylua: ignore start

vim.g.project_root = vim.fn.getcwd()
vim.g.project_path = vim.g.project_root
map("n", "<F1>", [[<cmd>let g:project_path=g:project_root <bar> execute 'lcd '.g:project_path <bar> echo g:project_path<cr>]])
-- map("n", "<F2>", [[<cmd>Glcd <bar> let g:project_path=getcwd() <bar> echo g:project_path<cr>]])
-- map("n", "<F3>", [[:execute 'lcd '.expand('%:p:h') <bar> echo expand('%:p:h') <bar> let g:project_path = expand('%:p:h')<CR>]])
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" } )
map("n", "<F13>", [[:execute 'lcd '.expand('%:p:h') <bar> echo expand('%:p:h') <bar> let g:project_path = expand('%:p:h')<CR>]])

map("n", "<F4>", "<cmd>CloseNonProjectBuffers<cr>")
map("n", "<F2>", function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local win_id = vim.api.nvim_get_current_win()
  require("edgy").toggle()
  -- workaround for edgy.nvim moves the cursor to a different window
  vim.schedule(function()
    vim.api.nvim_set_current_win(win_id)
    vim.api.nvim_win_set_cursor(win_id, cursor_pos)
  end)
end)

-- local lazyterm = function()
--   LazyVim.terminal(nil, { cwd = LazyVim.root() })
-- end
-- map("n", "<c-/>", lazyterm, { desc = "Terminal (Root Dir)" })

-- Terminal Mappings
-- map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
-- map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
-- map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
-- map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
-- map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- toggle options
LazyVim.toggle.map("<leader>uf", LazyVim.toggle.format())
LazyVim.toggle.map("<leader>uF", LazyVim.toggle.format(true))
LazyVim.toggle.map("<leader>us", LazyVim.toggle("spell", { name = "Spelling" }))
LazyVim.toggle.map("<leader>uw", LazyVim.toggle("wrap", { name = "Wrap" }))
LazyVim.toggle.map("<leader>uL", LazyVim.toggle("relativenumber", { name = "Relative Number" }))
LazyVim.toggle.map("<leader>ud", LazyVim.toggle.diagnostics)
LazyVim.toggle.map("<leader>ul", LazyVim.toggle.number)
LazyVim.toggle.map(
  "<leader>uc",
  LazyVim.toggle("conceallevel", { values = { 0, vim.o.conceallevel > 0 and vim.o.conceallevel or 2 } })
)
LazyVim.toggle.map("<leader>uT", LazyVim.toggle.treesitter)
LazyVim.toggle.map("<leader>ub", LazyVim.toggle("background", { values = { "light", "dark" }, name = "Background" }))
if vim.lsp.inlay_hint then
  LazyVim.toggle.map("<leader>uh", LazyVim.toggle.inlay_hints)
end

-- stylua: ignore start
-- lazygit
map("n", "<F6>", function() LazyVim.lazygit({ cwd = LazyVim.root.git() }) end,                          { desc = "Lazygit (Root Dir)" })
map("n", "<leader>glG", function() LazyVim.lazygit() end,                                               { desc = "Lazygit (cwd)" })
map("n", "<leader>glg", function() LazyVim.lazygit({ cwd = LazyVim.root.git() }) end,                   { desc = "Lazygit (Root Dir)" })
map("n", "<leader>glb", LazyVim.lazygit.blame_line,                                                     { desc = "Git Blame Line" })
map("n", "<leader>glB", LazyVim.lazygit.browse,                                                         { desc = "Git Browse" })
map("n", "<leader>gll", function() LazyVim.lazygit({ args = { "log" }, cwd = LazyVim.root.git() }) end, { desc = "Lazygit Log" })
map("n", "<leader>glL", function() LazyVim.lazygit({ args = { "log" } }) end,                           { desc = "Lazygit Log (cwd)" })
map("n", "<leader>glf", function()
  local git_path = vim.api.nvim_buf_get_name(0)
  LazyVim.lazygit({ args = { "-f", vim.trim(git_path) } })
end, { desc = "Lazygit Current File History" })

-- formatting
map({ "n", "v" }, "<leader>kf", function()
  LazyVim.format({ force = true })
end, { desc = "Format" })

_G.__format_operator = function(type)
  local range
  if type == "v" then
    range = {
      start = vim.api.nvim_buf_get_mark(0, "<"),
      ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
    }
  else
    range = {
      start = vim.api.nvim_buf_get_mark(0, "["),
      ["end"] = vim.api.nvim_buf_get_mark(0, "]"),
    }
  end
  LazyVim.format({ range = range })
end
map("v", "<leader>gf", "<cmd>lua __format_operator('v')<CR>", { desc = "Format Visual" })
map("n", "<leader>gf", "<Esc><cmd>set operatorfunc=v:lua.__format_operator<CR>g@", { desc = "Format Operator" })

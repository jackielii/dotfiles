local map = vim.keymap.set
local del = vim.keymap.del

del("n", "<leader><space>")

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map("i", "II", "<Esc>I", { silent = true })
map("i", "Ii", "<Esc>i", { silent = true })
map("i", "AA", "<Esc>A", { silent = true })
map("i", "OO", "<Esc>O", { silent = true })
map("i", "UU", "<C-o>u", { silent = true })
map("i", "Pp", "<Esc>P", { silent = true })
map("i", "PP", "<Esc>pa", { silent = true })
map("i", "CC", "<Esc>cc", { silent = true })
map("i", "CD", "<C-o>c$", { silent = true })
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
map({ "n", "i", "x", "v" }, "<C-s><C-s>", "<Esc><cmd>wa<cr>", { silent = true, noremap = true })

map({ "v" }, "<D-c>", '"+y', { silent = true, noremap = true })
map({ "n" }, "<D-c>", function()
  local reg = vim.fn.getreg('"')
  if reg == "" then
    vim.cmd('normal! gv"+y')
  else
    vim.fn.setreg("+", reg)
  end
end, { silent = true, noremap = true })
map({ "v" }, "<D-v>", '"+p', { silent = true, noremap = true })
map({ "n" }, "<D-v>", function()
  vim.schedule(function()
    local vstart = vim.fn.getpos("'<")
    local vend = vim.fn.getpos("'>")
    if vstart[2] == vend[2] and vstart[3] == vend[3] then
      vim.cmd.normal('"+p')
    else
      vim.cmd.normal('gv"+P')
    end
  end)
end, { silent = true, noremap = true, expr = true })
map({ "i" }, "<D-v>", "<c-r>+", { silent = true, noremap = true })

-- for _, key in ipairs({ "n", "N", "*", "#", "g*", "g#" }) do
--   map("n", key, key .. "zz", { silent = true })
-- end

map("n", "<leader><tab>", "<C-^>", { silent = true, nowait = true })
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

-- map("n", "<leader>bd", "<cmd>bd<cr>", { silent = true })
-- stylua: ignore start
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>bD", function() Snacks.bufdelete({force=true}) end, { desc = "Delete Buffer!" })
map("n", "<leader>bw", function() Snacks.bufdelete({wipe=true}) end, { desc = "Wipeout Buffer" })
map("n", "<leader>bW", function() Snacks.bufdelete({wipe=true, force=true}) end, { desc = "Wipeout Buffer!" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
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

-- stylua: ignore start
-- lazygit
if vim.fn.executable("lazygit") == 1 then
  map("n", "<F6>", function() Snacks.lazygit({ cwd = LazyVim.root.git() }) end,                           { desc = "Lazygit (Root Dir)" })
  map("n", "<leader>gg", function() Snacks.lazygit( { cwd = LazyVim.root.git() }) end, { desc = "Lazygit (Root Dir)" })
  map("n", "<leader>gG", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
  map("n", "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Git Blame Line" })
  map({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse" })
  map("n", "<leader>gf", function() Snacks.lazygit.log_file() end, { desc = "Lazygit Current File History" })
  map("n", "<leader>gl", function() Snacks.lazygit.log({ cwd = LazyVim.root.git() }) end, { desc = "Lazygit Log" })
  map("n", "<leader>gL", function() Snacks.lazygit.log() end, { desc = "Lazygit Log (cwd)" })
end

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

-- -- diagnostic
-- local diagnostic_goto = function(next, severity)
--   local go = next and vim.diagnostic.jump
--   severity = severity and vim.diagnostic.severity[severity] or nil
--   return function()
--     go({ severity = severity })
--   end
-- end
map("n", "<D-i>", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
-- map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
-- map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
-- map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
-- map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
-- map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
-- map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

map({ "n", "i", "x" }, "<F7>", function()
  local nldocs = require("noice.lsp.docs")
  local message = nldocs.get("signature")
  nldocs.hide(message)
  vim.cmd([[NoiceDismiss]])
end, { desc = "Close all floating windows" })

map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })


-- picker mappings
--
map("n", "<C-p>", LazyVim.pick("smart", {multi = {"files"},cwd=vim.g.project_root}), { desc = "File Files (Root Dir)" })
map("n", "<leader>e", LazyVim.pick("buffers"), { desc = "File Buffers" })
map("n", "<leader>ds", LazyVim.pick("lsp_symbols"), {desc = "LSP Document Symbols" })
map("n", "<leader>dS", LazyVim.pick("lsp_workspace_symbols"), {desc = "LSP Workspace Symbols" })
map("n", "<leader>dl", LazyVim.pick("lsp_workspace_symbols"), {desc = "LSP Workspace Symbols" })
map("n", "<leader>da", LazyVim.pick("diagnostics_buffer"), {desc = "Diagnostics Buffer" })
map("n", "<leader>dA", LazyVim.pick("diagnostics"), {desc = "Diagnostics All" })
map("n", "<leader>zg", LazyVim.pick("git_files"), {desc = "Git File" })
map("n", "<leader>zf", function() LazyVim.pick("files", {dirs={vim.fn.expand("%:p:h")}})() end, {desc = "" })
-- map("n", "<leader>zh", LazyVim.pick(), {desc = "" })
-- map("n", "<leader>fa", LazyVim.pick(), {desc = "" })
-- map("n", "<leader>za", LazyVim.pick(), {desc = "" })
map("n", "<leader>cc", LazyVim.pick("commands"), {desc = "Commands" })
map("n", "<leader>p", LazyVim.pick("resume"), {desc = "Picker resume" })
map("n", "<leader>;", LazyVim.pick("pickers"), {desc = "Picker sources" })
map("n", "<leader>km", LazyVim.pick("filetypes"), {desc = "Pick filetypes" })
map("n", "<leader>kh", LazyVim.pick("help"), {desc = "Help" })
map("n", "<leader>k'", LazyVim.pick("marks"), {desc = "Marks" })
-- map("n", "<leader>k<space>", ":lua", {desc = "" })
map("n", "<leader>o", LazyVim.pick("recent", {filter={cwd=true}}), {desc = "Recent files" })
map("n", "<leader>O", LazyVim.pick("recent"), {desc = "Recent Files (All)" })
map("n", "<leader>k:", LazyVim.pick("command_history"), {desc = "Command history" })
map("n", "<leader>k/", LazyVim.pick("search_history"), {desc = "Search history" })
-- map("n", "<leader>ci", LazyVim.pick("grep"), {desc = "" })
map("n", "<leader>/", LazyVim.pick("grep"), {desc = "Live Grep" })
map("n", "<leader>?", function()
  local dir = vim.fn.expand("%:p:h")
  LazyVim.pick("grep", { cwd=dir, title="Grep " .. pretty_path(dir) })()
end, {desc = "Live Grep current file dir" })

map("n", "<leader>dgg", LazyVim.pick("grep_word"), { desc = "Grep word" })
map("v", "<leader>dg", LazyVim.pick("grep_word"), { desc = "Grep word" })
-- stylua: ignore end
_G.__picker_grep_operator = function(type)
  local save = vim.fn.getreg("@")
  if type ~= "char" then
    return
  end
  vim.cmd([[noautocmd sil norm `[v`]y]])
  local word = vim.fn.substitute(vim.fn.getreg("@"), "\n$", "", "g")
  vim.fn.setreg("@", save)
  LazyVim.pick("grep_word", { search = word })()
end
map("n", "<leader>dg", "<Esc><cmd>set operatorfunc=v:lua.__picker_grep_operator<CR>g@", { desc = "Grep Operator" })

map("i", "<tab>", function()
  return LazyVim.cmp.actions.ai_accept() or "<tab>"
end, { expr = true, desc = "Accept Copilot" })
map("i", "<C-h>", function()
  LazyVim.cmp.actions.cmp_disable()
  LazyVim.cmp.actions.ai_disable()
end, { desc = "Disable Completion & Copilot" })
map("i", "<C-l>", function()
  if
    LazyVim.cmp.actions.snippet_change_choice()
    or LazyVim.cmp.actions.snippet_expand()
    or LazyVim.cmp.actions.cmp_insert_next()
  then
    return
  end
  LazyVim.cmp.actions.cmp_enable()
  LazyVim.cmp.actions.ai_enable()
end, { desc = "Enable Completion & Copilot" })
map("x", "<C-l>", function()
  return LazyVim.cmp.actions.snippet_expand_visual()
end, { expr = true })

map({ "i", "s" }, "<C-j>", function()
  return LazyVim.cmp.actions.cmp_select_next()
    or LazyVim.cmp.actions.snippet_forward()
    or LazyVim.cmp.actions.ai_next()
    or LazyVim.cmp.actions.cmp_show()
    or ""
end, { expr = true, desc = "Select Next Completion" })

map({ "i", "s" }, "<C-k>", function()
  return LazyVim.cmp.actions.cmp_select_prev()
    or LazyVim.cmp.actions.snippet_backward()
    or LazyVim.cmp.actions.ai_prev()
    or vim.lsp.buf.signature_help()
    or ""
end, { expr = true, desc = "Select Previous Completion" })

Snacks.toggle
  .new({
    name = "Completion",
    get = function()
      return vim.b.completion == nil or vim.b.completion
    end,
    set = function(state)
      vim.b.completion = state
    end,
  })
  :map("<leader>uc")
Snacks.toggle
  .new({
    name = "Copilot",
    get = function()
      return vim.b.copilot_suggestion_auto_trigger == nil or vim.b.copilot_suggestion_auto_trigger
    end,
    set = function(state)
      vim.b.copilot_suggestion_auto_trigger = state
    end,
  })
  :map("<leader>uC")

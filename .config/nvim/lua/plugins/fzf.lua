return {
  {
    -- dir = "~/personal/fzf-lua",
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    enabled = false,
    cmd = { "FzfLua" },
    keys = {
      {
        "<C-p>",
        function()
          local root = LazyVim.root() or vim.loop.cwd()
          require("fzf-lua").files({ cwd = vim.g.project_path or root })
        end,
        desc = "Find Files",
      },
      { "<leader>zg", [[<cmd>FzfLua git_files<cr>]], desc = "FzfLua Git Files" },
      {
        "<leader>zf",
        function()
          require("fzf-lua").files({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "FzfLua current folder",
      },
      {
        "<leader>zh",
        function()
          require("fzf-lua").files({
            fd_opts = "--color=never --type f --follow -u -E .git -E node_modules",
            cwd = vim.fn.expand("%:p:h"),
          })
        end,
        desc = "FzfLua current folder (with hidden)",
      },
      {
        "<leader>za",
        function()
          require("fzf-lua").files({
            fd_opts = "--color=never --type f --follow -u",
            cwd = vim.fn.expand("%:p:h"),
          })
        end,
        desc = "FzfLua current folder (all files)",
      },

      { "<leader>e", [[<cmd>FzfLua buffers<cr>]], desc = "FzfLua buffers" },
      { "<leader>;", [[<cmd>FzfLua<cr>]], desc = "FzfLua" },
      { "<leader>p", [[<cmd>FzfLua resume<cr>]], desc = "FzfLua resume" },
      { "<leader>o", [[<cmd>FzfLua oldfiles<cr>]], desc = "FzfLua history" },
      {
        "<leader>O",
        function()
          require("fzf-lua").oldfiles({ cwd_only = true })
        end,
        desc = "FzfLua history (current folder)",
      },
      { "<leader>km", [[<cmd>FzfLua filetypes<cr>]], desc = "FzfLua filetypes" },
      { "<leader>kh", [[<cmd>FzfLua help_tags<cr>]], desc = "FzfLua helptags" },
      { "<leader>k'", [[<cmd>FzfLua marks<cr>]], desc = "FzfLua marks" },
      { "<leader>sk", [[<cmd>FzfLua keymaps<cr>]], desc = "FzfLua maps" },
      { "<leader>dgg", [[<cmd>FzfLua grep_cword<cr>]], desc = "FzfLua grep word under cursor" },
      {
        "<leader>dg",
        [[<cmd>FzfLua grep_visual<cr>]],
        desc = "FzfLua grep word under cursor",
        mode = "v",
      },
      { "<leader>dg", desc = "FzfLua grep string operator" },
      { "<leader>k:", [[<cmd>FzfLua command_history<cr>]], desc = "FzfLua history" },
      {
        "<leader>k/",
        [[<cmd>FzfLua search_history<cr>]],
        desc = "FzfLua history search",
      },
      {
        "<leader>/",
        function()
          require("fzf-lua").grep({ input_prompt = "Search " .. vim.fn.getcwd() .. ": " })
        end,
        desc = "FzfLua search string literal (cwd)",
      },
      {
        "<leader>?",
        function()
          require("fzf-lua").grep({
            input_prompt = "Search " .. vim.fn.expand("%:p:h") .. ": ",
          })
        end,
        desc = "FzfLua search string literal (%:p:h)",
      },
      { "<leader>ci", [[<cmd>FzfLua live_grep_resume<cr>]], desc = "FzfLua live grep" },
      { "<leader>cg", [[:FzfLuaGrep<space>]], desc = "FzfLuaGrep" },

      -- map("n", "<leader><leader>r", "<cmd>registers<cr>", { silent = true })
      { "<leader><leader>r", [[<cmd>FzfLua registers<cr>]], desc = "FzfLua registers" },
    },
    opts = {
      fzf_opts = {
        ["--layout"] = "reverse",
      },
      winopts = {
        width = 0.8,
        height = 0.8,
        preview = {
          default = "bat",
          hidden = "nohidden",
          vertical = "up:45%",
          horizontal = "right:50%",
          layout = "flex",
          flip_columns = 120,
        },
      },
      highlights = {
        actions = {
          ["default"] = function(selected)
            for _, v in ipairs(selected) do
              vim.fn.setreg("@", v)
              vim.fn.setreg("+", v)
              vim.cmd("verbose hi " .. v)
            end
          end,
        },
      },
    },
    config = function(_, fzfOpts)
      fzfOpts = vim.tbl_deep_extend("force", require("fzf-lua.defaults").defaults, fzfOpts or {}, {
        keymap = {
          builtin = {
            ["<C-/>"] = "toggle-help",
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
            ["<C-left>"] = "preview-page-reset",
          },
          fzf = {
            ["ctrl-d"] = "half-page-down",
            ["ctrl-u"] = "half-page-up",
            ["ctrl-f"] = "preview-half-page-down",
            ["ctrl-b"] = "preview-half-page-up",
          },
        },
      })

      require("fzf-lua").setup(fzfOpts, true)

      _G.__grep_string_operator = function(type)
        local save = vim.fn.getreg("@")
        if type == "char" then
          vim.cmd([[noautocmd sil norm `[v`]y]])
        else
          return
        end
        local word = vim.fn.substitute(vim.fn.getreg("@"), "\n$", "", "g")
        vim.fn.setreg("@", save)
        require("fzf-lua").grep({ search = word })
      end
      map(
        "n",
        "<leader>dg",
        "<Esc><cmd>set operatorfunc=v:lua.__grep_string_operator<CR>g@",
        { desc = "FzfLua grep operator" }
      )

      local rg_param_args = {
        "-t",
        "--type",
        "-g",
        "--glob",
        "--iglob",
      }
      local rg_args = {
        "-u", -- --no-ignore
        "-uu", -- --no-ignore --hidden
        "-uuu", -- --no-ignore --hidden --binary
        "-w",
        "--word-regexp",
        "--no-ignore",
        "--hidden",
        "-i",
        "--ignore-case",
        "-s",
        "--case-sensitive",
      }
      for i, v in ipairs(rg_param_args) do
        table.insert(rg_args, i, v)
      end

      vim.api.nvim_create_user_command("FzfLuaGrep", function(args)
        local opts, search, i = {}, {}, 1
        while i <= #args.fargs do
          if vim.tbl_contains(rg_args, args.fargs[i]) then
            table.insert(opts, args.fargs[i])
            if vim.tbl_contains(rg_param_args, args.fargs[i]) then
              i = i + 1
              table.insert(opts, args.fargs[i])
            end
          else
            table.insert(search, args.fargs[i])
          end
          i = i + 1
        end
        require("fzf-lua").grep({
          rg_opts = "--column --line-number --no-heading --color=always --smart-case "
            .. "--max-columns=4096 "
            .. table.concat(opts, " ")
            .. " -e",
          search = table.concat(search, " "),
          no_esc = 2,
        })
      end, {
        nargs = "+",
        complete = function(_, line)
          local l = vim.split(line, "%s+")
          return vim.tbl_filter(function(val)
            return vim.startswith(val, l[#l])
          end, rg_args)
        end,
        desc = "Grep using regex",
      })
    end,
  },
}

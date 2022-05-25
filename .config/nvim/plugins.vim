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
Plug 'daviesjamie/vim-base16-lightline'
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
Plug 'airblade/vim-rooter'
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
"Plug 'neoclide/coc-denite'
"Plug 'w0rp/ale'
"Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"Plug 'blueyed/vim-diminactive'
Plug 'szw/vim-maximizer'
Plug 'HerringtonDarkholme/yats.vim' " typescript language support
"Plug 'Shougo/denite.nvim', {'tag': '*'}
"Plug 'Shougo/neomru.vim'
"Plug 'raghur/fruzzy', {'do': { -> fruzzy#install()}}
" Plug 'godlygeek/tabular' " from vimcast: http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
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
Plug 'leoluz/nvim-dap-go' " Dap UI for Go
Plug 'rcarriga/nvim-dap-ui' " Dap widgets

Plug 'neoclide/jsonc.vim' " jsonc for config file types

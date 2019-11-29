" ============================================================================
" General
" ============================================================================
let g:python3_host_prog = '/Users/tetrider/.pyenv/versions/3.7-dev/bin/python'
let g:python2_host_prog = '/Users/tetrider/.pyenv/versions/2.7-dev/bin/python'

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf-8

" With a map leader it's possible to do extra key combinations
let mapleader = "\<Space>"

" Set to auto read when a file is changed from the outside
set autoread

" Save when :!
set autowrite

" Try to recognize the type of the file. Used for syntax highlighting, options
syntax on
filetype on
" Load ftplugin.vim 
filetype plugin on
" Load indent.vim
filetype indent on

" Fast saving
nnoremap ZX :w!<CR><CR>
nnoremap ЯЧ :w!<CR><CR>

" :W sudo saves the file 
" (useful for handling the permission-denied error)
command! W execute 'silent! write !sudo tee % > /dev/null' <bar> edit!

" Enable OS clipboard using, vim-gtk3 package required
set clipboard=unnamed
set guioptions+=a

" Always use vertical diffs
set diffopt+=vertical

" Allow backspacing autoindent
set backspace=indent,eol,start

set lazyredraw                        " Reduce the redraw frequency
set ttyfast                           " Send more characters in fast terminals
tnoremap <Esc> <C-\><C-n>

augroup custom_term
  autocmd!
  autocmd TermOpen * setlocal nonumber norelativenumber modifiable
  au TermClose * call feedkeys("\<cr>")
augroup END


" ============================================================================
" VIM user interface
" ============================================================================

" When scrolling, keep cursor # lines away from screen border
set scrolloff=5

" Relative line numbers
set number
set relativenumber

" Display incomplete commands
set showcmd

" Mouse support
set mouse=a

" Highlight the 80s symbol in the line
highlight ColorColumn ctermbg=52
call matchadd('ColorColumn', '\%80v', 100)

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=

" Properly disable sound on errors on MacVim
" if has("gui_macvim")
"     autocmd GUIEnter * set vb t_vb=
" endif

" Remove delay after pressing ESC
set ttimeoutlen=0

" autocompletion of files and commands behaves like shell
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

highlight Comment cterm=italic gui=italic

" ============================================================================
" Text, tab and indent related
" ============================================================================


" Be smart when using tabs ;)
set smarttab

set expandtab "Expand tabs into spaces
set autoindent "Auto indent
set tabstop=2 shiftwidth=2

" 1 tab == 4 spaces
" autocmd filetype python setlocal
"     \ shiftwidth=4
"     \ tabstop=4
"     \ softtabstop=4
"     \ fileformat=unix

" 1 tab == 2 spaces
" autocmd filetype htmldjango setlocal shiftwidth=2 softtabstop=2

" Wrap
set nowrap  " Don't wrap long lines
set listchars=extends:→  " Show arrow if line continues rightwards
set listchars+=precedes:←  " Show arrow if line continues leftwards

" Display extra whitespaces
set list listchars+=tab:»·,trail:·,nbsp:·


" ============================================================================
" Fast editing and reloading of vimrc configs
" ============================================================================
map <leader>e :e ~/.config/nvim/init.vim<cr>
map <leader>у :e ~/.config/nvim/init.vim<cr>
augroup myvimrchooks
    autocmd!
    autocmd bufwritepost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim
augroup END


" ============================================================================
" Visual mode related
" ============================================================================

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ag '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Better indent, not lose selection
vnoremap > >gv
vnoremap < <gv


" ============================================================================
" Moving around, tabs, windows and buffers
" ============================================================================

" Smart way to move between windows
nnoremap <down> <C-w>j
nnoremap <up> <C-w>k
nnoremap <right> <C-w>l
nnoremap <left> <C-w>h

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright


" ============================================================================
" Search
" ============================================================================

" Searching is not case sensitive
set ignorecase

" If a pattern contains an uppercase letter, it is case sensitive,
" otherwise, it is not
set smartcase

" Increment search and highlight all
set incsearch
set hlsearch

" Disable search highlight
nnoremap <leader><Esc> :<C-u>nohlsearch<CR>

" Toggle ignorecase option
map <leader>/ :set ignorecase!<CR>

" Don't jump to original position after ESC
nnoremap / :call ApplySearch()<CR>/
nnoremap ? :call ApplySearch()<CR>?

function! ApplySearch()
    let g:prev_search = @/
    cnoremap <silent> <ESC> <CR>:noh<CR>:call UnmapEsc()<CR>
    cnoremap <silent> <CR> <CR>:call UnmapCR()<CR>
    cnoremap <silent> <C-c> <C-c>:call UnmapCR()<CR>
endfunction
function! UnmapEsc()
    call UnmapCR()
    let @/ = g:prev_search
endfunction
function! UnmapCR()
    cunmap <ESC>
    cunmap <CR>
    cunmap <C-c>
endfunction


" ============================================================================
" Editing mappings
" ============================================================================

" Remap VIM 0 to first non-blank character
nnoremap 0 ^
nnoremap ^ :normal! 0<CR>

" Swap ; and ,
nnoremap ; ,
vnoremap ; ,
nnoremap Ж ,
vnoremap Ж ,
nnoremap , :normal! ;<CR>
vnoremap , :normal! ;<CR>
nnoremap б :normal! ;<CR>
vnoremap б :normal! ;<CR>

" S for split line
nnoremap S lF<Space>r<CR>
nnoremap Ы lF<Space>r<CR>

" yank to end of line to be consistent with C and D
nnoremap Y y$


" ============================================================================
" Vim-plug initialization
" ============================================================================

let vim_plug_just_installed = 0
let vim_plug_path = expand('~/.config/nvim/autoload/plug.vim')
if !filereadable(vim_plug_path)
    echo "Installing Vim-plug..."
    echo ""
    silent !mkdir -p ~/.config/nvim/autoload
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let vim_plug_just_installed = 1
endif

" manually load vim-plug the first time
if vim_plug_just_installed
    :execute 'source '.fnameescape(vim_plug_path)
endif


" ============================================================================
" Active plugins
" ============================================================================

call plug#begin('~/.config/nvim/plugged')

" Autocomplete, refactoring, linter
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'neoclide/coc-pairs'
Plug 'neoclide/coc-highlight'
Plug 'neoclide/coc-tsserver'
Plug 'neoclide/coc-python'
Plug 'neoclide/coc-json'
Plug 'neoclide/coc-html'
Plug 'neoclide/coc-css'

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
" set signcolumn=yes
set sd
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
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
augroup cocgroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Hightlight word under cursor and matches (:CocInstall coc-highlight)
autocmd CursorHold * silent call CocActionAsync('highlight')
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)
" Execute
nmap <leader>r :CocCommand python.execInTerminal<CR>
vmap <leader>r :CocCommand python.execSelectionInTerminal<CR>

" Terminal Vim with 256 colors colorscheme
Plug 'fisadev/fisa-vim-colorscheme'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
let g:airline_theme = 'bubblegum'
let g:airline_layout = 'powerline'
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>

" Tab list panel
Plug 'kien/tabman.vim'

" Autoclose bracket
" Plug 'Raimondi/delimitMate'

" Better file browser
Plug 'scrooloose/nerdtree'
" toggle nerdtree display
nnoremap <F3> :NERDTreeToggle<CR>
nnoremap <leader>t :NERDTreeToggle<CR>
nnoremap <leader>е :NERDTreeToggle<CR>
" open nerdtree with the current file selected
" nmap ,t :NERDTreeFind<CR>
" don;t show these file types
let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '^__pycache__$', '^env$', '^.env$', '^tags$']
let NERDTreeMapJumpNextSibling = ''
let NERDTreeMapOpenVSplit = 'v'

" folding
Plug 'tmhedberg/SimpylFold'
set foldlevel=1
" accordion expand traversal of folds
nnoremap <silent> z] :<C-u>silent! normal! zc<CR>zjzozz
nnoremap <silent> z[ :<C-u>silent! normal! zc<CR>zkzo[zzz

" Ctrl P
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = '<c-g>'
let g:ctrlp_cmd = 'CtrlP'
" The Silver Searcher
" brew install the_silver_searcher
" apt-get install silversearcher-ag
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " bind \ (backward slash) to grep shortcut
  command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
  " nnoremap <leader>a :Ag<SPACE>
  " nnoremap <leader>ф :Ag<SPACE>
  " nnoremap \ :Ag<Space>
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Ack
" Plug 'mileszs/ack.vim'
" let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated env venv'
" set grepprg=/bin/grep\ -nH
" augroup myvimrchooks2
"     autocmd!
"     autocmd QuickFixCmdPost [^l]* cwindow
"     autocmd QuickFixCmdPost l*    lwindow
" augroup END

" Git wrapper
Plug 'tpope/vim-fugitive'

" Some useful mappings
Plug 'tpope/vim-unimpaired'

" Vim surround
Plug 'tpope/vim-surround'

" Vim repeat
Plug 'tpope/vim-repeat'

" Single line code to multiline and backwards
" Plug 'AndrewRadev/splitjoin.vim'

" This (neo)vim plugin makes scrolling nice and smooth
Plug 'psliwka/vim-smoothie'

" Plug 'severin-lemaignan/vim-minimap'

" Syntax, indent, ftplugin for many languages
Plug 'sheerun/vim-polyglot'
Plug 'mitsuhiko/vim-jinja'

Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_start_level = 2
" let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree']

call plug#end()                       " required

" use 256 colors when possible
if (&term =~? 'mlterm\|xterm\|xterm-256\|screen-256') || has('nvim')
    let &t_Co = 256
    set termguicolors
    colorscheme fisa
    hi CursorColumn ctermbg=239 guibg=#4e4e4e
    hi search ctermbg=241 ctermfg=255 guibg=#626262 guifg=#eeeeee
    hi Normal ctermbg=NONE ctermfg=255 guibg=NONE guifg=#dddddd
    hi NonText ctermbg=NONE guibg=NONE
    hi SignColumn ctermbg=NONE guibg=NONE
    hi LineNr ctermbg=NONE guibg=NONE
    hi MatchParen ctermbg=238 ctermfg=black guibg=#444444 guifg=#000000
    hi Error ctermbg=NONE ctermfg=131 guibg=NONE guifg=#af5f5f
    hi pythonexception ctermfg=131 guifg=#af5f5f
    hi IndentGuidesOdd  ctermbg=NONE guibg=NONE
    hi IndentGuidesEven ctermbg=235 guibg=#262626
    hi String guifg=#5f875f
    hi pythonimport ctermfg=110 guifg=#84a3e3
    hi Comment guifg=#5f5f5f gui=italic ctermfg=59
else
    colorscheme delek
endif
" colors for gvim
if has('gui_running')
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guifont=Source\ Code\ Pro\ for\ Powerline\ 11
    set guicursor+=a:blinkon0 " disable blinking cursor
    colorscheme fisa
    hi Normal guifg=#eeeeee guibg=#202020
endif


" ============================================================================
" Install plugins the first time vim runs
" ============================================================================

if vim_plug_just_installed
    echo "Installing Bundles, please ignore key map error messages"
    :PlugInstall
endif


" ============================================================================
" Another layout support in normal mode
" ============================================================================

set langmap=ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>
nmap ж :
nmap Н Y
nmap з p
nmap ф a
nmap щ o
nmap г u
nmap З P

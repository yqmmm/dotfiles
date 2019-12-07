" =============================================================================
" # Keymap
" =============================================================================
let mapleader = "\<Space>"

"imap jj <Esc>
nnoremap <C-e> 2<C-e>
nnoremap <C-y> 2<C-y>

" Ctrl+h to stop searching
vnoremap <C-h> :nohlsearch<cr>
nnoremap <C-h> :nohlsearch<cr>

" vim-smooth-scroll
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 9, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 9, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 9, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 9, 4)<CR>

map <left> ^
map <right> $

" buffers
set wildchar=<Tab> wildmenu wildmode=full
nnoremap <up> :bp<CR>
nnoremap <down> :bn<CR>

nnoremap <leader><leader> <c-^>

map <Leader> <Plug>(easymotion-prefix)

" LeaderF map
let g:Lf_WindowPosition = 'popup'
let g:Lf_ShortcutF = "<C-p>"
let g:Lf_ShortcutB = "<Leader>;"
noremap <leader>m :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
let g:Lf_CommandMap = {'<C-J>': ['<C-J>', '<Down>'], '<C-K>': ['<C-K>', '<Up>']}

" =============================================================================
" # Editor settings
" =============================================================================

"autocmd BufWritePost ${MYVIMRC} source ${MYVIMRC}  " immediately source .vimrc
set mouse=a

" color
set t_Co=256

set backspace=2

" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-n> :NERDTreeToggle<CR>
let NERDTreeWinPos="right"
let NERDTreeQuitOnOpen=1
let NERDTreeDirArrows=1

colorscheme default

syntax enable
syntax on
filetype plugin on
set nocompatible              " be iMproved, required
filetype off                  " required
set hlsearch		      " highlight render search result, use :noh to close
set incsearch		      " search in real time
set ignorecase		      " search ignore case
set wildmenu		      " vim command auto complete

set clipboard=unnamed

set laststatus=2
set number
"set ruler
"set cursorline

set ts=4 sw=4 et
let g:indent_guides_start_level=1
let g:indent_guides_guide_size=1
let g:indent_guides_enable_on_vim_startup=1

filetype indent on
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

set foldmethod=syntax
set nofoldenable

" Coc Completion
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
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
" Use <c-.> to trigger completion.
inoremap <silent><expr> <c-.> coc#refresh()
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

set hidden
let g:racer_cmd = "/Users/Quack/.cargo/bin/racer"
let g:racer_experimental_completer = 1
" let g:racer_insert_paren = 1

" =============================================================================
" # Plugin
" =============================================================================
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'wakatime/vim-wakatime'
Plug 'terryma/vim-smooth-scroll'
Plug 'easymotion/vim-easymotion'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-rooter'
Plug 'Yggdroot/LeaderF'
Plug 'scrooloose/nerdtree'
Plug 'rust-lang/rust.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'racer-rust/vim-racer'
Plug 'majutsushi/tagbar'
" Plug 'nathangrigg/vim-beancount'
call plug#end()

filetype plugin indent on    " required

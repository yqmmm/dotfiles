" Use GUI colorsetting in TUI
" set termguicolors

colorscheme desert

" vim-gitgutter
" let g:gitgutter_signs = 0
let g:gitgutter_enabled = 0
highlight clear SignColumn
noremap <leader>g :GitGutterToggle<CR>
let g:gitgutter_highlight_linenrs=1
highlight GitGutterAddLineNr ctermfg=46 cterm=bold
highlight GitGutterChangeLineNr ctermfg=Red

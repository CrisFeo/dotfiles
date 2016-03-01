" Plugin Bundles
execute pathogen#infect()

" Color Scheme
set t_Co=256
set background=dark
colo Mustang
syntax on

" Basic Editing
filetype plugin indent on
set shortmess+=I
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set number
set autoread
set hidden
au CursorHold * checktime
function! TrimWhiteSpace()
  %s/\s\+$//e
endfunction
autocmd BufWritePre * :call TrimWhiteSpace()
match Todo /\s\+$/

" Highlight lines that are too long
highlight OverLength ctermbg=124 ctermfg=7
match OverLength /\%81v.\+/

" Fuzzy-finder
so ~/.vim/scripts/fuzzy-finder.vim
nmap <C-\> :call FufSetIgnore() <BAR> :FufFile **/<CR>
nmap <Bar> :FufBuffer<CR>

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['jsxhint']
let g:syntastic_stl_format = " %E{%e error(s)} %W{%w warning(s)} "

" Statusline
set statusline=\ %f\ %m
set statusline+=%=
set statusline+=%#StatusLineErr#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=\ %l:%c\

" Use ag instead of grep
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

" Set up an 'Ag' vim command
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nmap \ :Ag<SPACE>

" NERD Tree
nmap <ESC>\ :NERDTreeToggle<CR>
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore=['\.DS_Store$']

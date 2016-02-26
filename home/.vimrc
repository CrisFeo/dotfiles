" Plugin Bundles
execute pathogen#infect()

" Color Scheme
set t_Co=256
colo Wombat
syntax on

" Basic Editing
filetype plugin indent on
set columns=80
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

" Fuzzy-finder
so ~/.vim/scripts/fuzzy-finder.vim
nmap <C-p> :call FufSetIgnore() <BAR> :FufFile **/<CR>
nmap <S-p> :FufBuffer<CR>

" Syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['jsxhint']
let syntastic_stl_format = " %E{%e error(s)} %W{%w warning(s)} "

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

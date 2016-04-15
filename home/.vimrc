" Plugin Bundles
let g:pathogen_disabled = []
execute pathogen#infect()

" Color Scheme
set t_Co=256
set background=dark
colo Mustang
syntax on

" Shell
set shell=/bin/bash\ -l

" Basic Editing
filetype plugin indent on
set timeoutlen=100
set synmaxcol=120
set shortmess+=I
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set number
set autoread
set hidden
function! TrimWhiteSpace()
  %s/\s\+$//e
endfunction
autocmd BufWritePre * :call TrimWhiteSpace()
match Todo /\s\+$/

" Highlight cursor line
highlight CursorLine ctermbg=236 cterm=NONE
highlight CursorColumn guibg=#3c414c ctermbg=236
set cursorline

" Fzf (Fuzzy Finder)
set rtp+=/usr/local/opt/fzf
let g:fzf_layout = { 'top': '~100%', 'options': '--reverse --color=16,bg+:-1' }
nmap \ :call fzf#vim#ag({},{'options': '--exact --reverse --color=16,bg+:-1'})<CR>
nmap <C-\> :Files<CR>
nmap <Bar> :Buffers<CR>

" Statusline
set statusline=•\ %f\ %m
set statusline+=%=
set statusline+=%#StatusLineErr#
"set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=\ %l:%c\ •

" Use ag instead of grep
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

" NERD Tree
nmap <ESC>\ :NERDTreeToggle<CR>
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore=['\.DS_Store$']

set nocompatible

" Colors
set t_Co=256
syntax on
colorscheme basics

" Italics support
set t_ZH="\e[3m"
set t_ZR="\e[23m"

" Basic editing/UI
filetype plugin indent on
set fillchars=vert:\ ,fold:-
set showmode
set laststatus=0
set timeoutlen=100
set synmaxcol=200
set shortmess+=I
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set autoread
set hidden
set foldmethod=syntax
set foldnestmax=1
set foldlevelstart=99
set conceallevel=2
set cursorline

" Super condensed status/ruler
set statusline=%=%M\ %l
set rulerformat=%=%M\ %l

" netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" Leader key
let mapleader = ','

" More useful buffer info
function! BufferInfo()
  let l:filename = expand('%') ==# '' ? '' : expand('%')
  let l:modified = &mod == 1 ? '+' : ''
  let l:cursor = '('.line('.').':'.col('.').')'
  let l:percent = (line('.') * 100 / line('$')).'%'
  echo ' '.l:filename.' '.l:cursor.' '.l:percent
endfunc
nmap <C-g> :call BufferInfo()<CR>

" Quick buffer switching
nmap <Leader>/ :b#<CR>

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Remove trailing whitespace on save
function! TrimWhiteSpace()
  %s/\s\+$//e
endfunction
autocmd BufWritePre * :call TrimWhiteSpace()
match Todo /\s\+$/

" Togglable search higlighting (defaulting to off)
set nohlsearch
nmap <Leader>. :set hlsearch! hlsearch?<CR>

" Quickly playback macro for register 'q'
nmap <Space> @q

" More convenient section switching
nmap H b
nmap L e
nmap J }
nmap K {
nmap ) $
nmap ( ^

vmap J }
vmap K {
vmap ) $
vmap ( ^

" Set up signcolumn to be toggleable if it exists
if exists("&signcolumn")
  function! SignColumnToggle()
    if &signcolumn ==# 'no'
      set signcolumn=yes
    else
      set signcolumn=no
    endif
  endfunc
  set signcolumn=no
  nmap <leader>; :call SignColumnToggle()<CR>
endif

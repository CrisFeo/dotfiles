set nocompatible

" Colors
set t_Co=256
colorscheme off
syntax on

" Italics support
set t_ZH="\e[3m"
set t_ZR="\e[23m"

" UI settings
set fillchars=vert:\ ,fold:-

" Statusline
set statusline=\ «%f»
set statusline+=%=
set statusline+=%M\ ‹%c›\ %0*

" Basic editing
filetype plugin indent on
set timeoutlen=100
set synmaxcol=200
set shortmess+=I
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set number
set relativenumber
set autoread
set hidden
set foldmethod=syntax
set foldnestmax=1
set foldlevelstart=99
set conceallevel=2

" netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" Default leader
let mapleader = ','

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

" Highlight cursor line
set cursorline

" Quick buffer switching
nmap <Leader>/ :b#<CR>

" Togglable search higlighting
set nohlsearch
nmap <Leader>. :set hlsearch! hlsearch?<CR>

" Quickly macro playback for register 'q'
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

" vim-markdown
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:vim_markdown_fenced_languages = ['json', 'js=javascript']
let g:vim_markdown_new_list_item_indent = 2

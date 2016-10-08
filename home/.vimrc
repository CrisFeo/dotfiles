" Plugins
call plug#begin('~/.vim/plugged')
" Basic
Plug 'tpope/vim-sensible'
Plug 'L9'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-dispatch'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
" Utilities
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Themes
Plug 'morhetz/gruvbox'
" Tooling
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --gocode-completer --tern-completer --omnisharp-completer' }
Plug 'neomake/neomake'
" Syntax/Language support
Plug 'tpope/vim-markdown'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'fatih/vim-go'
Plug 'OmniSharp/omnisharp-vim'
call plug#end()

" Neovim options
set termguicolors
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Color scheme
set background=dark
let g:gruvbox_contrast_dark='hard'
colo gruvbox
syntax on

" UI settings
set fillchars=vert:\ ,fold:-

" Basic editing
filetype plugin indent on
set timeoutlen=100
set synmaxcol=120
set shortmess+=I
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set number
set relativenumber
set autoread
set hidden

" Default leader
let mapleader = ','

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
"
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
:set nohlsearch
nmap <Leader>. :set hlsearch! hlsearch?<CR>

" Quickly macro playback for register 'q'
nmap <Space> @q

" More convenient section switching
nmap J }
nmap K {
nmap ) }
nmap ( {

" Pretty statusline
function! Mode()
  redraw
  let l:mode = mode()
  if     mode ==# 'n'  | exec 'hi! User1 guibg=#7c6f64 guifg=#1d2021'  | return '  NORMAL  '
  elseif mode ==# 'i'  | exec 'hi! User1 guibg=#fabd2f guifg=black'    | return '  INSERT  '
  elseif mode ==# 'v'  | exec 'hi! User1 guibg=#83a598 guifg=white'    | return '  VISUAL  '
  elseif mode ==# 't'  | exec 'hi! User1 guibg=#b8bb26 guifg=black'    | return ' TERMINAL '
  else                 | exec 'hi! User1 guibg=#d3869b guifg=black'    | return '     '.mode.'    '
  endif
endfunc
function! LeftPad(s,amt)
  return repeat(' ',a:amt - len(a:s)) . a:s
endfunc
function! RenderStatusGutter()
  let l:countPlaces = line('$') % 10 + 1
  let l:signs = :sign list
  if empty(signs)
    return LeftPad(col('.'), 2 + countPlaces).' '
  else
    return LeftPad(col('.'), 4 + countPlaces).' '
  endif
endfunc

set statusline=\ «%f»
set statusline+=%=
set statusline+=%M\ ‹%c›\ %1*%{Mode()}%0*

set rulerformat=%#StatusLine#\ %l:%c
set rulerformat+=%=
set rulerformat+=%m\ %1*%{Mode()}%0*

" Use ag instead of grep
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

" Fzf (Fuzzy Finder)
set rtp+=/usr/local/opt/fzf
let $FZF_DEFAULT_COMMAND = 'ag --nocolor --hidden --ignore ".git/" -l'
let g:FZF_OPTIONS = '--color fg:230,bg:235,hl:106,fg+:230,bg+:235,hl+:106,'
                  \.'info:106,prompt:106,spinner:230,pointer:106,marker:166'
let g:fzf_layout = { 'down': '~50%', 'options': g:FZF_OPTIONS }
nmap \ :Ag<CR>
nmap <C-\> :Files<CR>
nmap <Bar> :Buffers<CR>

" Neomake
let g:neomake_verbose = 0
let g:neomake_warning_sign = { 'text': '﹖', 'texthl': 'WarningMsg' }
let g:neomake_error_sign = { 'text': '﹗', 'texthl': 'ErrorMsg' }
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_jsx_enabled_makers = ['eslint']
function! SetEnabledMakers()
  let g:neomake_javascript_enabled_makers = []
  if findfile('.eslintrc', getcwd()) !=# ''
    let g:neomake_javascript_enabled_makers = add(g:neomake_javascript_enabled_makers, 'eslint')
  endif
  if findfile('.jshintrc', getcwd()) !=# ''
    let g:neomake_javascript_enabled_makers = add(g:neomake_javascript_enabled_makers, 'jshint')
  endif
  if g:neomake_javascript_enabled_makers ==# []
    let g:neomake_javascript_enabled_makers = ['eslint']
  endif
  Neomake
endfunc
autocmd! BufWritePost,BufEnter * :call SetEnabledMakers()

" NERD Tree
nmap <M-\> :NERDTreeToggle<CR>
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore=['\.DS_Store$']

" vim-go
let g:go_fmt_command = "goimports"

" vim-easymotion
let g:EasyMotion_do_mapping = 0
map <Leader> <Plug>(easymotion-prefix)
nmap s <Plug>(easymotion-overwin-f)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" vim-markdown
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_fenced_languages = ['json', 'js=javascript', 'bash=sh']

" You Complete Me
let g:ycm_complete_in_comments = 1
let g:ycm_autoclose_preview_window_after_completion = 1

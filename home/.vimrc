" Plugins
call plug#begin('~/.vim/plugged')
  " Basic
  Plug 'L9'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-dispatch'
  Plug 'kopischke/vim-fetch'
  Plug 'tpope/vim-vinegar'
  Plug 'godlygeek/tabular'
  " Utilities
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'crisfeo/fzf.vim'
  " Themes
  Plug 'morhetz/gruvbox'
  " Syntax/Language support
  Plug 'plasticboy/vim-markdown'
  Plug 'pangloss/vim-javascript'
if !exists('g:simple_config')
  " Utilities
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'airblade/vim-gitgutter'
  Plug 'shougo/vimproc.vim', {'do' : 'make'}
  " Tooling
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py --gocode-completer --tern-completer --omnisharp-completer' }
  Plug 'neomake/neomake'
  " Syntax/Language support
  Plug 'eagletmt/ghcmod-vim'
  Plug 'eagletmt/neco-ghc'
  Plug 'itchyny/vim-haskell-indent'
  Plug 'nbouscal/vim-stylish-haskell'
  Plug 'mxw/vim-jsx'
  Plug 'fatih/vim-go'
  Plug 'OmniSharp/omnisharp-vim'
  Plug 'raichoo/purescript-vim'
  Plug 'leafgarland/typescript-vim'
endif
call plug#end()

" Basic options
source ~/.vim/basics.vim

" Colors
syntax on
set termguicolors
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=dark
let g:gruvbox_contrast_dark='hard'
colo gruvbox


" Super minimal status line
hi! link StatusLine GruvboxFg4
function! SetModeColors()
  let l:mode = mode()
  if     mode ==# 'n'  | exec 'hi! link Mode StatusLine'
  elseif mode ==# 'i'  | exec 'hi! link Mode GruvboxYellow'
  elseif mode ==# 'R'  | exec 'hi! link Mode GruvboxYellow'
  elseif mode ==# 'v'  | exec 'hi! link Mode GruvboxPurple'
  elseif mode ==# 'V'  | exec 'hi! link Mode GruvboxPurple'
  elseif mode ==# '' | exec 'hi! link Mode GruvboxPurple'
  elseif mode ==# 't'  | exec 'hi! link Mode GruvboxGreen'
  else                 | exec 'hi! link Mode GruvboxOrange'
  endif
  return ''
endfunc
set noshowmode
set laststatus=0
set rulerformat=%{SetModeColors()}
set rulerformat+=%#Mode#
set rulerformat+=%=%M\ ‹%l›
set rulerformat+=%*

" Allow editing crontab files
autocmd filetype crontab setlocal nobackup nowritebackup

" Use ag instead of grep
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif

" Fzf (Fuzzy Finder)
set rtp+=/usr/local/bin/fzf
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Search'],
  \ 'fg+':     ['fg', 'Normal'],
  \ 'bg+':     ['bg', 'Normal'],
  \ 'hl+':     ['fg', 'Search'],
  \ 'info':    ['fg', 'Normal'],
  \ 'prompt':  ['fg', 'Normal'],
  \ 'pointer': ['fg', 'String'],
  \ 'marker':  ['fg', 'String'],
  \ 'spinner': ['fg', 'Normal'],
  \ 'header':  ['fg', 'Normal'] }
autocmd! User FzfStatusLine setlocal statusline=«fzf»
autocmd VimEnter * command! -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
    \'--follow
    \ --nomultiline
    \ --hidden
    \ --ignore=".git"
    \ --color
    \ --color-match="$AG_MATCH_COLOR"
    \ --color-path="$AG_PATH_COLOR"
    \ --color-line-number="$AG_NUMBER_COLOR"'
    \, fzf#vim#default_layout)
nmap \ :Ag<CR>
nmap <C-\> :Files<CR>
nmap <Bar> :Buffers<CR>

" default netrw binding
nmap <M-\> :Explore<CR>

if !exists('g:simple_config')
  " NERD Tree
  nmap <M-\> :NERDTreeToggle<CR>
  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeIgnore=['\.DS_Store$']

  " GitGutter
  let g:gitgutter_signs = 0
  nmap <leader>; :GitGutterSignsToggle<CR>

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
    let l:mode = mode()
    if mode !=# 't'
      Neomake
    endif
  endfunc
  autocmd! BufWritePost,BufEnter * :call SetEnabledMakers()

  " vim-go
  let g:go_doc_keywordprg_enabled = 0
  let g:go_fmt_command = "goimports"
  let g:neomake_go_gometalinter_args = ['--disable-all', '--enable=errcheck', '--enable=megacheck', '--enable=golint']

  " You Complete Me
  let g:ycm_complete_in_comments = 1
  let g:ycm_autoclose_preview_window_after_completion = 1

  " vim haskell syntax highlighting
  let g:hs_highlight_boolean = 1
  let g:hs_highlight_delimiters = 1
  let g:hs_highlight_types = 1

  " ghcmod-vim
  map <silent> tw :GhcModTypeInsert<CR>
  map <silent> ts :GhcModSplitFunCase<CR>
  map <silent> tq :GhcModType<CR>
  map <silent> te :GhcModTypeClear<CR>

  " neco-ghc
  let g:haskellmode_completion_ghc = 0
  autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
  let g:ycm_semantic_triggers = {'haskell' : ['.']}

endif

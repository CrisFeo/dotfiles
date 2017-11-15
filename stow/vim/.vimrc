set nocompatible

" Colors
set t_Co=256
syntax on
colorscheme basics

" Italics support
set t_ZH=[3m
set t_ZR=[23m

" Set cursor to horizontal bar
silent exec "!printf '\e[4 q'"

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
set nocursorline

if has('wildmenu')
  set wildmenu
  set wildmode=longest,list
  set wildignore+=*.swp,.DS_Store
endif

" Super condensed status/ruler
set statusline=%=%M\ %l
set rulerformat=%=%M\ %l

" netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 0
autocmd FileType netrw setl bufhidden=delete

" Leader key
let mapleader = ','

" More useful buffer info
function! BufferInfo()
  let l:filename = expand('%') ==# '' ? '' : expand('%')
  let l:modified = &mod == 1 ? '+' : ''
  let l:cursor = '('.line('.').':'.col('.').')'
  let l:percent = (line('.') * 100 / line('$')).'%'
  echo ' '.l:filename.' '.l:cursor.' '.l:percent
endfunction
nmap <C-g> :call BufferInfo()<CR>

" Quick swap to last buffer
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
  endfunction
  set signcolumn=no
  nmap <leader>; :call SignColumnToggle()<CR>
endif

" Utility for filtering arbitrary strings via commands
function! ExecuteString(command, string)
  new | setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted
  put =a:string
  normal ggdd
  execute a:command
  let result=getline(1, '$')
  bd
  return result
endfunction

" Quick buffer switching
nmap - :call fzf#run({'source': map(filter(range(1, bufnr('$')), 'bufexists(v:val) && buflisted(v:val)'), 'bufname(v:val)'), 'sink':'b'})<CR>

" Quick file search (Ctrl + <minus>)
nmap  :call fzf#run({'options': '-m', 'sink':'e'})<CR>

" Quick file contents search
function! QuickfixAgSearch(results)
  if (len(a:results) == 0)
    return
  endif
  if (len(a:results) == 1)
    execute 'edit '.ExecuteString("normal 0f:D", a:results)[0]
    return
  endif
  let qfEntries = []
  for entry in a:results
    let filename=ExecuteString("normal 0f:D", entry)[0]
    let lnum=ExecuteString("normal 0f:ld^;D", entry)[0]
    let text=ExecuteString("normal of:;;ld^", entry)[0]
    call add(qfEntries, {"filename": filename, "lnum": lnum, "text": text})
  endfor
  call setqflist(qfEntries, 'r')
  copen
  set nowrap
endfunction
nmap _ :call fzf#run({'options': '-m', 'source': "ag '^.*$'", 'sink*': function('QuickfixAgSearch')})<CR>

" Print out the list of higlight groups that apply to the text at the cursor
command SynStackNames echom 'hi -> 'join(map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")'), ', ')

" Execute the current paragraph in the shell
nmap <Leader><CR> vip:w !source /dev/stdin<CR>


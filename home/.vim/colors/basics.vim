" Super simple color scheme with dynamic light/dark variants. Customization is
" available via the following envvars:
" VIM_BASICS_ACCENT: If defined specifies the color to use as the UI accent.
"                    For acceptable values see: jonasjacek.github.io/colors
" VIM_BASICS_BG:     Acceptable values are 'dark' and 'light' specifying
"                    which brightness background to use.
" Highlight groups based on: github.com/Drogglbecher/vim-moonscape
hi clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name='basics'

" The accent color is used in syntax higlighting for keywords etc. as well as
" for certain areas of the UI that are intended to stand out.
let s:accent = (exists('$VIM_BASICS_ACCENT') ? $VIM_BASICS_ACCENT : 64)

" The three status signifiers are intended for usage where attention needs to
" be drawn to one of several states. For example: Added/Changed/Removed
" indicators for git signs, Warning/Error signs for linters, etc.
let s:green  = 106
let s:yellow = 130
let s:red    = 124

" Base color ramp. These colors, ordered by increasing 'brightness', are used
" for themeing the UI. We use the notion of 'brightness' here so that we are
" able to invert the ramp in case that we want a light background.
let s:ramp = []
call add(s:ramp, 234) " Normal bg
call add(s:ramp, 239)
call add(s:ramp, 245)
call add(s:ramp, 250) " Normal fg
call add(s:ramp, 255)

" Invert the color ramp if we have requested a light background.
if $VIM_BASICS_BG=='light'
  call reverse(s:ramp)
  set background=light
else
  set background=dark
endif

" s:HL sets the highlighting group a:g with the cterm fg, bg, and style
" specified by a:f, a:b, and a:s respectively.
func! s:HL(g, f, b, s)
  exec 'hi '.a:g.' ctermfg='.a:f.' ctermbg='.a:b.' cterm='.a:s
endfunc

call s:HL('Boolean',      s:accent,  'NONE',    'bold')
call s:HL('Character',    s:ramp[4], 'NONE',    'NONE')
call s:HL('ColorColumn',  'NONE',    s:ramp[0], 'NONE')
call s:HL('Comment',      s:ramp[2], 'NONE',    'NONE')
call s:HL('Conditional',  s:ramp[4], 'NONE',    'NONE')
call s:HL('Constant',     s:accent,  'NONE',    'NONE')
call s:HL('Cursor',       s:ramp[1], 'NONE',    'NONE')
call s:HL('CursorLine',   'NONE',    s:ramp[0], 'NONE')
call s:HL('CursorLineNr', s:ramp[0], s:accent,  'NONE')
call s:HL('MatchParen',   s:ramp[0], s:accent,  'NONE')
call s:HL('Define',       s:accent,  'NONE',    'NONE')
call s:HL('Delimiter',    s:accent,  'NONE',    'bold')
call s:HL('DiffAdd',      s:green,   'NONE',    'NONE')
call s:HL('DiffChange',   s:yellow,  'NONE',    'NONE')
call s:HL('DiffDelete',   s:red,     'NONE',    'NONE')
call s:HL('DiffText',     s:ramp[4], 'NONE',    'NONE')
call s:HL('Directory',    s:ramp[2], 'NONE',    'NONE')
call s:HL('Error',        s:red,     s:ramp[0], 'bold')
call s:HL('ErrorMsg',     s:red,     'NONE',    'bold')
call s:HL('FoldColumn',   s:ramp[1], 'NONE',    'NONE')
call s:HL('Folded',       s:ramp[1], 'NONE',    'NONE')
call s:HL('Function',     s:ramp[4], 'NONE',    'NONE')
call s:HL('Identifier',   s:accent,  'NONE',    'bold')
call s:HL('Include',      s:accent,  'NONE',    'NONE')
call s:HL('IncSearch',    s:ramp[3], s:ramp[3], 'NONE')
call s:HL('LineNr',       s:ramp[1], s:ramp[0], 'NONE')
call s:HL('Macro',        s:accent,  'NONE',    'NONE')
call s:HL('NonText',      s:ramp[1], 'NONE',    'NONE')
call s:HL('Normal',       s:ramp[3], s:ramp[0], 'NONE')
call s:HL('Operator',     s:ramp[4], 'NONE',    'NONE')
call s:HL('Pmenu',        s:ramp[4], s:ramp[0], 'NONE')
call s:HL('PmenuSel',     s:ramp[0], s:accent,  'NONE')
call s:HL('PmenuSbar',    s:ramp[4], 'NONE',    'NONE')
call s:HL('PmenuThumb',   s:ramp[4], 'NONE',    'NONE')
call s:HL('PreProc',      s:accent,  'NONE',    'NONE')
call s:HL('Search',       s:ramp[0], s:accent,  'NONE')
call s:HL('Special',      s:accent,  'NONE',    'NONE')
call s:HL('SpecialKey',   s:accent,  'NONE',    'NONE')
call s:HL('SpellBad',     s:red,     'NONE',    'NONE')
call s:HL('SpellCap',     s:accent,  'NONE',    'NONE')
call s:HL('SpellLocal',   s:yellow,  'NONE',    'NONE')
call s:HL('SpellRare',    s:ramp[2], 'NONE',    'NONE')
call s:HL('Statement',    s:ramp[4], 'NONE',    'NONE')
call s:HL('StatusLine',   s:ramp[1], 'NONE',    'NONE')
call s:HL('StatusLineNC', s:ramp[1], 'NONE',    'NONE')
call s:HL('String',       s:accent,  'NONE',    'NONE')
call s:HL('TabLine',      s:ramp[4], 'NONE',    'NONE')
call s:HL('TabLineFill',  'NONE',    s:ramp[4], 'NONE')
call s:HL('TabLineSel',   s:ramp[4], 'NONE',    'NONE')
call s:HL('Tag',          s:accent,  'NONE',    'NONE')
call s:HL('Todo',         s:ramp[0], s:accent,  'NONE')
call s:HL('Type',         s:accent,  'NONE',    'NONE')
call s:HL('TypeDef',      s:accent,  'NONE',    'NONE')
call s:HL('Underlined',   'NONE',    'NONE',    'underline')
call s:HL('VertSplit',    s:ramp[0], 'NONE',    'NONE')
call s:HL('Visual',       s:ramp[0], s:ramp[4], 'NONE')
call s:HL('WarningMsg',   s:yellow,  'NONE',    'NONE')
call s:HL('WildMenu',     s:accent,  'NONE',    'NONE')

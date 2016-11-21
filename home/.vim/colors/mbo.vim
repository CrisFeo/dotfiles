" Dark pastel theme inspired by the atom theme of the same name.
" Author: Cris Feo <feo.cris@gmail.com>
" Maintainer: Cris Feo <feo.cris@gmail.com>

" Initialization
"""""""""""""""""""
set background=dark
highlight clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="MBO"


" Palette
"""""""""""""""""""
let s:mbo = {}

let s:mbo.white_pastel   = ['#ffffec', 000] " variable, def, cursor, qualifier,  json key (.property.attribute), error
let s:mbo.gray_light     = ['#dadada', 000] " line numbers
let s:mbo.gray           = ['#95958a', 000] " comment
let s:mbo.gray_dark      = ['#4e4e4e', 000] " gutters
let s:mbo.gray_very_dark = ['#2c2c2c', 000] " editor background
let s:mbo.gray_greenish  = ['#494b41', 000] " active line background
let s:mbo.gray_brownish  = ['#716C62', 000] " selection background
let s:mbo.black_almost   = ['#242424', 000] " matching bracket

let s:mbo.blue           = ['#9ddfe9', 000] " tag, property, attribute
let s:mbo.blue_dark      = ['#00a8c6', 000] " atom, number, variable2
let s:mbo.orange_light   = ['#ffcf6c', 000] " string
let s:mbo.orange         = ['#ffb928', 000] " keyword
let s:mbo.orange_dark    = ['#f54b07', 000] " link (css, js in html)
let s:mbo.green          = ['#b5bd68', 000] " git diff
let s:mbo.red            = ['#cc6666', 000] " git diff

" Common colors
"""""""""""""""""""

let s:fg = s:mbo.white_pastel
let s:bg = s:mbo.gray_very_dark
let s:active_bg = s:mbo.gray_greenish

let s:ui_fg = s:mbo.gray_very_dark
let s:ui_bg = s:mbo.gray

" Style
"""""""""""""""""""
let s:bold = 'bold,'
let s:italic = 'italic,'
let s:underline = 'underline,'
let s:undercurl = 'undercurl,'
let s:inverse = 'inverse,'

" Highlight func
"""""""""""""""""""
function! s:HL(group, fg, bg, style)
  let histring = [ 'hi', a:group,
        \ 'guifg=' . a:fg[0],   'ctermfg=' . a:fg[1],
        \ 'guibg=' . a:bg[0],   'ctermbg=' . a:bg[1],
        \   'gui=' . a:style,  'cterm=' . a:style
        \ ]
  execute join(histring, ' ')
endfunction

" Editor settings
"""""""""""""""""""
call s:HL('Normal', s:fg, s:bg, 'NONE')
call s:HL('Cursor', s:bg, s:fg, 'NONE')
call s:HL('CursorLine', '', s:active_bg, 'NONE')
call s:HL('LineNr', s:mbo.gray, s:bg, 'NONE')
call s:HL('CursorLineNR', s:mbo.orange_light, s:active_bg, 'NONE')

" Number column
"""""""""""""""""""
call s:HL('CursorColumn', s:fg, s:active_bg, 'NONE')
call s:HL('FoldColumn', s:fg, s:active_bg, 'NONE')
call s:HL('SignColumn', s:fg, s:active_bg, 'NONE')
call s:HL('Folded', s:fg, s:active_bg, 'NONE')

" Tab delimiters
"""""""""""""""""""
call s:HL('VertSplit', s:ui_fg, s:ui_bg, 'NONE')
call s:HL('ColorColumn', s:fg, s:bg, 'NONE')
call s:HL('TabLine', s:fg, s:bg, 'NONE')
call s:HL('TabLineFill', s:fg, s:bg, 'NONE')
call s:HL('TabLineSel', s:fg, s:bg, 'NONE')

" File Navigation
"""""""""""""""""""
call s:HL('Directory', s:mbo.orange_light, s:bg, 'NONE')
call s:HL('Search', s:mbo.gray_very_dark, s:mbo.orange, 'NONE')
call s:HL('IncSearch', s:mbo.gray_very_dark, s:mbo.orange, 'NONE')

" Prompt/Status
"""""""""""""""""""
call s:HL('StatusLine', s:ui_fg, s:ui_bg, 'NONE')
call s:HL('StatusLineNC', s:ui_fg, s:ui_bg, 'NONE')
call s:HL('WildMenu', s:fg, s:mbo.blue, 'NONE')
call s:HL('Question', s:fg, s:bg, 'NONE')
call s:HL('Title', s:fg, s:bg, 'NONE')
call s:HL('ModeMsg', s:fg, s:bg, 'NONE')
call s:HL('MoreMsg', s:fg, s:bg, 'NONE')

" Visual aid
"""""""""""""""""""
call s:HL('MatchParen', s:fg, s:active_bg, 'NONE')
call s:HL('Visual', s:fg, s:active_bg, 'NONE')
call s:HL('VisualNOS', s:fg, s:bg, 'NONE')
call s:HL('NonText', s:mbo.gray_dark, s:bg, 'NONE')

call s:HL('Todo', s:fg, s:bg, 'bold')
call s:HL('Underlined', s:fg, s:bg, 'NONE')
call s:HL('Error', s:mbo.gray_light, s:mbo.orange_dark, 'NONE')
call s:HL('ErrorMsg', s:mbo.red, s:bg, 'NONE')
call s:HL('WarningMsg', s:mbo.orange, s:bg, 'NONE')
call s:HL('Ignore', s:fg, s:bg, 'NONE')
call s:HL('SpecialKey', s:mbo.green, s:bg, 'NONE')

" Variable types
"""""""""""""""""""
call s:HL('Constant', s:mbo.blue_dark, s:bg, 'NONE')
call s:HL('String', s:mbo.orange_light, s:bg, 'NONE')
call s:HL('StringDelimiter', s:mbo.orange_light, s:bg, 'NONE')
call s:HL('Character', s:mbo.orange_light, s:bg, 'NONE')
call s:HL('Number', s:mbo.blue_dark, s:bg, 'NONE')
call s:HL('Boolean', s:mbo.blue_dark, s:bg, 'NONE')
call s:HL('Float', s:mbo.blue_dark, s:bg, 'NONE')

call s:HL('Identifier', s:mbo.blue, s:bg, 'NONE')
call s:HL('Function', s:mbo.blue, s:bg, 'NONE')

" Constructs
"""""""""""""""""""
call s:HL('Statement', s:fg, s:bg, 'NONE')
call s:HL('Conditional', s:mbo.orange, s:bg, 'NONE')
call s:HL('Repeat', s:fg, s:bg, 'NONE')
call s:HL('Label', s:fg, s:bg, 'NONE')
call s:HL('Operator', s:mbo.orange, s:bg, 'NONE')
call s:HL('Keyword', s:fg, s:bg, 'NONE')
call s:HL('Exception', s:fg, s:bg, 'NONE')
call s:HL('Comment', s:mbo.gray, s:bg, 'NONE')

call s:HL('Special', s:fg, s:bg, 'NONE')
call s:HL('SpecialChar', s:fg, s:bg, 'NONE')
call s:HL('Tag', s:fg, s:bg, 'NONE')
call s:HL('Delimiter', s:fg, s:bg, 'NONE')
call s:HL('SpecialComment', s:fg, s:bg, 'NONE')
call s:HL('Debug', s:fg, s:bg, 'NONE')

" C like
"""""""""""""""""""
call s:HL('PreProc', s:fg, s:bg, 'NONE')
call s:HL('Include', s:fg, s:bg, 'NONE')
call s:HL('Define', s:fg, s:bg, 'NONE')
call s:HL('Macro', s:fg, s:bg, 'NONE')
call s:HL('PreCondit', s:fg, s:bg, 'NONE')

call s:HL('Type', s:fg, s:bg, 'NONE')
call s:HL('StorageClass', s:fg, s:bg, 'NONE')
call s:HL('Structure', s:fg, s:bg, 'NONE')
call s:HL('Typedef', s:fg, s:bg, 'NONE')

" Diff
"""""""""""""""""""
call s:HL('DiffAdd', s:mbo.green, s:bg, 'NONE')
call s:HL('DiffChange', s:mbo.orange, s:bg, 'NONE')
call s:HL('DiffDelete', s:mbo.red, s:bg, 'NONE')
call s:HL('DiffText', s:fg, s:bg, 'NONE')

" Completion menu
"""""""""""""""""""
call s:HL('Pmenu', s:fg, s:bg, 'NONE')
call s:HL('PmenuSel', s:fg, s:active_bg, 'NONE')
call s:HL('PmenuSbar', s:fg, s:bg, 'NONE')
call s:HL('PmenuThumb', s:fg, s:bg, 'NONE')

" Spelling
"""""""""""""""""""
call s:HL('SpellBad', s:mbo.red, s:bg, 'NONE')
call s:HL('SpellCap', s:fg, s:bg, 'NONE')
call s:HL('SpellLocal', s:fg, s:bg, 'NONE')
call s:HL('SpellRare', s:fg, s:bg, 'NONE')

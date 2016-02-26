" Vim Color File
" Name:       papirus.vim
" Maintainer: franksn <dhcomputersmg@gmail.com>
"
" Based on bubblegum, erosion, and in the thaw xcolors.

set background=dark
hi clear

if exists("syntax on")
    syntax reset
endif

let g:colors_name="papirus"

"
" preferred groups
" (see `:h w18`)
"
hi Normal          ctermfg=7    ctermbg=8 guifg=#d1c3b8   guibg=#2e2c28    gui=none
hi Comment         ctermfg=2    guifg=#767676

" yellow
hi Constant        ctermfg=3    guifg=#bfbb99
hi String          ctermfg=3    guifg=#bfbb99
hi Character       ctermfg=142    guifg=#afaf00
hi Number          ctermfg=11    guifg=#e6e3ca
hi Boolean         ctermfg=144    guifg=#afaf87
hi Float           ctermfg=11    guifg=#e6e3ca

" pink
hi Identifier      ctermfg=182    guifg=#d7afd7
hi Function        ctermfg=182    guifg=#d7afd7

" blue
hi Statement       ctermfg=12    guifg=#88a1ba
hi Conditional     ctermfg=12    guifg=#88a1ba
hi Repeat          ctermfg=12    guifg=#88a1ba
hi Label           ctermfg=12    guifg=#88a1ba
hi Operator        ctermfg=12    guifg=#88a1ba
hi Keyword         ctermfg=12    guifg=#88a1ba
hi Exception       ctermfg=12    guifg=#88a1ba

" green
hi PreProc         ctermfg=10    guifg=#aec495
hi Include         ctermfg=10    guifg=#aec495
hi Define          ctermfg=10    guifg=#aec495
hi Macro           ctermfg=10    guifg=#aec495
hi PreCondit       ctermfg=10    guifg=#aec495

" purple
hi Type            ctermfg=13    guifg=#948d99
hi StorageClass    ctermfg=13    guifg=#948d99
hi Structure       ctermfg=14    guifg=#7a8735
hi Typedef         ctermfg=14    guifg=#7a8735

" red
hi Special         ctermfg=1    guifg=#8c735a
hi SpecialChar     ctermfg=1    guifg=#8c735a
hi Tag             ctermfg=1    guifg=#8c735a
hi Delimiter       ctermfg=9    guifg=#998a7a
hi SpecialComment  ctermfg=9    guifg=#998a7a
hi Debug           ctermfg=9    guifg=#998a7a

hi Underlined      ctermfg=fg    guifg=fg
hi Ignore          ctermfg=bg    guifg=bg
hi Error           ctermfg=231    ctermbg=167    guifg=#FFFFFF    guibg=#d75f5f
hi Todo            ctermfg=187    ctermbg=8     cterm=none    guifg=#d7d7af    guibg=bg    gui=none

"
" minor groups
"
hi StatusLine      ctermfg=fg     ctermbg=236    cterm=none    guifg=fg    guibg=#303030    gui=none
hi StatusLineNC    ctermfg=243    ctermbg=236    cterm=none    guifg=#767676    guibg=#303030    gui=none
hi TabLine         ctermfg=fg     ctermbg=236    cterm=none    guifg=fg    guibg=#303030    gui=none
hi TabLineSel      ctermfg=fg     ctermbg=8     cterm=none    guifg=fg    guibg=bg    gui=none
hi TabLineFill     ctermfg=fg     ctermbg=236    cterm=none    guifg=fg    guibg=#303030    gui=none

hi Pmenu           ctermfg=fg     ctermbg=236    guifg=fg    guibg=#303030
hi PmenuSel        ctermfg=231    ctermbg=243    guifg=#FFFFFF    guibg=#767676
hi PmenuSbar       ctermfg=231    ctermbg=243    guifg=#FFFFFF    guibg=#767676
hi WildMenu        ctermfg=71     ctermbg=236    cterm=none    guifg=#5FAF5F    guibg=#303030    gui=none

hi Visual          ctermfg=fg     ctermbg=8     cterm=reverse    guifg=fg    guibg=bg    gui=reverse
hi VertSplit       ctermfg=243    ctermbg=236    cterm=none    guifg=#767676    guibg=#303030    gui=none
hi LineNr          ctermfg=243    ctermbg=236    guifg=#767676    guibg=#303030

hi Title           ctermfg=109    guifg=#87AFAF
hi SpecialKey      ctermfg=10    guifg=#aec495
hi NonText         ctermfg=243    guifg=#767676
hi MatchParen      ctermfg=16     ctermbg=72    guifg=#000000    guibg=#5FAF87
hi Directory       ctermfg=103    guifg=#8787AF

hi ErrorMsg        ctermfg=210    ctermbg=8    guifg=#FF8787    guibg=bg
hi WarningMsg      ctermfg=140    guifg=#AF87D7
hi MoreMsg         ctermfg=72    guifg=#5FAF87
hi ModeMsg         ctermfg=222    guifg=#FFD787

hi Search          ctermfg=16     ctermbg=11     cterm=none    guifg=#000000    guibg=#e6e3ca    gui=none
hi IncSearch       ctermfg=231    ctermbg=168     cterm=none    guifg=#FFFFFF    guibg=#D75F87    gui=none
hi Question        ctermfg=38    guifg=#00AFD7

hi Folded          ctermfg=243    ctermbg=8    guifg=#767676    guibg=bg
hi FoldColumn      ctermfg=79     ctermbg=236    guifg=#5FD7AF    guibg=#303030
hi SignColumn      ctermfg=79     ctermbg=236    guifg=#5FD7AF    guibg=#303030
hi ColorColumn     ctermfg=79     ctermbg=236    guifg=#5FD7AF    guibg=#303030

hi CursorColumn    ctermbg=236    cterm=none    guibg=#303030    gui=none
hi CursorLine      ctermbg=236    cterm=none    guibg=#303030    gui=none

hi vimFold         ctermfg=243    guifg=#767676
hi vimCommentTitle ctermfg=fg    guifg=fg
hi helpHyperTextJump ctermfg=74    guifg=#5FAFD7

hi htmlTag         ctermfg=147    guifg=#AFAFFF
hi htmlEndTag      ctermfg=147    guifg=#AFAFFF
hi htmlTagName     ctermfg=175    guifg=#D787AF
hi htmlString      ctermfg=144    guifg=#AFAF87

hi diffFile        ctermfg=243    guifg=#767676
hi diffLine        ctermfg=243    guifg=#767676
hi diffAdded       ctermfg=107    guifg=#87AF5F
hi diffRemoved     ctermfg=175    guifg=#D787AF
hi diffChanged     ctermfg=11    guifg=#e6e3ca

hi diffAdd         ctermfg=16     ctermbg=149    guifg=#000000    guibg=#AFD75F
hi diffDelete      ctermfg=231    ctermbg=fg    guifg=#FFFFFF    guibg=fg
hi diffText        ctermfg=16     ctermbg=211    guifg=#000000    guibg=#FF87AF
hi diffChange      ctermfg=16     ctermbg=217    guifg=#000000    guibg=#FFAFAF
hi diffOldLine     ctermfg=104    guifg=#8787D7

hi SpellBad        ctermfg=210    ctermbg=8      cterm=underline    guifg=#FF8787    guibg=bg    gui=underline
hi SpellCap        ctermfg=9    ctermbg=8      cterm=underline    guifg=#8c735a    guibg=bg    gui=underline
hi SpellRare       ctermfg=181    ctermbg=8      cterm=underline    guifg=#D7AFAF    guibg=bg    gui=underline
hi SpellLocal      ctermfg=3    ctermbg=8      cterm=underline    guifg=#bfbb99    guibg=bg    gui=underline

hi mkdCode         ctermfg=243    guifg=#767676
hi mkdURL          ctermfg=111    guifg=#87AFFF
hi mkdLink         ctermfg=181    guifg=#D7AFAF

hi def link mailSubject Title
hi def link mailQuoted2 mailQuoted1
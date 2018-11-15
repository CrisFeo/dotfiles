# Simple colorscheme

eval %sh{
  accent='rgb:5f8700'

  green='rgb:87af00'
  yellow='rgb:ffd75f'
  red='rgb:af0000'

  base0='rgb:000000'
  base1='rgb:4e4e4e'
  base2='rgb:8a8a8a'
  base3='rgb:bcbcbc'
  base4='rgb:eeeeee'

  echo "
    # For Code
    face global value ${accent}
    face global type ${base3}
    face global variable ${base3}
    face global module ${base3}
    face global function ${base3}
    face global string ${accent}
    face global keyword ${base3}
    face global operator ${base3}
    face global attribute ${base3}
    face global comment ${base2}
    face global meta ${base2}
    face global builtin ${base4}+b

    # For markup
    face global title ${accent}+b
    face global header ${accent}
    face global bold ${base3}+b
    face global italic ${base3}+i
    face global mono ${accent}+i
    face global block ${base3}
    face global link ${accent}+i
    face global bullet ${base3}
    face global list ${base3}

    # builtin facesglobal 
    face global Default ${base3},${base0}
    face global PrimarySelection ${base0},${base3}
    face global SecondarySelection ${base0},${base2}
    face global PrimaryCursor ${base0},${base4}
    face global SecondaryCursor ${base0},${base3}
    face global PrimaryCursorEol ${base0},${accent}
    face global SecondaryCursorEol ${base0},${base3}
    face global LineNumbers ${base0},${base3}
    face global LineNumberCursor ${base0},${base3}+b
    face global MenuForeground ${base0},${base2}
    face global MenuBackground ${base2},${base0}
    face global MenuInfo ${accent},${base0}
    face global Information ${accent},${base0}
    face global Error ${base0},${red}
    face global StatusLine ${base3},${base0}
    face global StatusLineMode ${accent},${base0}
    face global StatusLineInfo ${base3},${base0}
    face global StatusLineValue ${base3},${base0}
    face global StatusCursor ${base0},${base4}
    face global Prompt ${accent},${base0}
    face global MatchingChar ${base3},${base0}+b
    face global BufferPadding ${base2},${base0}
  "
}


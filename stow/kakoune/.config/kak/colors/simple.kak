# Simple colorscheme

%sh{
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
    face value ${accent}
    face type ${base3}
    face variable ${base3}
    face module ${base3}
    face function ${base3}
    face string ${accent}
    face keyword ${base3}
    face operator ${base3}
    face attribute ${base3}
    face comment ${base2}
    face meta ${base3}
    face builtin ${base4}+b

    # For markup
    face title ${accent}+b
    face header ${accent}
    face bold ${base3}+b
    face italic ${base3}+i
    face mono ${accent}+i
    face block ${base3}
    face link ${accent}+i
    face bullet ${base3}
    face list ${base3}

    # builtin faces
    face Default ${base3},${base0}
    face PrimarySelection ${base0},${base3}
    face SecondarySelection ${base0},${base2}
    face PrimaryCursor ${base0},${base4}
    face SecondaryCursor ${base0},${base3}
    face LineNumbers ${base0},${base3}
    face LineNumberCursor ${base0},${base3}+b
    face MenuForeground ${base0},${base2}
    face MenuBackground ${base2},${base0}
    face MenuInfo ${accent},${base0}
    face Information ${accent},${base0}
    face Error ${base0},${red}
    face StatusLine ${base3},${base0}
    face StatusLineMode ${accent},${base0}
    face StatusLineInfo ${base3},${base0}
    face StatusLineValue ${base3},${base0}
    face StatusCursor ${base0},${base4}
    face Prompt ${accent},${base0}
    face MatchingChar ${base3},${base0}+b
    face BufferPadding ${base2},${base0}
  "
}


# Detection
###################

hook -group csharp global BufCreate .*\.cs$ %{
  set buffer filetype csharp
}

# Highlighters
###################

addhl shared/csharp regions
addhl shared/csharp/comment      region '//' $ fill comment
addhl shared/csharp/commentBlock region /\* \*/ fill comment
addhl shared/csharp/string       region '"' (?<!\\)(\\\\)*" fill string
addhl shared/csharp/attribute    region \[ \] fill meta
addhl shared/csharp/code default-region group
addhl shared/csharp/code/numbers regex %{\b-?(0x[0-9a-fA-F]+|\d+)[fdiu]?|'((\\.)?|[^'\\])'} 0:value
eval %sh{
  keywords="break|continue|do|for|foreach|goto|return|while|else|if|switch|case|default|try|catch|finally|throw|when|async|await|using"
  attributes="delegate|enum|interface|namespace|struct|abstract|const|extern|internal|override|private|protected|public|readonly|sealed|static|virtual|volatile"
  types="bool|byte|char|decimal|double|float|int|long|object|sbyte|short|string|T|uint|ulong|ushort|var|void|dynamic"
  values="null|false|true"

  # Add the language's grammar to the static completion list
  printf %s\\n "hook global WinSetOption filetype=csharp %{
    set window static_words ${keywords} ${attributes} ${types} ${values}
  }" | tr '|' ' '

  # Highlight keywords
  printf %s "
    addhl shared/csharp/code/keywords   regex \b(${keywords})\b 0:keyword
    addhl shared/csharp/code/attributes regex \b(${attributes})\b 0:attribute
    addhl shared/csharp/code/types      regex \b(${types})\b 0:type
    addhl shared/csharp/code/values     regex \b(${values})\b 0:value
  "
}

# Hooks
###################

hook -group csharp-highlight global WinSetOption filetype=csharp %{
  addhl window/csharp ref csharp
}

hook -group csharp-highlight global WinSetOption filetype=(?!csharp).* %{
  rmhl window/csharp
}

hook global WinSetOption filetype=csharp %{
  # Just use the indent rules from Javascript cause those are sane for c#
  hook window InsertChar .* -group csharp-indent javascript-indent-on-char
  hook window InsertChar \n -group csharp-indent javascript-indent-on-new-line
}

hook global WinSetOption filetype=(?!csharp).* %{
    remove-hooks window csharp-.+
}

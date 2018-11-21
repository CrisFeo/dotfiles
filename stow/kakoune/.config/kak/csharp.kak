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

# Indentation
###################

define-command -hidden csharp-indent-on-new-line %~
  evaluate-commands -draft -itersel %=
    # preserve previous line indent
    try %{ execute-keys -draft \;K<a-&> }
    # indent after lines ending with { or (
    try %[ execute-keys -draft k<a-x> <a-k> [{(]\h*$ <ret> j<a-gt> ]
    # cleanup trailing white spaces on the previous line
    try %{ execute-keys -draft k<a-x> s \h+$ <ret>d }
    # indent after a switch's case/default statements
    try %[ execute-keys -draft k<a-x> <a-k> ^\h*(case|default).*:$ <ret> j<a-gt> ]
    # indent after if|else|while|for
    try %[ execute-keys -draft \;<a-F>)MB <a-k> \A(if|else|while|for)\h*\(.*\)\h*\n\h*\n?\z <ret> s \A|.\z <ret> 1<a-&>1<a-space><a-gt> ]
  =
~

define-command -hidden csharp-indent-on-char %<
  evaluate-commands -draft -itersel %<
    # align closer token to its opener when alone on a line
    try %/ execute-keys -draft <a-h> <a-k> ^\h+[\]}]$ <ret> m s \A|.\z <ret> 1<a-&> /
  >
>

# Hooks
###################

hook -group csharp-highlight global WinSetOption filetype=csharp %{
  addhl window/csharp ref csharp
}

hook -group csharp-highlight global WinSetOption filetype=(?!csharp).* %{
  rmhl window/csharp
}

hook global WinSetOption filetype=csharp %{
  hook window InsertChar \n -group csharp-indent csharp-indent-on-new-line
  hook window InsertChar .* -group csharp-indent csharp-indent-on-char
}

hook global WinSetOption filetype=(?!csharp).* %{
    remove-hooks window csharp-.+
}

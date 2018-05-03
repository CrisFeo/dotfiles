hook -group csharp global BufCreate .*\.cs$ %{
  set buffer filetype csharp
}

hook -group csharp global BufSetOption filetype=csharp %{
  omnisharp-enable-autocomplete
}

hook -group csharp global BufSetOption filetype=(?!csharp).* %{
  omnisharp-disable-autocomplete
}

declare-option -hidden str omnisharp_complete_tmp_dir
declare-option -hidden completions omnisharp_completions

define-command omnisharp-complete -docstring "Complete the current selection with omnisharp" %{
  %sh{
    dir=$(mktemp -d "${TMPDIR:-/tmp}"/kak-omnisharp.XXXXXXXX)
    printf %s\\n "set buffer omnisharp_complete_tmp_dir ${dir}"
    printf %s\\n "evaluate-commands -no-hooks write ${dir}/buf"
  }
  %sh{
    dir=${kak_opt_omnisharp_complete_tmp_dir}
    (
      request=$(printf '{
        "filename": "%s",
        "line": "%d",
        "column": %d
      }' "$kak_buffile" "$kak_cursor_line" "$kak_cursor_column"
      response = $(curl -s -w '\n%{http_code}' \
        -XPOST 'localhost:2000/autocomplete' \
        -H 'Content-Type:application/json' \
        -d "$request")
      body=$(sed '$d' <<< "$response")
      code=$(tail -n 1 <<< "$response")
      if [ ! $code -eq 200 ]
        exit 1
      fi
      header="${kak_cursor_line}.${kak_cursor_column}@${kak_timestamp}"
      compl=$(echo $body | jq 'map("\(.CompletionText)||\(.DisplayText)")|join(":")')
      printf %s\\n "evaluate-commands -client '${kak_client}' %{
        set buffer=${kak_bufname} omnisharp_completions '${header}:${compl}'
      }" | kak -p ${kak_session}
    ) > /dev/null 2>&1 < /dev/null &
  }
}


define-command omnisharp-enable-autocomplete -docstring "Add omnisharp completion candidates to the completer" %{
  set window completers "option=omnisharp_completions:%opt{completers}"
  hook window -group omnisharp-autocomplete InsertIdle .* %{ try %{
    execute-keys -draft <a-h><a-k>[\w\.].\z<ret>
    omnisharp-complete
  } }
  alias window complete omnisharp-complete
}

define-command omnisharp-disable-autocomplete -docstring "Disable omnisharp completion" %{
  set window completers %sh{ printf %s\\n "'${kak_opt_completers}'" | sed 's/option=omnisharp_completions://g' }
  remove-hooks window omnisharp-autocomplete
  unalias window complete omnisharp-complete
}

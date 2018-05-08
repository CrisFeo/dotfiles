addhl shared regions -default code csharp \
  comment /\* \*/ '' \
  comment '//' $ '' \
  string '"' (?<!\\)(\\\\)*" '' \
  attribute \[ \] ''
addhl shared/csharp/comment fill comment
addhl shared/csharp/string fill string
addhl shared/csharp/attribute fill meta
addhl shared/csharp/code regex %{\b-?(0x[0-9a-fA-F]+|\d+)[fdiu]?|'((\\.)?|[^'\\])'} 0:value
%sh{
  keywords="break continue do for foreach goto return while else if switch case default try catch finally throw when async await using"
  attributes="delegate enum interface namespace struct abstract const extern internal override private protected public readonly sealed static virtual volatile"
  types="bool byte char decimal double float int long object sbyte short string T uint ulong ushort var void dynamic"
  values="null false true"

  join() { printf "%s" "$1" | tr -s ' \n' "$2"; }

  # Add the language's grammar to the static completion list
  printf %s\\n "hook global WinSetOption filetype=csharp %{
    set window static_words '$(join "${keywords}:${attributes}:${types}:${values}" ':')'
  }"

  # Highlight keywords
  printf %s "
    addhl shared/csharp/code regex \b($(join "${keywords}" '|'))\b 0:keyword
    addhl shared/csharp/code regex \b($(join "${attributes}" '|'))\b 0:attribute
    addhl shared/csharp/code regex \b($(join "${types}" '|'))\b 0:type
    addhl shared/csharp/code regex \b($(join "${values}" '|'))\b 0:value
  "
}

hook -group csharp global BufCreate .*\.cs$ %{
  set buffer filetype csharp
}

hook -group csharp global WinSetOption filetype=csharp %{
  omnisharp-enable-autocomplete
  addhl window ref csharp
}

hook -group csharp global WinSetOption filetype=(?!csharp).* %{
  omnisharp-disable-autocomplete
  rmhl window ref csharp
}

decl -hidden str omnisharp_complete_tmp_dir
decl -hidden completions omnisharp_completions

def omnisharp-complete -docstring "Complete the current selection with omnisharp" %{
  eval -no-hooks -draft %{
    decl -hidden str current_word
    decl -hidden str buffer_contents
    exec B<a-i>w
    set buffer current_word "%val{selection}"
    exec \%
    set buffer buffer_contents "%val{selection}"
  }
  nop %sh{(
    kak_eval() {
      printf %s\\n "eval -client '$kak_client' %{$1}" \
      | kak -p $kak_session
    }
    # Formulate the request to Omnisharp
    request=$(
      jq -n \
        --arg file   "$kak_buffile" \
        --arg line   "$kak_cursor_line" \
        --arg column "$kak_cursor_column" \
        --arg buffer "$kak_opt_buffer_contents" \
        --arg word   "$kak_opt_current_word" \
        '{
          Filename: $file,
          Line: $line | tonumber,
          Column: $column | tonumber,
          Buffer: $buffer,
          WordToComplete: $word,
          WantDocumentationForEveryCompletionResult: true,
        }'
    )
    kak_eval "echo -debug 'Omnisharp request: $request'"
    # Send the request and evaluate the response
    response=$(curl -s -w '\n%{http_code}' \
      -XPOST 'localhost:2000/autocomplete' \
      -H 'Content-Type:application/json' \
      -d "$request")
    body=$(sed '$d' <<< "$response")
    code=$(tail -n 1 <<< "$response")
    kak_eval "echo -debug 'Omnisharp response: $response'"
    # If the response was successful parse the body into Kakoune's completion
    # format and submit candidates.
    if [ $code -eq 200 ]; then
      candidates=$(
        jq --raw-output '
          map([
            .CompletionText,
            (.Description | capture("^\n?(?<a>[^\n]*).*") | .a),
            .DisplayText
          ] | join("|"))
          | join(":")' \
        <<< "$body"
      )
      completions=$(
        printf '%d.%d@%d:%s' \
          "$kak_cursor_line" \
          "$kak_cursor_column" \
          "$kak_timestamp" \
          "$candidates"
      )
      kak_eval "echo -debug 'Completions: $completions'"
      kak_eval "set buffer=$kak_bufname omnisharp_completions '$completions'"
    fi
  ) > /dev/null 2>&1 < /dev/null &}
}


def omnisharp-enable-autocomplete -docstring "Add omnisharp completion candidates to the completer" %{
  set window completers "option=omnisharp_completions:%opt{completers}"
  hook window -group omnisharp-autocomplete InsertIdle .* %{ try %{
    execute-keys -draft <a-h><a-k>[\w\.].\z<ret>
    omnisharp-complete
  } }
  alias window complete omnisharp-complete
}

def omnisharp-disable-autocomplete -docstring "Disable omnisharp completion" %{
  set window completers %sh{ printf %s\\n "'${kak_opt_completers}'" | sed 's/option=omnisharp_completions://g' }
  remove-hooks window omnisharp-autocomplete
  unalias window complete omnisharp-complete
}

def omnisharp-jump -docstring "Jump to th C# symbol definition under the cursor using omnisharp" %{
  eval -no-hooks -draft %{
    decl -hidden str buffer_contents
    exec \%
    set buffer buffer_contents "%val{selection}"
  }
  nop %sh{(
    kak_eval() {
      printf %s\\n "eval -client '$kak_client' %{$1}" \
      | kak -p $kak_session
    }
    # Formulate the request to Omnisharp
    request=$(
      jq -n \
        --arg file   "$kak_buffile" \
        --arg line   "$kak_cursor_line" \
        --arg column "$kak_cursor_column" \
        --arg buffer "$kak_opt_buffer_contents" \
        '{
          Filename: $file,
          Line: $line | tonumber,
          Column: $column | tonumber,
          Buffer: $buffer,
        }'
    )
    kak_eval "echo -debug 'Omnisharp request: $request'"
    # Send the request and evaluate the response
    response=$(curl -s -w '\n%{http_code}' \
      -XPOST 'localhost:2000/gotodefinition' \
      -H 'Content-Type:application/json' \
      -d "$request")
    body=$(sed '$d' <<< "$response")
    code=$(tail -n 1 <<< "$response")
    kak_eval "echo -debug 'Omnisharp response: $response'"
    # If the response was successful parse the body to retrieve the target file
    # and line number then jump to it.
    if [ $code -eq 200 ]; then
      destination=$(
      jq --raw-output '
        [.FileName, .Line, .Column]
        | map(@json)
        | join(" ")' \
      <<< "$body")
      if ! [ -z "destination" ]; then
        kak_eval "edit $destination"
      fi
    else
      kak_eval "echo -markup '{Error}Could not find symbol'"
    fi
  ) > /dev/null 2>&1 < /dev/null &}
}

def omnisharp-server -docstring "Start the Omnisharp server in the current directory" %{%sh{
  is_server_running() {
    code="$(curl \
      -s \
      -o /dev/null \
      -w '%{http_code}' \
      localhost:2000/checkreadystatus
    )"
    [ "$code" -eq 200 ]
  }
  # Return immediately if the server is already running
  if is_server_running; then
    echo "echo -markup '{Information}omnisharp already running'"
    exit 0
  fi
  # Make sure Omnisharp is in the PATH
  if ! which omnisharp > /dev/null 2>&1; then
    echo "echo -markup '{Error}omnisharp executable not found'"
    exit 1
  fi
  # Start the server in the background using the Kakoune client as host PID
  logdir=$(mktemp -d "${TMPDIR:-/tmp}"/kak-omnisharp.XXXXXXXX)
  echo "echo -debug 'Omnisharp log directory: $logdir'"
  (
    omnisharp -i localhost -p 2000 -hpid "$PPID" -s "$(pwd)" -v
  ) > "$logdir/out.log" 2> "$logdir/err.log" < /dev/null &
  # Wait for the server to come up before returning
  while ! is_server_running; do
    sleep 1
  done
  echo "echo -markup '{Information}Omnisharp server started!'"
}}

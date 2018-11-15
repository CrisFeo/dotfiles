# Autocomplete
###################

decl -hidden str omnisharp_complete_tmp_dir
decl -hidden completions omnisharp_completions

def omnisharp-complete -docstring "Complete the current selection with omnisharp" %{ eval %sh{
  if [ -z "$kak_opt_omnisharp_host_tmp_dir" ]; then
    echo "echo -markup '{Error}omnisharp host not running'"
     exit
  fi
  # TODO
  echo 'echo -markup {Information}Not implemented'
}}

def omnisharp-enable-autocomplete -docstring "Add omnisharp completion candidates" %{
  set window completers option=omnisharp_completions %opt{completers}
  hook window -group omnisharp-autocomplete InsertIdle .* %{ try %{
    execute-keys -draft <a-h><a-k>[\w\.].\z<ret>
    omnisharp-complete
  } }
  alias window complete omnisharp-complete
}

def omnisharp-disable-autocomplete -docstring "Remove omnisharp completion candidates" %{
  set window completers %sh{ printf %s\\n "$kak_opt_completers" | sed "s/'option=omnisharp_completions'//g" }
  remove-hooks window omnisharp-autocomplete
  unalias window complete omnisharp-complete
}

# Autoformat
###################

def omnisharp-format -docstring "Format the buffer using omnisharp" %{ eval %sh{node -e '
  const buffile = process.env["kak_buffile"];
  const hostDir = process.env["kak_opt_omnisharp_host_tmp_dir"];
  require(process.env["kak_config"] + "/omnisharp")(hostDir, {
    command: "/codeformat",
    arguments: {
      filename: buffile,
      buffer: fs.readFileSync(buffile, "utf8"),
    },
  }, result => {
    if (result.Success === true) {
      fs.writeFileSync(buffile, result.Body.Buffer);
      process.stdout.write("edit!");
    } else {
      process.stdout.write("echo \"Could not format buffer\"");
    }
    process.exit(0);
  });
'}}

# Goto definition
###################

def omnisharp-jump -docstring "Jump to the C# symbol definition under the cursor" %{ eval %sh{
  if [ -z "$kak_opt_omnisharp_host_tmp_dir" ]; then
    echo "echo -markup '{Error}omnisharp host not running'"
     exit
  fi
  # TODO
  echo 'echo -markup {Information}Not implemented'
}}

# Language server
###################

decl -hidden str omnisharp_host_tmp_dir

def omnisharp-start -docstring "Start the omnisharp host application" %{ eval %sh{
  if [ ! -z "$kak_opt_omnisharp_host_tmp_dir" ]; then
    echo 'echo Restarting omnisharp host!'
    kill "$(cat "$kak_opt_omnisharp_host_tmp_dir/pid")"
    rm -rf "$kak_opt_omnisharp_host_tmp_dir"
  fi
  tmpdir=$(mktemp -d "${TMPDIR:-/tmp/}"kak-omnisharp.XXXXXXXX)
  printf 'set global omnisharp_host_tmp_dir %s\n' "$tmpdir"
  echo 'echo -debug "omnisharp host dir:"'
  printf 'echo -debug %%{%s}\n' "$tmpdir"
  inFifo="$tmpdir/in"
  outFifo="$tmpdir/out"
  pidFile="$tmpdir/pid"
  mkfifo "$inFifo" "$outFifo"
  (
    node "$kak_config/omnisharp.js" -hpid "$PPID" -s "$(pwd)" < "$inFifo" > "$outFifo"
    rm "$inFifo"
    rm "$outFifo"
    rm "$pidFile"
  ) > "$tmpdir/log" 2>&1 < /dev/null &
  echo "$!" > "$pidFile"
  echo '{"command":"/checkreadystatus"}' > "$inFifo"
  head -n 1 "$outFifo" > /dev/null 2>&1
}}

# Hooks
###################

hook global WinSetOption filetype=csharp %{
  alias window jump-definition omnisharp-jump
  omnisharp-enable-autocomplete
  hook window BufWritePost .* -group csharp-format omnisharp-format
}

hook global WinSetOption filetype=(?!csharp).* %{
  alias global jump-definition nop
  omnisharp-disable-autocomplete
}

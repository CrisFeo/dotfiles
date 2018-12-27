# Autoformat
###################

def omnisharp-format -docstring "Format the buffer using omnisharp" %{ eval %sh{node -e '
  // kak_opt_omnisharp_host_tmp_dir
  const buffile = process.env["kak_buffile"];
  const request = {
    command: "/codeformat",
    arguments: {
      filename: process.env["kak_buffile"],
      buffer: fs.readFileSync(buffile, "utf8")
    }
  };
  const handler = result => {
    if (result.Success === true) {
      fs.writeFileSync(buffile, result.Body.Buffer);
      process.stdout.write("edit!");
    } else {
      process.stdout.write("echo \"Could not format buffer\"");
    }
    process.exit(0);
  };
  require(process.env["kak_config"] + "/omnisharp")(request, handler);
'}}

# Goto definition
###################

def omnisharp-jump -docstring "Jump to the C# symbol definition under the cursor" %{ eval %sh{node -e '
  // kak_opt_omnisharp_host_tmp_dir
  const buffile = process.env["kak_buffile"];
  const request = {
    command: "/gotodefinition",
    arguments: {
      filename: buffile,
      line: parseInt(process.env["kak_cursor_line"]),
      column: parseInt(process.env["kak_cursor_column"]),
      buffer: fs.readFileSync(buffile, "utf8")
    }
  };
  const handler = result => {
    if (result.Success === true && result.Body.FileName != null) {
      process.stdout.write("edit -existing " + [
        result.Body.FileName,
        result.Body.Line,
        result.Body.Column
      ].map(e => "\"" + e + "\"").join(" "));
    } else {
      process.stdout.write("echo \"Could not jump\"");
    }
    process.exit(0);
  };
  require(process.env["kak_config"] + "/omnisharp")(request, handler);
'}}

# Language server
###################

decl -hidden str omnisharp_host_tmp_dir

def omnisharp-start -docstring "Start the omnisharp host application" %{ eval %sh{
  if [ ! -z "$kak_opt_omnisharp_host_tmp_dir" ]; then
    echo 'echo Restarting omnisharp host!'
    kill "$(cat "$kak_opt_omnisharp_host_tmp_dir/pid")"; :
    rm -rf "$kak_opt_omnisharp_host_tmp_dir"
  fi
  tmpdir=$(mktemp -d "${TMPDIR:-/tmp/}"kak-omnisharp.XXXXXXXX)
  printf 'set global omnisharp_host_tmp_dir %s\n' "$tmpdir"
  echo 'echo -debug "omnisharp host dir:"'
  printf 'echo -debug %%{%s}' "$tmpdir"
  (
    export kak_opt_omnisharp_host_tmp_dir="$tmpdir"
    node "$kak_config/omnisharp.js" -hpid "$PPID" -s "$(pwd)"
    rm "$tmpdir/pid"
  ) > "$tmpdir/log" 2>&1 < /dev/null &
  echo "$!" > "$tmpdir/pid"
  sleep 2
  echo '{"command":"/checkreadystatus","seq":455}' > "$tmpdir/in"
  cat "$tmpdir/out" > /dev/null 2>&1
}}

# Hooks
###################

hook global WinSetOption filetype=csharp %{
  alias window jump-definition omnisharp-jump
  hook window BufWritePost .* -group csharp-format omnisharp-format
}

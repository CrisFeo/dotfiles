hook -group go global BufWritePre .*\.go$ %{
  go-format -use-goimports
}

hook -group go global WinSetOption filetype=go %{
  go-enable-autocomplete
  alias window jump-symbol go-jump
}

hook -group go global WinSetOption filetype=(?!go).* %{
  go-disable-autocomplete
  unalias window jump-symbol go-jump
}


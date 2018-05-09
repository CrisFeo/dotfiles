hook -group go global BufWritePre .*\.go$ %{
  go-format -use-goimports
}

hook -group go global WinSetOption filetype=go %{
  go-enable-autocomplete
  alias window jump go-jump
}

hook -group go global WinSetOption filetype=(?!go).* %{
  go-disable-autocomplete
  unalias window jump go-jump
}


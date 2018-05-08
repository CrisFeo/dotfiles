hook -group go global BufWritePre .*\.go$ %{
  go-format -use-goimports
}

hook -group go global WinSetOption filetype=go %{
  go-enable-autocomplete
}

hook -group go global WinSetOption filetype=(?!go).* %{
  go-disable-autocomplete
}


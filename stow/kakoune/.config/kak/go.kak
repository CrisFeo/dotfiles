hook -group go global BufWritePre .*\.go$ %{
  go-format -use-goimports
}

hook -group go global BufSetOption filetype=go %{
  go-enable-autocomplete
}

hook -group go global BufSetOption filetype=(?!go).* %{
  go-disable-autocomplete
}


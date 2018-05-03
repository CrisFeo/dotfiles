hook -group js global BufCreate .*\.jsx$ %{
  set buffer filetype javascript
}

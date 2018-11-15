hook -group git-commit global WinSetOption filetype=git-commit %{
  rmhl window/git-commit-highlight
  addhl window/git-commit regions
  addhl window/git-commit/comment region '^#' '$' fill comment
  addhl window/git-commit/message default-region group
  addhl window/git-commit/message/title     regex ^[^\n]{0,72}([^\n]*)$ 0:Default 1:Error
  addhl window/git-commit/message/separator regex \A[^\n]*\n([^\n]+)\n 1:Error
  addhl window/git-commit/message/content   regex \A[^\n]{0,72}([^\n]*)\n 0:Information 1:Error
}

hook -group git-commit global WinSetOption filetype=(?!git-commit).* %{
  rmhl window/git-commit
}

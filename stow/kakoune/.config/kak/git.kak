addhl shared regions -default message git-commit \
  comment '^#' $ ''
addhl shared/git-commit/comment fill comment
addhl shared/git-commit/message regex ^[^\n]{0,72}([^\n]*)$ 0:Default 1:Error
addhl shared/git-commit/message regex \A[^\n]{0,72}([^\n]*)\n 0:Information 1:Error
addhl shared/git-commit/message regex \A[^\n]*\n([^\n]+)\n 1:Error


hook -group csharp global WinSetOption filetype=git-commit %{
  addhl window ref git-commit
}

hook -group csharp global WinSetOption filetype=(?!git-commit).* %{
  rmhl window ref git-commit
}

" FuzzyFinder Configuration
" -----------------------------------------------------------------------------
function! FufSetIgnore()

  let ignorefiles = [ $HOME . "/.gitignore", ".gitignore" ]
  let exclude_vcs = '\.(hg|git|bzr|svn|cvs)'
  let ignore = '\v\~$'

  for ignorefile in ignorefiles

    if filereadable(ignorefile)
      for line in readfile(ignorefile)
        if match(line, '^\s*$') == -1 && match(line, '^#') == -1
          let line = substitute(line, '^/', '', '')
          let line = substitute(line, '\.', '\\.', 'g')
          let line = substitute(line, '\*', '.*', 'g')
          let ignore .= '|^' . line
        endif
      endfor
    endif

    let ignore .= '|^' . exclude_vcs
    let g:fuf_coveragefile_exclude = ignore
    let g:fuf_file_exclude = ignore
    let g:fuf_dir_exclude = ignore

  endfor
endfunction

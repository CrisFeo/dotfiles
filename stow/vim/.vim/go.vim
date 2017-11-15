func! Guru(action)
  let fname = expand('%')
  let offset = line2byte(line('.')) + col('.')
  let location = fname.':#'.offset
  silent let result = system('guru '.a:action.' '.shellescape(location))
  return result
endfunc

func! GoDefinition()
  let result = Guru('definition')
  let tokens = split(result, ':')
  if v:shell_error != 0 || len(tokens) < 3
    echom result
    return
  endif
  execute 'e '.tokens[0]
  call cursor(tokens[1], tokens[2])
endfunc

func! GoImports()
  let fname = expand('%')
  silent let result = system('goimports '.shellescape(fname))
  if v:shell_error != 0
    echom result
    return
  endif
  let @h = result
  let l = line('.')
  let c = col('.')
  execute 'normal ggVGd"hpkdd'
  call cursor(l, c)
endfunc

command! -nargs=1 Guru echo Guru(<args>)
command! GoDefinition call GoDefinition()
command! GoImports w | call GoImports() | w

nmap  :GoDefinition<CR>

function! file_protocol#edit() abort
  let expr = expand('<amatch>')
  let info = s:parse(expr)
  let opts = printf('++ff=%s ++enc=%s ++%s', &fileformat, &fileencoding, &binary ? 'bin' : 'nobin')
  execute printf('keepalt keepjumps edit %s %s %s', opts, v:cmdarg, info.path)
  if has_key(info, 'column')
    execute printf('keepjumps normal! %dG%d|zv', info.line, info.column)
  elseif has_key(info, 'line')
    execute printf('keepjumps normal! %dG|zv', info.line)
  endif
endfunction

function! file_protocol#read() abort
  let expr = expand('<amatch>')
  let info = s:parse(expr)
  let opts = printf('++ff=%s ++enc=%s ++%s', &fileformat, &fileencoding, &binary ? 'bin' : 'nobin')
  execute printf('read %s %s %s', opts, v:cmdarg, info.path)
endfunction

function! s:parse(bufname) abort
  let path = matchstr(a:bufname, '^file://\zs.*$')
  let m1 = matchlist(path, '^\(.*\):\(\d\+\):\(\d\+\)$')
  if !empty(m1)
    return {
          \ 'path': s:normpath(m1[1]),
          \ 'line': m1[2] + 0,
          \ 'column': m1[3] + 0,
          \}
  endif
  let m2 = matchlist(path, '^\(.*\):\(\d\+\)$')
  if !empty(m2)
    return {
          \ 'path': s:normpath(m2[1]),
          \ 'line': m2[2] + 0,
          \}
  endif
  return {'path': s:normpath(path)}
endfunction

if !has('win32') || (exists('+shellslash') && &shellslash)
  " /home/john/README.md -> /home/john/README.md
  function! s:normpath(path) abort
    return a:path
  endfunction
else
  " /C/Users/John/README.md -> C:\Users\John\README.md
  function! s:normpath(path) abort
    let path = substitute(a:path, '^/\([a-zA-Z]\)/', '\1:/')
    return fnamemodify(path, 'gs?/?\\?')
  endfunction
endif

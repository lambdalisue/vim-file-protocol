if exists('g:loaded_file_protocol')
  finish
endif
let g:loaded_file_protocol = 1

augroup file_protocol_plugin
  autocmd!
  autocmd BufReadCmd file://* ++nested call file_protocol#edit()
  autocmd FileReadCmd file://* ++nested call file_protocol#read()
augroup END


" File:    blame.vim
" Author:  kmnk <kmnknmk+vim@github.com>
" Version: 0.1.0
" License: MIT License

let s:save_cpo = &cpo
set cpo&vim

function! giti#blame#run(param) "{{{
  let file = a:param.file
  return split(giti#system(printf('blame %s', file)), '\n')
endfunction "}}}

function! giti#blame#format(lines) "{{{
  return map(a:lines, 's:build_line(v:val)')
endfunction "}}}

" local functions
function! s:build_line(line) "{{{
  let matches = matchlist(a:line, '^\([^ ]\+\) \((.\+)\) \(.\+\)$')
  return {
\   'hash'   : matches[1],
\   'detail' : matches[2],
\   'line'   : matches[3],
\ }
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

" File:    grep.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" Copyright: Copyright (C) 2013- grep
" License: MIT Licence {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"     The above copyright notice and this permission notice shall be
"     included in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
"     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

let s:save_cpo = &cpo
set cpo&vim

function! giti#grep#list(pattern) "{{{
  return map(s:get_list(a:pattern), 's:build_grep_result(v:val)')
endfunction "}}}

" local functions {{{
function! s:get_list(pattern)
  let res = giti#system_with_specifics({
        \   'command': "grep -In -- '" . a:pattern . "'",
        \   'ignore_error': 1
        \ })
  if res == '' || type(res) == 0
    return []
  endif
  return split(res, '\n')
endfunction

function! s:build_grep_result(line) "{{{
  let matches = matchlist(a:line, '^\([^:]\+\):\([^:]\+\):\(.\+\)$')
  return {
        \ 'path': matches[1],
        \ 'line': matches[2],
        \ 'detail': matches[3],
        \}
endfunction "}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

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

function! unite#sources#giti#grep#define() "{{{
  return s:source
endfunction "}}}

let s:source = {
\ 'name' : 'giti/grep',
\ 'description' : 'grep results',
\}

function! s:source.gather_candidates(args, context) "{{{
  let pattern = giti#input('Pattern:')

  call unite#print_message('[giti/grep]')
  return map(giti#grep#list(pattern), '{
        \ "word"         : s:build_word(v:val),
        \ "source"       : s:source.name,
        \ "kind"         : "jump_list",
        \ "action__path" : v:val.path,
        \ "action__line" : v:val.line,
        \}')
endfunction "}}}

" local functions {{{
let s:word_format = '%+30s %5s %s'
function! s:build_word(val) "{{{
  return printf(s:word_format,
        \ fnamemodify(a:val.path, ':t'),
        \ a:val.line,
        \ a:val.detail)
endfunction "}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

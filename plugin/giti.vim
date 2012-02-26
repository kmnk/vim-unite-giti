" File:    giti.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

" commands {{{

command! -nargs=* Giti call s:call_giti_system(<q-args>)
function! s:call_giti_system(arg)"{{{
  echo giti#system(a:arg)
endfunction"}}}

command! -nargs=* GitiWithConfirm call s:call_giti_system_with_confirm(<q-args>)
function! s:call_giti_system_with_confirm(arg)"{{{
  echo giti#system_with_confirm(a:arg)
endfunction"}}}

command! -nargs=* GitiPush call s:call_giti_push(<q-args>)
function! s:call_giti_push(arg)"{{{
  let [repository, refspec] = split(a:arg)
  call giti#push#run(repository, refspec)
endfunction"}}}

command! -nargs=0 GitiPushExpressly call s:call_giti_push_expressly()
function! s:call_giti_push_expressly()"{{{
  call giti#push#expressly()
endfunction"}}}

command! -nargs=* GitiDiff call s:call_giti_diff(<q-args>)
function! s:call_giti_diff(arg)"{{{
  call giti#diff#run(split(a:arg))
endfunction"}}}

command! -nargs=* GitiDiffCached call s:call_giti_diff_cached(<q-args>)
function! s:call_giti_diff_cached(arg)"{{{
  call giti#diff#cached(split(a:arg))
endfunction"}}}

" }}}

" local functions {{{
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__


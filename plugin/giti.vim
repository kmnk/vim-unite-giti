" File:    giti.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
if !exists('g:giti_git_command')
  let g:giti_git_command = executable('hub') ? 'hub' : 'git'
endif
" }}}

" commands {{{

command! -nargs=* Giti call s:call_giti_system(<q-args>)
function! s:call_giti_system(arg) "{{{
  echo giti#system(a:arg)
endfunction "}}}

command! -nargs=* GitiWithConfirm call s:call_giti_system_with_confirm(<q-args>)
function! s:call_giti_system_with_confirm(arg) "{{{
  echo giti#system_with_specifics({
\   'command' : a:arg,
\   'with_confirm' : 1,
\ })
endfunction "}}}

command! -nargs=* GitiFetch call s:call_giti_fetch(<q-args>)
function! s:call_giti_fetch(arg) "{{{
  let [repository, refspec] = s:map_param(a:arg)
  echo printf('Fetching "%s" ...', repository)
  echo giti#fetch#run({'repository' : repository})
endfunction "}}}

command! -nargs=* GitiPush call s:call_giti_push(<q-args>)
function! s:call_giti_push(arg) "{{{
  let [repository, refspec] = s:map_param(a:arg)
  echo giti#push#run({'repository' : repository, 'refspec' : refspec})
endfunction "}}}

command! -nargs=* GitiPushWithSettingUpstream call s:call_giti_push_with_setting_upstream(<q-args>)
function! s:call_giti_push_with_setting_upstream(arg) "{{{
  let [repository, refspec] = s:map_param(a:arg)
  echo giti#push#set_upstream({'repository' : repository, 'refspec' : refspec})
endfunction "}}}

command! -nargs=0 GitiPushExpressly call s:call_giti_push_expressly()
function! s:call_giti_push_expressly() "{{{
  echo giti#push#expressly()
endfunction "}}}

command! -nargs=* GitiPull call s:call_giti_pull(<q-args>)
function! s:call_giti_pull(arg) "{{{
  let [repository, refspec] = s:map_param(a:arg)
  echo giti#pull#run({
\   'repository' : repository,
\   'refspec'    : refspec,
\ })
endfunction "}}}

command! -nargs=* GitiPullSquash call s:call_giti_pull_squash(<q-args>)
function! s:call_giti_pull_squash(arg) "{{{
  let [repository, refspec] = s:map_param(a:arg)
  echo giti#pull#squash({
\   'repository' : repository,
\   'refspec'    : refspec,
\ })
endfunction "}}}

command! -nargs=* GitiPullRebase call s:call_giti_pull_rebase(<q-args>)
function! s:call_giti_pull_rebase(arg) "{{{
  let [repository, refspec] = s:map_param(a:arg)
  echo giti#pull#rebase({
\   'repository' : repository,
\   'refspec'    : refspec,
\ })
endfunction "}}}

command! -nargs=0 GitiPullExpressly call s:call_giti_pull_expressly()
function! s:call_giti_pull_expressly() "{{{
  echo giti#pull#expressly()
endfunction "}}}

command! -nargs=* GitiDiff call s:call_giti_diff(<q-args>)
function! s:call_giti_diff(arg) "{{{
  call giti#diff#run({'files' : split(a:arg)})
endfunction "}}}

command! -nargs=* GitiDiffCached call s:call_giti_diff_cached(<q-args>)
function! s:call_giti_diff_cached(arg) "{{{
  call giti#diff#cached({'files' : split(a:arg)})
endfunction "}}}

command! -nargs=* GitiLog call s:call_giti_log(<q-args>)
function! s:call_giti_log(arg) "{{{
  echo giti#log#run(a:arg)
endfunction "}}}

command! -nargs=* GitiLogLine call s:call_giti_log_line(<q-args>)
function! s:call_giti_log_line(arg) "{{{
  echo giti#log#line(a:arg)
endfunction "}}}

" }}}

" local functions {{{
function! s:map_param(param) "{{{
  let params = split(a:param)

  let repository = ''
  let refspec = ''

  if exists('params[0]')
    let repository = params[0]
  endif
  if exists('params[1]')
    let refspec = params[1]
  endif

  return [repository, refspec]
endfunction "}}}
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__


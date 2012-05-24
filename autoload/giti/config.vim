" File:    config.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Version: 0.1.0
" License: MIT Licence

let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! giti#config#run()"{{{
  call giti#config#list()
endfunction"}}}

function! giti#config#list()"{{{
  return extend(
\   extend(
\     map(
\       s:get_list({'location' : 'global'}), '
\       s:build_config_data({
\         "line"     : v:val,
\         "location" : "global"
\       })
\     '),
\     map(
\       s:get_list({'location' : 'system'}), '
\       s:build_config_data({
\         "line"     : v:val,
\         "location" : "system"
\       })
\     ')
\   ),
\   map(
\     s:get_list({'location' : 'local'}), '
\     s:build_config_data({
\       "line"     : v:val,
\       "location" : "local"
\     })
\   ')
\ )
endfunction"}}}

function! giti#config#read(arg)"{{{
  let location = exists('a:arg.location') ? '--' . a:arg.location
\                                         : ''
  return giti#system(join([
\   'config', location, a:arg.key
\ ]))
endfunction"}}}

function! giti#config#write(arg)"{{{
  let location = exists('a:arg.location') ? '--' . a:arg.location
\                                         : ''
  return giti#system_with_specifics({
\   'command' : join([
\     'config', location, a:arg.key, a:arg.value
\   ]),
\   'with_confirm' : 1,
\ })
endfunction"}}}

function! giti#config#remove(arg)"{{{
  let location = exists('a:arg.location') ? '--' . a:arg.location
\                                         : ''
  return giti#system_with_specifics({
\   'command' : join([
\     'config', '--unset', location, a:arg.key
\   ]),
\   'with_confirm' : 1,
\ })
endfunction"}}}

function! giti#config#add(arg)"{{{
  let location = exists('a:arg.location') ? '--' . a:arg.location
\                                         : ''
  return giti#system_with_specifics({
\   'command' : join([
\     'config', '--add', location, a:arg.key, a:arg.value
\   ]),
\   'with_confirm' : 1,
\ })
endfunction"}}}

" local functions {{{

function! s:get_list(arg)"{{{
  let location = exists('a:arg.location') ? '--' . a:arg.location
\                                         : ''
  let res = giti#system_with_specifics({
\   'command'      : 'config ' . location . ' -l',
\   'ignore_error' : 1,
\ })
  if v:shell_error
    return []
  endif
  return split(res, '\n')
endfunction"}}}

function! s:build_config_data(arg)"{{{
  let line = a:arg.line

  let splited = split(line, '=')
  if len(splited) != 2
    echoerr 'invalid config line :' . line
  endif

  let location = exists('a:arg.location') ? '--' . a:arg.location
\                                         : ''

  return {
\   'key'      : splited[0],
\   'value'    : splited[1],
\   'location' : location,
\ }
endfunction"}}}

" }}}

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__

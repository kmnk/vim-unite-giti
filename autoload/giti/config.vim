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
  echo map(s:get_list('local'),  's:build_config_data(v:val, "local")')
  return extend(extend(
\   map(s:get_list('global'), 's:build_config_data(v:val, "global")'),
\   map(s:get_list('system'), 's:build_config_data(v:val, "system")')),
\   map(s:get_list('local'),  's:build_config_data(v:val, "local")')
\ )
endfunction"}}}

function! giti#config#read(key)"{{{
  return giti#system('config ' . a:key)
endfunction"}}}

function! giti#config#write(key, value)"{{{
  return giti#system_with_confirm('config ' . a:key . ' ' . a:value)
endfunction"}}}

function! giti#config#rename(old_key, new_key)"{{{
  return giti#system_with_confirm(printf(
\   'config --rename-section %s %s',
\   a:old_key, a:new_key
\ ))
endfunction"}}}

function! giti#config#delete(key)"{{{
  return giti#config#remove(a:key)
endfunction"}}}

function! giti#config#remove(key)"{{{
  return giti#system_with_confirm('config --remove-section ' . a:key)
endfunction"}}}

function! giti#config#add(key, value)"{{{
  return giti#system_with_confirm('config --add ' . a:key . ' ' a:value)
endfunction"}}}

" local functions {{{


function! s:get_list(...)
  let location = ''
  if len(a:000) == 1
    let location = '--' . a:1
  endif
  let res = giti#system('config ' . location . ' -l')
  if v:shell_error
    return []
  endif
  return split(res, '\n')
endfunction

function! s:build_config_data(line, ...)"{{{
  let splited = split(a:line, '=')
  if len(splited) != 2
    echoerr 'invalid config line :' . a:line
  endif

  let location = ''
  if len(a:000) == 1
    let location = a:1
  endif

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

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
  return extend(extend(
\   map(s:get_list('global'), 's:build_config_data(v:val, "global")'),
\   map(s:get_list('system'), 's:build_config_data(v:val, "system")')),
\   map(s:get_list('local'),  's:build_config_data(v:val, "local")')
\ )
endfunction"}}}

function! giti#config#read(key, ...)"{{{
  let location = s:get_location_option(a:000)
  return giti#system_with_confirm(join([
\   'config', location, key
\ ]))
endfunction"}}}

function! giti#config#write(key, value, ...)"{{{
  let location = s:get_location_option(a:000)
  return giti#system_with_confirm(join([
\   'config', location, key, value
\ ]))
endfunction"}}}

function! giti#config#rename(old_key, new_key, ...)"{{{
  let location = s:get_location_option(a:000)
  return giti#system_with_confirm(join([
\   'config', '--rename-section', location, a:old_key, a:new_key
\ ]))
endfunction"}}}

function! giti#config#remove(key, ...)"{{{
  let location = s:get_location_option(a:000)
  return giti#system_with_confirm(join([
\   'config', '--remove-section', location, a:key
\ ]))
endfunction"}}}

function! giti#config#add(key, value)"{{{
  let location = s:get_location_option(a:000)
  return giti#system_with_confirm(join([
\   'config', '--add', location, a:key, a:value
\ ]))
endfunction"}}}

" local functions {{{

function! s:has_location(rests)"{{{
  if len(a:rests) == 1
    return 1
  endif
  return 0
endfunction"}}}

function! s:get_location_option(rests)"{{{
  if s:has_location(rests)
    return '--' . a:rests[0]
  else
    return ''
  endif
endfunction"}}}

function! s:get_list(...)"{{{
  let location = ''
  if len(a:000) == 1
    let location = '--' . a:1
  endif
  let res = giti#system('config ' . location . ' -l')
  if v:shell_error
    return []
  endif
  return split(res, '\n')
endfunction"}}}

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

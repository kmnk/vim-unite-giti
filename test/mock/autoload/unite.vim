let s:save_cpo = &cpo
set cpo&vim

" variables {{{
" }}}

function! unite#print_message(message) "{{{
  return 'mocked unite#print_message'
endfunction "}}}

function! unite#custom_action(kind, name, action) "{{{
  return 'mocked unite#custom_action'
endfunction "}}}

function! unite#get_context() "{{{
  return {
\   'input' : 'mocked unite#get_context'
\ }
endfunction "}}}

function! unite#start(sources, context) "{{{
  let b:unite_start_called_with = [a:sources, a:context]
  return 'mocked unite#start'
endfunction "}}}

" local functions {{{
" }}}


let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
